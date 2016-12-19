import Foundation
import CoreLocation
import Suntimes

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
        let sunriseSet = Suntimes(date: Date(), timeZone: .autoupdatingCurrent, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)

        return sunriseSet.sunPhase
    }

    var daylightLengthProgress: Double {
        let sunriseSet = Suntimes(date: Date(), timeZone: .autoupdatingCurrent, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)

        return sunriseSet.daylightLengthProgress
    }
}
