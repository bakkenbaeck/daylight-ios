import CoreLocation
import SweetUIKit
import UIKit

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

        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.updateInterface), userInfo: nil, repeats: true)

        Notifier.cancelAllNotifications()
        if Settings.areNotificationsEnabled {
            if let location = Location.current {
                Notifier.scheduleNotifications(for: location)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.rootView.alpha = 0.1
        UIView.animate(withDuration: TransitionDuration, animations: {
            self.rootView.alpha = 1.0
        })
    }

    @objc func updateInterface() {
        if let location = Location.current {
            self.rootView.updateInterface(controller: DaylightModelController(location: location))
        }
    }
}

extension MainController: MainViewDelegate {

    func mainView(_ mainView: MainView, didSelectAboutButton button: UIButton) {
        UIView.animate(withDuration: TransitionDuration, animations: {
            self.rootView.alpha = 0.1
        }) { _ in
            self.present(self.informationController, animated: false) {
                self.rootView.alpha = 1.0
            }
        }
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

        let isUnexpectedError = (error as NSError).code != 0
        if isUnexpectedError {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func locationTracker(_ locationTracker: LocationTracker, didFindLocation placemark: CLPlacemark) {
        Location.current = Location(placemark: placemark)

        self.updateInterface()
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
