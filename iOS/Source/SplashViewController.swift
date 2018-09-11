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

    lazy var onboardingView: OnboardingView = {
        let view = OnboardingView()
        view.delegate = self

        return view
    }()

    var authorizationStatus: CLAuthorizationStatus = .notDetermined {
        didSet {
            switch authorizationStatus {
            case .notDetermined:
                self.onboardingView.onboardingState = .location
            case .denied:
                self.onboardingView.onboardingState = .denied
            case .authorizedWhenInUse, .authorizedAlways:
                Settings.notificationAuthorizationStatus { status in
                    if status == .notDetermined {
                        self.onboardingView.onboardingState =  .notification
                    } else {
                        self.presentMainController()
                    }
                 }
            default: break
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Theme.nightBackground
        self.addObservers()

        self.authorizationStatus = locationTracker.authorizationStatus
        self.addSubViewsAndConstraints()
    }

    private func addSubViewsAndConstraints() {
        self.view.addSubview(onboardingView)
        onboardingView.edges(to: self.view)


    }

    func presentMainController() {
        guard let location = location else { return }
        let daylightModelController = DaylightModelController(location: location)
        let mainController = MainController(withDaylightModelController: daylightModelController)
        self.present(mainController, animated: true)
    }
    func addObservers() {
        self.removeObservers()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.updateOnboardingStatus), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
}

extension SplashViewController: OnboardingViewDelegate {
    func didRequestToLocateIfPossible(on controller: OnboardingView) {
        self.locationTracker.locateIfPossible()
    }

    func didRequestToSkipNotifications(on controller: OnboardingView) {
        self.presentMainController()
    }
}

extension SplashViewController: LocationTrackerDelegate {

    func didFailWithError(_ error: Error, on locationTracker: LocationTracker) {
        guard self.location == nil else { return }

        let isUnexpectedError = (error as NSError).code != 0
        if isUnexpectedError {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func didFindLocation(_ placemark: CLPlacemark, on locationTracker: LocationTracker) {
        self.location = Location(placemark: placemark)
    }

    func didUpdateAuthorizationStatus(_ authorizationStatus: CLAuthorizationStatus, on locationTracker: LocationTracker) {
        self.authorizationStatus = authorizationStatus
    }
}
