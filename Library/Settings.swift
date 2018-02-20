import UIKit
import UserNotifications

struct Settings {
    static var areNotificationsEnabled: Bool {
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

    static var shouldPresentOnboarding: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "shouldPresentOnboarding")
        }
        get {
            return UserDefaults.standard.value(forKey: "shouldPresentOnboarding") as? Bool ?? true
        }
    }
}
