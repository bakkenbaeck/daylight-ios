import CoreLocation
import Foundation

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
    }
}
