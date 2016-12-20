import Foundation
import UIKit
import SweetUIKit

class Notifier: NSObject {

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long

        return formatter
    }()

    func scheduleNotifications() {
        let datesOfComingYear = Date().datesOfComingYear()
        for date in datesOfComingYear {
            self.scheduleNotification(forDate: date)
        }
    }

    private func scheduleNotification(forDate date: Date) {
        guard let location = Location.current else { return }

        let notificationID = self.dateFormatter.string(from: date)
        let sunriseDate = location.sunriseForDate(date)

        let interval = location.dayLengthDifferenceOnDate(date)

        let messageGenerator = MessageGenerator()
        let minutesString = messageGenerator.minuteString(for: interval)

        let message = messageGenerator.messageForNotification(withInterval: interval)
        let formattedMessage = String(format: message, minutesString)

        UILocalNotification.schedule(notificationID, at: sunriseDate, message: formattedMessage)
    }

    func cancelAllNotifications() {
        UILocalNotification.cancelAll()
    }
}
