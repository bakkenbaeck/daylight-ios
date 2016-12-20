import Foundation

class Notifier: NSObject {

    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long

        return formatter
    }()

    override init() {
        //it gets inited every time you start the app ✌🏻
        super.init()

        //first check the user defaults if the notifications are allowed or not!
        // if they are setup new notifcations
    }

    func scheduleNotifications() {
        //check what notifications are already sheduled at the moment
        // get a list of dates for when a new notification has to be sheduled

        //list of dates from now till next year
        let datesOfComingYear = Date().dayAfter()

        //filter list of dates that already have a notification

        //shedulenotificationfordate
    }

    func scheduleNotification(forDate date: NSDate) {
        // get sunrise time and longer day length interval for that date
        // shedule the notification with that info
    }

    func deleteAllNotifications() {
        // when you turn off notifications in the information controller, it should call this method.
    }
}