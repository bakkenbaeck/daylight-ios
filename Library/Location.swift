import Foundation
import CoreLocation

struct Location {
    
    let coordinate: CLLocationCoordinate2D
    let city: String
    let country: String
    
    init?(placemark: CLPlacemark) {
        guard let coordinate = placemark.location?.coordinate else { return nil }
        guard let locality = placemark.locality else { return nil }
        guard let country = placemark.country else { return nil }
        
        self.init(coordinate: coordinate, city: locality, country: country)
    }
    
    init(coordinate: CLLocationCoordinate2D, city: String, country: String) {
        self.coordinate = coordinate
        self.city = city
        self.country = country
    }
    
    static var current: Location? {
        set {
            if let location = newValue {
                UserDefaults.standard.set(location.coordinate.latitude, forKey: "latitude")
                UserDefaults.standard.set(location.coordinate.longitude, forKey: "longitude")
                UserDefaults.standard.set(location.city, forKey: "city")
                UserDefaults.standard.set(location.country, forKey: "country")
            } else {
                UserDefaults.standard.removeObject(forKey: "latitude")
                UserDefaults.standard.removeObject(forKey: "city")
                UserDefaults.standard.removeObject(forKey: "country")
            }
        }
        
        get {
            let latitude = UserDefaults.standard.object(forKey: "latitude") as? Double
            let longitude = UserDefaults.standard.object(forKey: "longitude") as? Double
            let city = UserDefaults.standard.object(forKey: "city") as? String
            let country = UserDefaults.standard.object(forKey: "country") as? String
            
            if let latitude = latitude, let longitude = longitude, let city = city, let country = country {
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                return Location(coordinate: coordinate, city: city, country: country)
            } else {
                return nil
            }
        }
    }
    
    var sunPhase: SunPhase {
        return todaySuntimes.sunPhase
    }
    
    var daylightLengthProgress: Double {
        return todaySuntimes.daylightLengthProgress
    }
    
    var sunsetTimeString: String {
        return timeFormatter.string(from: todaySuntimes.sunset)
    }
    
    var sunriseTimeString: String {
        return timeFormatter.string(from: todaySuntimes.sunrise)
    }
    
    var dayLengthDifference: Double {
        return dayLengthDifferenceOnDate(today)
    }
    
    func dayLengthDifferenceOnDate(_ date: Date) -> Double {
        let dayBefore = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: date)!
        
        let daySunTimes = suntimes(forDate: date)
        let dayBeforeSunTimes = suntimes(forDate: dayBefore)
        
        let dayLength = daySunTimes.sunset.timeIntervalSince(daySunTimes.sunrise)
        let dayBeforeDayLength = dayBeforeSunTimes.sunset.timeIntervalSince(dayBeforeSunTimes.sunrise)
        
        return dayLength - dayBeforeDayLength
    }
    
    func sunriseForDate(_ date: Date) -> Date {
        return suntimes(forDate: date).sunrise
    }
    
    var yesterdayDaylightLength: Double {
        let yesterdaySuntimes = suntimes(forDate: yesterday)
        return yesterdaySuntimes.sunset.timeIntervalSince(yesterdaySuntimes.sunrise)
    }
    
    var todayDaylightLength: Double {
        return todaySuntimes.sunset.timeIntervalSince(todaySuntimes.sunrise)
    }
    
    var tomorrowDaylightLength: Double {
        let tomorrowSuntimes = suntimes(forDate: tomorrow)
        return tomorrowSuntimes.sunset.timeIntervalSince(tomorrowSuntimes.sunrise)
    }
    
    var today: Date {
        return Calendar.autoupdatingCurrent.startOfDay(for: Date())
    }
    
    var tomorrow: Date {
        return Calendar.autoupdatingCurrent.date(byAdding: .day, value: 1, to: today)!
    }
    
    var yesterday: Date {
        return Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: today)!
    }
    
    func suntimes(forDate date: Date) -> SunCalc {
        return SunCalc(date: date, timeZone: TimeZone.autoupdatingCurrent, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
    }
    
    var todaySuntimes: SunCalc {
        return suntimes(forDate: today)
    }
    
    var timeFormatter: DateFormatter = {
        let shortTimeFormatter = DateFormatter()
        shortTimeFormatter.dateFormat = "HH:mm"
        
        return shortTimeFormatter
    }()
}
