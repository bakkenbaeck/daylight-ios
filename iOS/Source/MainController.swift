import SweetUIKit
import UIKit

class MainController: UIViewController {
    private let dayLightModelController: DaylightModelController

    lazy var informationController: InformationController = {
        let informationController = InformationController()
        informationController.modalTransitionStyle = .crossDissolve
        informationController.delegate = self

        return informationController
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

    init(withDaylightModelController dayLightModelController: DaylightModelController) {
        self.dayLightModelController = dayLightModelController
        super.init(nibName: nil, bundle: nil)

        self.dayLightModelController.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //This should be done in the model
//        Notifier.cancelAllNotifications()
//        if Settings.areNotificationsEnabled {
//            if let location = Location.current {
//                Notifier.scheduleNotifications(for: location)
//            }
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.rootView.alpha = 0.1
        UIView.animate(withDuration: TransitionDuration, animations: {
            self.rootView.alpha = 1.0
        })
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

extension MainController: InformationControllerDelegate {

    func informationController(_ informationController: InformationController, didToggleNotifications isNotificationsEnabled: Bool) {
        //maybe make something else responsible for this
//        if isNotificationsEnabled {
//            if let location = dayLightModelController.location {
//                Notifier.scheduleNotifications(for: location)
//            }
//        } else {
//            Notifier.cancelAllNotifications()
//        }
    }
}

extension MainController: DaylightModelControllerDelegate {
    func daylightModelControllerDidUpdate(_ controller: DaylightModelController) {
        self.rootView.updateInterface(controller: controller)
    }
}
