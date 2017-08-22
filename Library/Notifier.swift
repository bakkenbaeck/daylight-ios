import Foundation
import UIKit
import SweetUIKit

struct Notifier {

    static func scheduleNotifications(for location: Location) {
        let datesOfComingYear = Date().futureDates()
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

        let interval = location.dayLengthDifferenceOnDate(date)

        let messageGenerator = MessageGenerator()

        let minutesRounded = abs(Int(Darwin.round(interval / 60.0)))
        let generatedMessage = messageGenerator.messageForNotification(forDate: Date(), yesterdayDaylightLength: location.yesterdayDaylightLength, todayDaylightLength: location.todayDaylightLength, tomorrowDaylightLength: location.tomorrowDaylightLength)

        let format = NSLocalizedString("number_of_minutes", comment: "")
        let minuteString = String.localizedStringWithFormat(format, minutesRounded)
        let formattedMessage = String(format: generatedMessage, minuteString)

        // TODO: Fix deprecated UILocalNotification
        UILocalNotification.schedule(notificationID, at: sunriseDate, message: formattedMessage)
    }

    static func cancelAllNotifications() {
        // TODO: Fix deprecated UILocalNotification
        UILocalNotification.cancelAll()
    }
}
