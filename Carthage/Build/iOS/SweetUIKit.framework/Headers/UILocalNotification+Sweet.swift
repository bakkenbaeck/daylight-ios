#if os(iOS)
    import UIKit

    public extension UILocalNotification {
        static let idKey = "idKey"
        static let fireDateKey = "fireDateKey"

        /// Schedules a local notification.
        ///
        /// - Parameters:
        ///   - id: The id used to represent a local notification in your app.
        ///   - date: The date when the notification will trigger
        ///   - soundName: The name of the sound to be used when the notification is received.
        ///   - message: The message that the app will use for your local notification.
        ///   - actionTitle: The title of the action to be displayed by your notification, it's optional, though, since Apple provides a good default for this.
        public static func schedule(_ id: String, at date: Date, soundName: String? = nil, message: String, actionTitle: String? = nil) {
            let notification = UILocalNotification()
            notification.soundName = soundName

            notification.fireDate = date
            notification.timeZone = TimeZone.current
            notification.alertBody = message
            notification.alertAction = actionTitle
            notification.hasAction = actionTitle != nil

            var userInfo = [AnyHashable: Any]()
            userInfo[idKey] = id
            userInfo[fireDateKey] = date
            notification.userInfo = userInfo

            UIApplication.shared.scheduleLocalNotification(notification)
        }

        /// Finds a local notification for certain id.
        ///
        /// - Parameter id: The id used to store the notification.
        /// - Returns: A local notification that matches the provided id.
        public static func find(_ id: String) -> UILocalNotification? {
            let notifications = UIApplication.shared.scheduledLocalNotifications ?? [UILocalNotification]()
            let filteredNotifications = notifications.filter { notification in
                let filteredNotificationID = notification.userInfo?[idKey] as? String
                return filteredNotificationID == id
            }

            return filteredNotifications.first
        }

        /// Cancels a local notification.
        ///
        /// - Parameter id: The id used to store the notification.
        public static func cancel(_ id: String) {
            if let notification = self.find(id) {
                UIApplication.shared.cancelLocalNotification(notification)
            }
        }

        /// Cancels all the local notifications for the current app.
        public static func cancelAll() {
            let notifications = UIApplication.shared.scheduledLocalNotifications ?? [UILocalNotification]()
            notifications.forEach { notification in
                UIApplication.shared.cancelLocalNotification(notification)
            }
        }
    }
#endif
