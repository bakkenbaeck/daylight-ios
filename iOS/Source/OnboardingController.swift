import CoreLocation
import UIKit
import UserNotifications

protocol OnboardingControllerDelegate: class {
    func didFinishOnboarding(withLocation location: Location, notificationGranted: Bool)
}

class OnboardingController: UIViewController {

    weak var delegate: OnboardingControllerDelegate?

    var location: Location?

    enum OnboardingState: Int {
        case locationUndetermined
        case locationDisabled
        case notificationUndetermined
    }

    var onboardingState = OnboardingState.locationUndetermined {
        didSet {
            switch self.onboardingState {
            case .locationUndetermined:
                self.setLocationUndetermined()
            case .locationDisabled:
                self.setLocationDisabled()
            case .notificationUndetermined:
                self.setNotificationUndetermined()
            }
        }
    }

    private let insets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)

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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSubviewsAndConstraints()

        self.updateOnboardingStatus()
        self.addObservers()
    }

    func addObservers() {
        self.removeObservers()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateOnboardingStatus), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    @objc func updateOnboardingStatus() {
        switch LocationTracker.shared.authorizationStatus {
        case .notDetermined:
            self.onboardingState = .locationUndetermined
        case .denied:
            self.onboardingState = .locationDisabled
        case .authorizedWhenInUse, .authorizedAlways:
            self.onboardingState = .notificationUndetermined
        default: break
        }
    }

    private func addSubviewsAndConstraints() {
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.button)

        self.titleLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: (2 * -self.insets.bottom)).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.insets.left).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.insets.right).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: self.titleLabel.height())

        self.titleLabel.addGestureRecognizer(self.tapGestureRecognizer)

        let rightInset = CGFloat(-10)
        self.button.heightAnchor.constraint(equalToConstant: 20).isActive = true

        self.button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -self.insets.top).isActive = true
        self.button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.insets.left).isActive = true
        self.button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: rightInset).isActive = true
    }

    func setLocationUndetermined() {
        self.view.backgroundColor = Theme.daylightBackground

        let text = NSLocalizedString("Hi! Daylight uses your location to give you accurate daylight information.", comment: "")

        UIView.animate(withDuration: 0.2) {
            self.titleLabel.attributedText = text.attributedMessageString(textColor: Theme.daylightText.withAlphaComponent(0.6), highlightColor: Theme.daylightText, highlightedSubstring: "your location")
            self.button.setTitle("Tap to enable access", for: .normal)
        }

        self.button.isHidden = false
    }

    func setLocationDisabled() {
        self.view.backgroundColor = Theme.nightBackground

        let text = NSLocalizedString("Unfortunately, Daylight doesn't work without your location data. If you change your mind, you can enable it by going to settings.", comment: "")

        UIView.animate(withDuration: 0.2) {
            self.titleLabel.attributedText = text.attributedMessageString(textColor: Theme.nightText.withAlphaComponent(0.6), highlightColor: Theme.nightText, highlightedSubstring: "going to settings")
            self.button.isHidden = true
        }
    }

    func setNotificationUndetermined() {
        self.view.backgroundColor = Theme.daylightBackground

        let text = NSLocalizedString("Enable notifications to receive daylight changes on your phone in the morning.", comment: "")
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.attributedText = text.attributedMessageString(textColor: Theme.daylightText.withAlphaComponent(0.6), highlightColor: Theme.daylightText, highlightedSubstring: "Enable notifications")
            self.button.setTitle("Skip for now", for: .normal)
        }

        self.button.isEnabled = true
        self.button.isHidden = false
        self.checkForNotifications()
    }

    @objc func didTapScreen() {
        switch self.onboardingState {
        case .locationUndetermined:
            LocationTracker.shared.locateIfPossible()
            LocationTracker.shared.delegate = self
        case .locationDisabled:
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        case .notificationUndetermined:
            self.requestNotifications()
        }
    }

    @objc func didSelectButton() {
        switch self.onboardingState {
        case .locationUndetermined:
            LocationTracker.shared.locateIfPossible()
            LocationTracker.shared.delegate = self
        case .locationDisabled:
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        case .notificationUndetermined:
            self.presentMainController()
        }
    }

    func checkForNotifications() {
        if UIApplication.shared.isRegisteredForRemoteNotifications {
            self.presentMainController()
        }
    }

    func requestNotifications() {

        //somewhere else
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { granted, _ in

            self.delegate?.didFinishOnboarding(withLocation: location, notificationGranted: granted)
//            if granted == true {
//                Settings.areNotificationsEnabled = true
//                Settings.registerForNotifications()
//                if let location = Location.current {
//                    DispatchQueue.main.async {
//                        Notifier.scheduleNotifications(for: location)
//                    }
//                }
//            }
        }
    }
}

extension OnboardingController: LocationTrackerDelegate {

    func locationTracker(_ locationTracker: LocationTracker, didFailWith error: Error) {
        self.onboardingState = .locationDisabled
    }

    func locationTracker(_ locationTracker: LocationTracker, didFindLocation placemark: CLPlacemark) {
        if let location = Location(placemark: placemark) {
            self.location = location
            self.onboardingState = .notificationUndetermined
        }
    }
}
