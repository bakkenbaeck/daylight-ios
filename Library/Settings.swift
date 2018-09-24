import UIKit
import UserNotifications

struct Settings {
    static let isNotificationsEnabledKey = "isNotificationsEnabled"

    static var areNotificationsEnabled: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Settings.isNotificationsEnabledKey)
        }

        get {
            let userRequestedNotification = UserDefaults.standard.bool(forKey: Settings.isNotificationsEnabledKey)
            if userRequestedNotification == false {
                return false
            } else {
                return Settings.isAllowedToSendNotifications
            }
        }
    }

    static func notificationAuthorizationStatus(completionHandler: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completionHandler(settings.authorizationStatus)
            }
        }
    }

    static var isAllowedToSendNotifications: Bool {
        var authorized = false

        // Make call synchronous.
        let semaphore = DispatchSemaphore(value: 0)

        UNUserNotificationCenter.current().getNotificationSettings { settings in
            authorized = settings.authorizationStatus == .authorized
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        return authorized
    }

    static func registerForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) { _, error in
            print(error ?? "Registered for notifications.")
        }
    }
}
