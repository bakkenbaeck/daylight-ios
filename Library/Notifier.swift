import Foundation
//import SweetUIKit
import UIKit
import UserNotifications

struct Notifier {
    static func scheduleNotifications(for sunTime: SunTime) {
        let dateWithNext30 = Date().andNext30Days()
        for date in dateWithNext30 {
            self.scheduleNotification(for: sunTime, at: date)
        }
    }

    private static func scheduleNotification(for sunTime: SunTime, at date: Date) {
        let notificationID = String(DateHasher.hashValue(for: date))
        let sunriseDate = sunTime.sunriseStartTime(for: date)

        let formattedMessage = self.formattedMessage(for: sunTime, date: date)
        let components = sunriseDate.components([.calendar, .year, .month, .day, .hour, .minute, .second, .timeZone])

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let content = UNMutableNotificationContent()
        content.body = formattedMessage
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    static func formattedMessage(for sunTime: SunTime, date: Date) -> String {
        return Message.notificationMessage(for: date, coordinates: sunTime.coordinates)
    }

    static func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
