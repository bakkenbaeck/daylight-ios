import UIKit

struct Settings {
    static var isNotificationsEnabled: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "isNotificationsEnabled")
        }

        get {
            let local = UserDefaults.standard.bool(forKey: "isNotificationsEnabled")
            if local == false {
                return false
            } else {
                if let grantedSettings = UIApplication.shared.currentUserNotificationSettings, grantedSettings.types.contains([.alert]) {
                    return true
                } else {
                    return false
                }
            }
        }
    }

    static func registerForNotifications() {
        let settings = UIUserNotificationSettings(types: [.alert], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
    }
}
