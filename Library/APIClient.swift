import Foundation
import CoreLocation
import Sunrise

class APIClient {
    static func dayLengthDifference(for placemark: CLPlacemark) -> TimeInterval {
        let location = placemark.location!

        let today = Calendar.autoupdatingCurrent.startOfDay(for: Date())
        let yesterday = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: today)!

        let todaySunriseSet = SunriseSet(date: today, timeZone: TimeZone.autoupdatingCurrent, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let yesterdaySunriseSet = SunriseSet(date: yesterday, timeZone: TimeZone.autoupdatingCurrent, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        let todayDayLength = todaySunriseSet.sunset.timeIntervalSince(todaySunriseSet.sunrise)
        let yesterdayDayLength = yesterdaySunriseSet.sunset.timeIntervalSince(yesterdaySunriseSet.sunrise)

        let interval = todayDayLength - yesterdayDayLength

        return interval
    }
}
