import Foundation
import CoreLocation

struct Location {

    enum Hemisphere {
        case northern
        case southern

        init(latitude: CLLocationDegrees) {
            if latitude > 0 {
                self = .northern
            } else {
                self = .southern
            }
        }
    }

    private let calendar = Calendar.autoupdatingCurrent
    
    let coordinates: CLLocationCoordinate2D
    let city: String
    let country: String

    let hemisphere: Hemisphere

    var sunTime: SunTime

    static var current: Location? {
        set {
            if let location = newValue {
                UserDefaults.standard.set(location.coordinates.latitude, forKey: "latitude")
                UserDefaults.standard.set(location.coordinates.longitude, forKey: "longitude")
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

    init?(placemark: CLPlacemark) {
        guard let coordinate = placemark.location?.coordinate else { return nil }
        guard let city = placemark.locality else { return nil }
        guard let country = placemark.country else { return nil }

        self.init(coordinate: coordinate, city: city, country: country)
    }

    init(coordinate: CLLocationCoordinate2D, city: String, country: String) {
        self.coordinates = coordinate
        self.city = city
        self.country = country
        self.hemisphere = Hemisphere(latitude: coordinate.latitude)

        self.sunTime = SunTime(date: Date(), coordinate: coordinate)
    }
}
