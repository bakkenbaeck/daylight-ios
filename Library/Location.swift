import Foundation
import CoreLocation
import Sunrise

struct Location {
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

            if let latitude = latitude, let longitude  = longitude, let city = city, let country = country {
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                return Location(coordinate: coordinate, city: city, country: country)
            } else {
                return nil
            }
        }
    }

    var sunPhase: SunPhase {
        return SunPhase.get(for: Date(), in: .autoupdatingCurrent, at: self.coordinate)
    }

    var dayLengthProgress: Double {
        return self.calculateProgress(date: Date(), timeZone: .autoupdatingCurrent, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
    }

    func calculateProgress(date: Date, timeZone: TimeZone, latitude: Double, longitude: Double) -> Double {
        let sunriseSet = SunriseSet(date: date, timeZone: timeZone, latitude: latitude, longitude: longitude)

        let timeSinceSunrise = date.timeIntervalSince(sunriseSet.sunrise)
        if date.isBetween(sunriseSet.sunrise, and: sunriseSet.sunset) {
            let totalDaylightDuration = sunriseSet.sunset.timeIntervalSince(sunriseSet.sunrise)
            return timeSinceSunrise / totalDaylightDuration
        } else if timeSinceSunrise > 0 {
            return 1
        } else {
            return 0
        }
    }
}
