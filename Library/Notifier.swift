import Foundation
import UIKit
import SweetUIKit

struct Notifier {

    static func scheduleNotifications(for location: Location) {
        let datesOfComingYear = Date().next30days()
        for date in datesOfComingYear {
            self.scheduleNotification(for: location, at: date)
        }
    }

    private static func scheduleNotification(for location: Location, at date: Date) {
        guard let location = Location.current else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long

        let notificationID = dateFormatter.string(from: date)
        let sunriseDate = location.sunriseForDate(date)

        let formattedMessage = self.formattedMessage(location: location, date: date)

        // TODO: Fix deprecated UILocalNotification
        UILocalNotification.schedule(notificationID, at: sunriseDate, message: formattedMessage)
    }

    static func formattedMessage(location: Location, date: Date) -> String {
        let interval = location.dayLengthDifferenceOnDate(date)

        let messageGenerator = MessageGenerator()

        // If the time differential is smaller than a minute, say 1 minute instead.
        let minutesRounded = max(abs(Int(Darwin.round(interval / 60.0))), 1)

        let generatedMessage = messageGenerator.messageForNotification(date: date, hemisphere: location.hemisphere, daylightLengthDifference: interval)

        let format = NSLocalizedString("number_of_minutes", comment: "")
        let minuteString = String.localizedStringWithFormat(format, minutesRounded)
        let formattedMessage = String(format: generatedMessage, minuteString)

        return formattedMessage
    }

    static func cancelAllNotifications() {
        // TODO: Fix deprecated UILocalNotification
        UILocalNotification.cancelAll()
    }
}
