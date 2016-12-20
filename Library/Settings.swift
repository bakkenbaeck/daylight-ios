import UIKit

struct Settings {
    static var isNotificationsEnabled: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "isNotificationsEnabled")
        }

        get {
            let userRequestedNotification = UserDefaults.standard.bool(forKey: "isNotificationsEnabled")
            if userRequestedNotification == false {
                return false
            } else {
                let isAllowedToSendNotifications = UIApplication.shared.currentUserNotificationSettings?.types.contains([.alert]) ?? false

                return isAllowedToSendNotifications
            }
        }
    }

    static func registerForNotifications() {
        let settings = UIUserNotificationSettings(types: [.alert], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
    }
}
