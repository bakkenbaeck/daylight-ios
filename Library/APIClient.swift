import Foundation
import CoreLocation
import Sunrise

class APIClient {
    static func dayLenghtDifference(for placemark: CLPlacemark) -> TimeInterval {
        let location = placemark.location!

        let today = Calendar.autoupdatingCurrent.startOfDay(for: Date())
        let yesterday = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: today)!

        let todaySunriseSet = SunriseSet(date: today, timeZone: TimeZone.autoupdatingCurrent, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let yesterdaySunriseSet = SunriseSet(date: yesterday, timeZone: TimeZone.autoupdatingCurrent, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        let todayDayLenght = todaySunriseSet.sunset.timeIntervalSince(todaySunriseSet.sunrise)
        let yesterdayDayLenght = yesterdaySunriseSet.sunset.timeIntervalSince(yesterdaySunriseSet.sunrise)

        let interval = todayDayLenght - yesterdayDayLenght

        return interval
    }
}
