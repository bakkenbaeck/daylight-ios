import UIKit
import CoreLocation

protocol OnboardingControllerDelegate: class {
    func onboardingControllerDidFinish(_ onboardingController: OnboardingController)
}

class OnboardingController: UIViewController {
    weak var delegate: OnboardingControllerDelegate?

    private let insets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Theme.light(size: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.daylightText

        return label
    }()

    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.light(size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.daylightText.withAlphaComponent(0.6)

        return label
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = NSLocalizedString("Hi! Please enable location access so we can give provide you daylight information.", comment: "")
        self.subtitleLabel.text = NSLocalizedString("Waiting for access...", comment: "")

        self.addSubviewsAndConstraints()

        LocationTracker.shared.locateIfPossible()
        LocationTracker.shared.delegate = self

        self.view.backgroundColor = Theme.daylightBackground
    }

    private func addSubviewsAndConstraints() {
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.subtitleLabel)

        self.titleLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: (2 * -self.insets.bottom)).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.insets.left).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.insets.right).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: self.titleLabel.height())

        let rightInset = CGFloat(-10)
        self.subtitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        self.subtitleLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -self.insets.top).isActive = true
        self.subtitleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.insets.left).isActive = true
        self.subtitleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: rightInset).isActive = true
    }

    func checkForNotifications() {
        if UIApplication.shared.isRegisteredForRemoteNotifications {
            print("User is already receiving notifications")
        } else {
            self.titleLabel.text = NSLocalizedString("Enable notifications to receive daylight changes on your phone at sunrise.", comment: "")
            self.subtitleLabel.text = NSLocalizedString("Skip for now", comment: "")
        }
    }
}

extension OnboardingController: LocationTrackerDelegate {
    func locationTracker(_ locationTracker: LocationTracker, didFailWith error: Error) {
        guard Location.current == nil else { return }

        let isUnexpectedError = (error as NSError).code != 0
        if isUnexpectedError {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func locationTracker(_ locationTracker: LocationTracker, didFindLocation placemark: CLPlacemark) {
        guard Location.current == nil else { return }

        if let location = Location(placemark: placemark) {
            Location.current = location
            self.checkForNotifications()
        }
    }
}
