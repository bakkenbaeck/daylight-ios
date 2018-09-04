import CoreLocation
import UIKit

protocol DaylightModelControllerObserver: AnyObject {
    func daylightModelControllerDidUpdate(_ controller: DaylightModelController)
}

class DaylightModelController {
    private var location: Location? {
        set {
            // make this a function in location make use of Codable please
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

            updateObservers()
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

    lazy var locationTracker: LocationTracker = {
        let tracker = LocationTracker()
        tracker.delegate = self

        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.updateObservers), userInfo: nil, repeats: true)

        return tracker
    }()

    init() {
        self.locationTracker.locateIfPossible()
    }

    @objc func updateObservers() {
        
    }
}

extension DaylightModelController {
    
    var primaryColor: UIColor {
        guard let location = location else {
            return .white
        }
        return Theme.primaryColor(for: location.sunTime.sunPhase)
    }

    var secondaryColor: UIColor {
        guard let location = location else {
            return .white
        }
        return Theme.secondaryColor(for: location.sunTime.sunPhase)
    }

    var locationLabel: String {
        guard let location = location else {
            return ""
        }
        return "\(location.city), \(location.country)"
    }

    var attributedMessage: NSAttributedString? {
        guard let location = location else {
            return nil
        }
        let message = Message(for: Date(), coordinates: location.coordinates)
        return message.attributedString(textColor: secondaryColor.withAlphaComponent(0.6), highlightColor: secondaryColor)
    }
}
extension DaylightModelController {
    func addObserver(_ observer: DaylightModelControllerObserver) {

    }
}

extension DaylightModelController: LocationTrackerDelegate {

    func locationTracker(_ locationTracker: LocationTracker, didFailWith error: Error) {
        guard self.location == nil else { return }

        let isUnexpectedError = (error as NSError).code != 0
        if isUnexpectedError {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            // show alert in some way!
//            self.present(alertController, animated: true, completion: nil)
        }
    }

    func locationTracker(_ locationTracker: LocationTracker, didFindLocation placemark: CLPlacemark) {
        self.location = Location(placemark: placemark)
    }
}
