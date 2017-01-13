import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {
    var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { fatalError("Window not found") }

        if Location.current == nil {
            let controller = OnboardingController(nibName: nil, bundle: nil)
            window.rootViewController = controller
        } else {
            let mainController = MainController(nibName: nil, bundle: nil)
            window.rootViewController = mainController
        }

        window.makeKeyAndVisible()

        return true
    }
}
