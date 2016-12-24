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

    static private func scheduleNotification(for location: Location, at date: Date) {
        guard let location = Location.current else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long

        let notificationID = dateFormatter.string(from: date)
        let sunriseDate = location.sunriseForDate(date)

        let interval = location.dayLengthDifferenceOnDate(date)

        let messageGenerator = MessageGenerator()
        let minutesString = messageGenerator.minuteString(for: interval)

        let message = messageGenerator.messageForNotification(sunPhase: location.sunPhase, yesterdayDaylightLength: location.yesterdayDaylightLength, todayDaylightLength: location.todayDaylightLength, tomorrowDaylightLength: location.tomorrowDaylightLength)
        let formattedMessage = String(format: message, minutesString)

        UILocalNotification.schedule(notificationID, at: sunriseDate, message: formattedMessage)
    }

    static func cancelAllNotifications() {
        UILocalNotification.cancelAll()
    }
}
