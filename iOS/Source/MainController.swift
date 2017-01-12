import UIKit
import CoreLocation
import SweetUIKit

class MainController: UIViewController {
    lazy var informationController: InformationController = {
        let informationController = InformationController()
        informationController.modalTransitionStyle = .crossDissolve
        informationController.delegate = self

        return informationController
    }()

    lazy var locationTracker: LocationTracker = {
        let tracker = LocationTracker()
        tracker.delegate = self

        return tracker
    }()

    fileprivate var rootView: MainView {
        return self.view as! MainView
    }

    override func loadView() {
        let view = MainView(frame: UIScreen.main.bounds)
        view.delegate = self
        self.view = view
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationTracker.locateIfPossible()
        self.updateInterface()

        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateInterface), userInfo: nil, repeats: true)

        Notifier.cancelAllNotifications()
        if Settings.isNotificationsEnabled {
            if let location = Location.current {
                Notifier.scheduleNotifications(for: location)
            }
        }
    }

    func updateInterface() {
        self.rootView.updateInterface(location: Location.current)
    }
}

extension MainController: MainViewDelegate {

    func mainView(_ mainView: MainView, didSelectAboutButton button: UIButton) {
        self.present(self.informationController, animated: true)
    }

    func mainView(_ mainView: MainView, didSelectShareButton button: UIButton) {
        let screenshot = self.rootView.screenshot()

        let activityController = UIActivityViewController(activityItems: [screenshot, "Made with #daylightapp."], applicationActivities: nil)
        activityController.excludedActivityTypes = [UIActivityType.airDrop]
        self.present(activityController, animated: true, completion: nil)
    }
}

extension MainController: LocationTrackerDelegate {

    func locationTracker(_ locationTracker: LocationTracker, didFailWith error: Error) {
        guard Location.current == nil else { return }

        self.rootView.updateMessage(messageLabel: "We need to know where you are, please enable location access.")

        let isUnexpectedError = (error as NSError).code != 0
        if isUnexpectedError {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func locationTracker(_ locationTracker: LocationTracker, didFindLocation placemark: CLPlacemark) {
        Location.current = Location(placemark: placemark)

        self.rootView.updateInterface(location: Location.current)
    }
}

extension MainController: InformationControllerDelegate {

    func informationController(_ informationController: InformationController, didToggleNotifications isNotificationsEnabled: Bool) {
        if isNotificationsEnabled {
            if let location = Location.current {
                Notifier.scheduleNotifications(for: location)
            }
        } else {
            Notifier.cancelAllNotifications()
        }
    }
}
