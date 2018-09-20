import UIKit
import CoreLocation
import UserNotifications

class OnboardingViewController: UIViewController {

    enum OnboardingState {
        case location
        case notification
        case denied
    }

    lazy var locationTracker: LocationTracker = {
        let tracker = LocationTracker()
        tracker.delegate = self

        return tracker
    }()

    var onboardingState: OnboardingState = .denied {
        didSet {
            switch onboardingState {
            case .location:
                self.setLocationUndetermined()
            case .notification:
                self.setNotificationUndetermined()
            case .denied:
                self.setLocationDisabled()
            }
        }
    }

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

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Theme.light(size: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true

        return label
    }()

    lazy var button: UIButton = {
        let button = UIButton()

        button.titleLabel?.font = Theme.light(size: 16)
        button.setTitleColor(Theme.daylightText.withAlphaComponent(0.6), for: .normal)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)

        return button
    }()

    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(self.didTapScreen))

        return recognizer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Theme.nightBackground
        self.addObservers()

        self.addSubViewsAndConstraints()
        self.updateOnboarding()
    }

    private func addSubViewsAndConstraints() {
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.button)

        self.titleLabel.bottom(to: self.view, offset: (2 * -Theme.insets.bottom))
        self.titleLabel.left(to: self.view, offset: Theme.insets.left)
        self.titleLabel.right(to: self.view, offset: -Theme.insets.right)

        self.titleLabel.addGestureRecognizer(self.tapGestureRecognizer)

        let rightInset = CGFloat(-10)
        self.button.heightAnchor.constraint(equalToConstant: 20).isActive = true

        self.button.bottom(to: self.view, offset: -Theme.insets.top)
        self.button.left(to: self.view, offset: Theme.insets.left)
        self.button.right(to: self.view, offset: rightInset)
    }

    func presentMainController(withLocation location: Location) {
        guard self.presentedViewController as? MainController == nil else { return } // main controller is already presented
        
        let daylightModelController = DaylightModelController(location: location)
        let mainController = MainController(withDaylightModelController: daylightModelController)
        mainController.modalTransitionStyle = .crossDissolve
        self.present(mainController, animated: true)
    }

    func addObservers() {
        self.removeObservers()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateOnboarding), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    @objc func updateOnboarding() {
        switch locationTracker.authorizationStatus {
        case .notDetermined:
            self.onboardingState = .location
        case .denied:
            self.onboardingState = .denied
            self.dismiss(animated: true)
        case .authorizedWhenInUse, .authorizedAlways:
            Settings.notificationAuthorizationStatus { status in
                if status == .notDetermined {
                    self.onboardingState = .notification
                } else {
                    guard let location = self.location else { return }
                    self.presentMainController(withLocation: location)
                }
            }
        default: break
        }
    }

    func setLocationUndetermined() {
        let text = NSLocalizedString("Hi! Daylight uses your location to give you accurate daylight information.", comment: "")

        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = Theme.daylightBackground
            self.titleLabel.attributedText = text.attributedMessageString(textColor: Theme.daylightText.withAlphaComponent(0.6), highlightColor: Theme.daylightText, highlightedSubstring: "your location")
            self.button.setTitle("Tap to enable access", for: .normal)
        }
    }

    func setLocationDisabled() {
        let text = NSLocalizedString("Unfortunately, Daylight doesn't work without your location data. If you change your mind, you can enable it by going to settings.", comment: "")

        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = Theme.nightBackground
            self.titleLabel.attributedText = text.attributedMessageString(textColor: Theme.nightText.withAlphaComponent(0.6), highlightColor: Theme.nightText, highlightedSubstring: "going to settings")
            self.button.setTitle("", for: .normal)
        }
    }

    func setNotificationUndetermined() {
        let text = NSLocalizedString("Enable notifications to receive daylight changes on your phone in the morning.", comment: "")

        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = Theme.daylightBackground
            self.titleLabel.attributedText = text.attributedMessageString(textColor: Theme.daylightText.withAlphaComponent(0.6), highlightColor: Theme.daylightText, highlightedSubstring: "Enable notifications")
            self.button.setTitle("Skip for now", for: .normal)
        }
    }

    @objc func didTapScreen() {
        switch self.onboardingState {
        case .location:
            self.locationTracker.locateIfPossible()
        case .denied:
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        case .notification:
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { granted, _ in
                if granted == true {
                    Settings.areNotificationsEnabled = true
                    Settings.registerForNotifications()
                    if let location = self.location {
                        DispatchQueue.main.async {
                            Notifier.scheduleNotifications(for: location)
                            self.presentMainController(withLocation: location)
                        }
                    }
                }
            }
        }
    }

    @objc func didSelectButton() {
        switch self.onboardingState {
        case .location:
            self.locationTracker.locateIfPossible()
        case .denied:
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        case .notification:
            guard let location = self.location else { return }
            self.presentMainController(withLocation: location)
        }
    }
}

extension OnboardingViewController: LocationTrackerDelegate {

    func didFailWithError(_ error: Error, on locationTracker: LocationTracker) {
        guard self.location == nil else { return }

        if let locationError = error as? LocationTracker.Error {
          switch locationError {
              case .authorizationError:
                  return
          }
        }

        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    func didFindLocation(_ placemark: CLPlacemark, on locationTracker: LocationTracker) {
        self.location = Location(placemark: placemark)
    }

    func didUpdateAuthorizationStatus(_ authorizationStatus: CLAuthorizationStatus, on locationTracker: LocationTracker) {
        self.updateOnboarding()
    }
}
