import Foundation
import CoreLocation

struct Location {
    lazy var timeFormatter: DateFormatter = {
        let shortTimeFormatter = DateFormatter()
        shortTimeFormatter.dateFormat = "HH:MM"

        return shortTimeFormatter
    }()

    let coordinate: CLLocationCoordinate2D
    let city: String
    let country: String

    init?(placemark: CLPlacemark) {
        guard let coordinate = placemark.location?.coordinate else { return nil }
        guard let locality = placemark.locality else { return nil }
        guard let country = placemark.country else { return nil }

        self.coordinate = coordinate
        self.city = locality
        self.country = country
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

    var isNight: Bool {
        return self.sunPhase == .night
    }

    var sunPhase: SunPhase {
        let sunCalc = SunCalc(date: Date(), timeZone: TimeZone.autoupdatingCurrent, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)

        return sunCalc.sunPhase
    }

    var daylightLengthProgress: Double {
        let sunCalc = SunCalc(date: Date(), timeZone: TimeZone.autoupdatingCurrent, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)

        return sunCalc.daylightLengthProgress
    }

    var sunsetTimeString: String {
        let today = Calendar.autoupdatingCurrent.startOfDay(for: Date())

        let todaySuntimes = SunCalc(date: today, timeZone: TimeZone.autoupdatingCurrent, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        let sunset = todaySuntimes.sunset

        let shortTimeFormatter = DateFormatter()
        shortTimeFormatter.dateFormat = "HH:MM"

        return shortTimeFormatter.string(from: sunset)
    }

    var sunriseTimeString: String {
        let today = Calendar.autoupdatingCurrent.startOfDay(for: Date())

        let todaySuntimes = SunCalc(date: today, timeZone: TimeZone.autoupdatingCurrent, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        let sunrise = todaySuntimes.sunrise
        let shortTimeFormatter = DateFormatter()
        shortTimeFormatter.dateFormat = "HH:MM"

        return shortTimeFormatter.string(from: sunrise)
    }

    var dayLengthDifference: Double {
        let today = Calendar.autoupdatingCurrent.startOfDay(for: Date())
        let yesterday = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: today)!

        let todaySuntimes = SunCalc(date: today, timeZone: TimeZone.autoupdatingCurrent, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        let yesterdaySuntimes = SunCalc(date: yesterday, timeZone: TimeZone.autoupdatingCurrent, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)

        let todayDayLength = todaySuntimes.sunset.timeIntervalSince(todaySuntimes.sunrise)
        let yesterdayDayLength = yesterdaySuntimes.sunset.timeIntervalSince(yesterdaySuntimes.sunrise)

        let interval = todayDayLength - yesterdayDayLength

        return interval
    }

    func dayLengthDifferenceOnDate(_ date: Date) -> Double {
        let dayBefore = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: date)!

        let daySunTimes = SunCalc(date: date, timeZone: TimeZone.autoupdatingCurrent, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        let dayBeforeSunTimes = SunCalc(date: dayBefore, timeZone: TimeZone.autoupdatingCurrent, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)

        let dayLength = daySunTimes.sunset.timeIntervalSince(daySunTimes.sunrise)
        let dayBeforeDayLength = dayBeforeSunTimes.sunset.timeIntervalSince(dayBeforeSunTimes.sunrise)

        let interval = dayLength - dayBeforeDayLength

        return interval
    }

    func sunriseForDate(_ date: Date) -> Date {
        let daySunTimes = SunCalc(date: date, timeZone: TimeZone.autoupdatingCurrent, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)

        return daySunTimes.sunrise
    }

    var yesterdayDaylightLength: Double {
        let today = Calendar.autoupdatingCurrent.startOfDay(for: Date())
        let yesterday = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: today)!
        let yesterdaySuntimes = SunCalc(date: yesterday, timeZone: TimeZone.autoupdatingCurrent, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)

        return yesterdaySuntimes.sunset.timeIntervalSince(yesterdaySuntimes.sunrise)
    }

    var todayDaylightLength: Double {
        let today = Calendar.autoupdatingCurrent.startOfDay(for: Date())
        let todaySuntimes = SunCalc(date: today, timeZone: TimeZone.autoupdatingCurrent, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)

        return todaySuntimes.sunset.timeIntervalSince(todaySuntimes.sunrise)
    }

    var tomorrowDaylightLength: Double {
        let today = Calendar.autoupdatingCurrent.startOfDay(for: Date())
        let tomorrow = Calendar.autoupdatingCurrent.date(byAdding: .day, value: 1, to: today)!
        let tomorrowSuntimes = SunCalc(date: tomorrow, timeZone: TimeZone.autoupdatingCurrent, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)

        return tomorrowSuntimes.sunset.timeIntervalSince(tomorrowSuntimes.sunrise)
    }
}
