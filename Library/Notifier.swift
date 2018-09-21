import Foundation
import SweetUIKit
import UIKit
import UserNotifications

struct Notifier {
    private static func scheduleNotification(for sunTime: SunTime, at date: Date, withMessage message: String) {
        let notificationID = String(DateHasher.hashValue(for: date))
        let sunriseDate = sunTime.sunriseStartTime(for: date)

        let components = sunriseDate.components([.calendar, .year, .month, .day, .hour, .minute, .second, .timeZone])

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let content = UNMutableNotificationContent()
        content.body = message
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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

    func registerForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) { _, error in
            print(error ?? "Registered for notifications.")
        }
    }

    var isAllowedToSendNotifications: Bool {
        return self.notificationAuthorizationStatus() == .authorized
    }

    func notificationAuthorizationStatus() -> UNAuthorizationStatus {
        var status = UNAuthorizationStatus.notDetermined

        // Make call synchronous.
        let semaphore = DispatchSemaphore(value: 0)

        UNUserNotificationCenter.current().getNotificationSettings { settings in
            status = settings.authorizationStatus
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        return status
    }

    func didToggleNotifications( on informationController: InformationViewController) {
        if areNotificationsEnabled {
            scheduleNotifications(for: location)
        } else {
            cancelAllNotifications()
        }
    }
}
