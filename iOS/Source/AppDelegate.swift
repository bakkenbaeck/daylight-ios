import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {
    var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { fatalError("Window not found") }

        if Settings.shouldPresentOnboarding {
            let controller = OnboardingController(nibName: nil, bundle: nil)
            controller.titleLabel.text = "Hi! Please enable location access so we can give provide you daylight information."
            controller.subtitleLabel.text = "Waiting for access..."
            window.rootViewController = controller
        } else {
            window.rootViewController = MainController(nibName: nil, bundle: nil)
        }
        window.makeKeyAndVisible()

        return true
    }
}
