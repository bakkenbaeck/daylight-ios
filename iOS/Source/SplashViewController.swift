import UIKit
import CoreLocation

class SplashViewController: UIViewController {

    lazy var locationTracker: LocationTracker = {
        let tracker = LocationTracker()
        tracker.delegate = self

        // should this happen here? I don't think soooo
//        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.updateDelegate), userInfo: nil, repeats: true)

        return tracker
    }()

    private(set) var location: Location? {
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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Theme.nightBackground
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let location = location else {
            let controller = OnboardingController(nibName: nil, bundle: nil)
            self.present(controller, animated: true)
            controller.delegate = self
            return
        }

        let daylightModelController = DaylightModelController(location: location)
        let mainController = MainController(withDaylightModelController: daylightModelController)

        self.present(mainController, animated: true)
    }
}

extension SplashViewController: LocationTrackerDelegate {

    func locationTracker(_ locationTracker: LocationTracker, didFailWith error: Error) {
        guard self.location == nil else { return }

        let isUnexpectedError = (error as NSError).code != 0
        if isUnexpectedError {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func locationTracker(_ locationTracker: LocationTracker, didFindLocation placemark: CLPlacemark) {
        self.location = Location(placemark: placemark)
    }
}
