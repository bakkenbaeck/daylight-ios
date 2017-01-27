import UIKit
import UserNotifications

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
                return Settings.isAllowedToSendNotifications
            }
        }
    }

    static var isAllowedToSendNotifications: Bool {
        return (UIApplication.shared.currentUserNotificationSettings?.types.contains([.alert]) ?? false) || (UIApplication.shared.currentUserNotificationSettings?.types.contains([.badge]) ?? false)
    }

    static func registerForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) { granted, error in
            // TODO: Implement error handling
        }
    }

    static var shouldPresentOnboarding: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "shouldPresentOnboarding")
        }

        get {
            return UserDefaults.standard.value(forKey: "shouldPresentOnboarding") as? Bool ?? true
        }
    }
}
