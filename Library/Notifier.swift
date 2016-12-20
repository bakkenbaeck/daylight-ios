import Foundation
import UIKit
import SweetUIKit

struct Notifier {
    static func scheduleNotifications() {
        let datesOfComingYear = Date().datesOfComingYear()
        for date in datesOfComingYear {
            self.scheduleNotification(forDate: date)
        }
    }

    static private func scheduleNotification(forDate date: Date) {
        guard let location = Location.current else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long

        let notificationID = dateFormatter.string(from: date)
        let sunriseDate = location.sunriseForDate(date)

        let interval = location.dayLengthDifferenceOnDate(date)

        let messageGenerator = MessageGenerator()
        let minutesString = messageGenerator.minuteString(for: interval)

        let message = messageGenerator.messageForNotification(withInterval: interval)
        let formattedMessage = String(format: message, minutesString)

        UILocalNotification.schedule(notificationID, at: sunriseDate, message: formattedMessage)
    }

    static func cancelAllNotifications() {
        UILocalNotification.cancelAll()
    }
}
