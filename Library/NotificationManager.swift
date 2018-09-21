import Foundation
import UserNotifications

class NotificationManager {
    private let manager: NotificationManaging

    init(manager: NotificationManaging = UNUserNotificationCenter.current()) {
        self.manager = manager
    }

    var areNotificationsEnabled: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "isNotificationsEnabled")
        }

        get {
            let userRequestedNotification = UserDefaults.standard.bool(forKey: "isNotificationsEnabled")
            if userRequestedNotification == false {
                return false
            } else {
                return self.isAllowedToSendNotifications
            }
        }
    }

    var isAllowedToSendNotifications: Bool {
        return self.manager.notificationAuthorizationStatus() == .authorized
    }
}

protocol NotificationManaging {
    func notificationAuthorizationStatus() -> UNAuthorizationStatus
    func registerForNotifications()
}

extension UNUserNotificationCenter: NotificationManaging {
    func notificationAuthorizationStatus() -> UNAuthorizationStatus {
        var status = UNAuthorizationStatus.notDetermined

        // Make call synchronous.
        let semaphore = DispatchSemaphore(value: 0)

        getNotificationSettings { settings in
            status = settings.authorizationStatus
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        return status
    }

    func registerForNotifications() {
        requestAuthorization(options: [.alert, .badge]) { _, error in
            print(error ?? "Registered for notifications.")
        }
    }
}
