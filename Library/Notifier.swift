import Foundation
import SweetUIKit
import UIKit
import UserNotifications

struct Notifier {
    static func scheduleNotifications(for location: Location) {
        let dateWithNext30 = Date().andNext30Days()
        for date in dateWithNext30 {
            self.scheduleNotification(for: location, at: date)
        }
    }

    private static func scheduleNotification(for location: Location, at date: Date) {
//        guard let location = Location.current else { return }
//
//        let notificationID = String(DateHasher.hashValue(for: date))
//        let sunriseDate = location.sunTime.sunriseStartTime(for: date)
//
//        let formattedMessage = self.formattedMessage(location: location, date: date)
//        let components = sunriseDate.components([.calendar, .year, .month, .day, .hour, .minute, .second, .timeZone])
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
//        let content = UNMutableNotificationContent()
//        content.body = formattedMessage
//        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request)
    }

    static func formattedMessage(location: Location, date: Date) -> String {
        return Message.notificationMessage(for: date, coordinates: location.coordinates)
    }

    static func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
