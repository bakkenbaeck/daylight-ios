import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {
    var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { fatalError("Window not found") }

        let dayLightModelController = DaylightModelController()

        if dayLightModelController.location == nil {
            let controller = OnboardingController(nibName: nil, bundle: nil)
            window.rootViewController = controller
        } else {
            let mainController = MainController(withDaylightModelController: dayLightModelController)
            window.rootViewController = mainController
        }

        window.makeKeyAndVisible()

        return true
    }
}
