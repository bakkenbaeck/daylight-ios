import Foundation
import UIKit
import CoreLocation
import Suntimes

class APIClient {
    static var timeFormatter: DateFormatter = {
        let shortTimeFormatter = DateFormatter()
        shortTimeFormatter.dateFormat = "hh:mm"

        return shortTimeFormatter
    }()

    static func dayLengthDifference(for coordinate: CLLocationCoordinate2D) -> TimeInterval {
        let today = Calendar.autoupdatingCurrent.startOfDay(for: Date())
        let yesterday = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: today)!

        let todaySuntimes = Suntimes(date: today, timeZone: TimeZone.autoupdatingCurrent, latitude: coordinate.latitude, longitude: coordinate.longitude)
        let yesterdaySuntimes = Suntimes(date: yesterday, timeZone: TimeZone.autoupdatingCurrent, latitude: coordinate.latitude, longitude: coordinate.longitude)

        let todayDayLength = todaySuntimes.sunset.timeIntervalSince(todaySuntimes.sunrise)
        let yesterdayDayLength = yesterdaySuntimes.sunset.timeIntervalSince(yesterdaySuntimes.sunrise)

        let interval = todayDayLength - yesterdayDayLength

        return interval
    }

    static func sunriseTimeString(for coordinate: CLLocationCoordinate2D) -> String {
        let today = Calendar.autoupdatingCurrent.startOfDay(for: Date())

        let todaySuntimes = Suntimes(date: today, timeZone: TimeZone.autoupdatingCurrent, latitude: coordinate.latitude, longitude: coordinate.longitude)
        let sunrise = todaySuntimes.sunrise

        return self.timeFormatter.string(from: sunrise)
    }

    static func sunsetTimeString(for coordinate: CLLocationCoordinate2D) -> String {
        let today = Calendar.autoupdatingCurrent.startOfDay(for: Date())

        let todaySuntimes = Suntimes(date: today, timeZone: TimeZone.autoupdatingCurrent, latitude: coordinate.latitude, longitude: coordinate.longitude)
        let sunset = todaySuntimes.sunset

        return self.timeFormatter.string(from: sunset)
    }
}
