import Foundation
import SweetUIKit
import UIKit

struct Notifier {

    static func scheduleNotifications(for location: Location) {
        let datesOfComingYear = Date().andNext30Days()
        for date in datesOfComingYear {
            self.scheduleNotification(for: location, at: date)
        }
    }

    private static func scheduleNotification(for location: Location, at date: Date) {
        guard let location = Location.current else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long

        let notificationID = dateFormatter.string(from: date)
        let sunriseDate = location.sunTime.sunriseStartTime(for: date)

        let formattedMessage = self.formattedMessage(location: location, date: date)

        // TODO: Fix deprecated UILocalNotification
        UILocalNotification.schedule(notificationID, at: sunriseDate, message: formattedMessage)
    }

    static func formattedMessage(location: Location, date: Date) -> String {
        return Message.notificationMessage(for: date, coordinates: location.coordinates)
    }

    static func cancelAllNotifications() {
        // TODO: Fix deprecated UILocalNotification
        UILocalNotification.cancelAll()
    }
}
