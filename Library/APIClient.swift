import Foundation
import UIKit
import CoreLocation
import Sunrise

class APIClient {
    static var timeFormatter: DateFormatter = {
        let shortTimeFormatter = DateFormatter()
        shortTimeFormatter.dateFormat = "hh:mm"

        return shortTimeFormatter
    }()

    static func dayLengthDifference(for coordinate: CLLocationCoordinate2D) -> TimeInterval {
        let today = Calendar.autoupdatingCurrent.startOfDay(for: Date())
        let yesterday = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: today)!

        let todaySunriseSet = SunriseSet(date: today, timeZone: TimeZone.autoupdatingCurrent, latitude: coordinate.latitude, longitude: coordinate.longitude)
        let yesterdaySunriseSet = SunriseSet(date: yesterday, timeZone: TimeZone.autoupdatingCurrent, latitude: coordinate.latitude, longitude: coordinate.longitude)

        let todayDayLength = todaySunriseSet.sunset.timeIntervalSince(todaySunriseSet.sunrise)
        let yesterdayDayLength = yesterdaySunriseSet.sunset.timeIntervalSince(yesterdaySunriseSet.sunrise)

        let interval = todayDayLength - yesterdayDayLength

        return interval
    }

    static func sunriseTimeString(for coordinate: CLLocationCoordinate2D) -> String {
        let today = Calendar.autoupdatingCurrent.startOfDay(for: Date())

        let todaySunriseSet = SunriseSet(date: today, timeZone: TimeZone.autoupdatingCurrent, latitude: coordinate.latitude, longitude: coordinate.longitude)
        let sunrise = todaySunriseSet.sunrise

        return self.timeFormatter.string(from: sunrise)
    }

    static func sunsetTimeString(for coordinate: CLLocationCoordinate2D) -> String {
        let today = Calendar.autoupdatingCurrent.startOfDay(for: Date())

        let todaySunriseSet = SunriseSet(date: today, timeZone: TimeZone.autoupdatingCurrent, latitude: coordinate.latitude, longitude: coordinate.longitude)
        let sunset = todaySunriseSet.sunset

        return self.timeFormatter.string(from: sunset)
    }

    static func sunLocation(for coordinate: CLLocationCoordinate2D) -> (CGFloat, CGFloat) {
        let today = Calendar.autoupdatingCurrent.startOfDay(for: Date())
        let todaySunriseSet = SunriseSet(date: today, timeZone: TimeZone.autoupdatingCurrent, latitude: coordinate.latitude, longitude: coordinate.longitude)
        let todayDayLength = todaySunriseSet.sunset.timeIntervalSince(todaySunriseSet.sunrise)

        let sunrise = todaySunriseSet.sunrise
        let sunset = todaySunriseSet.sunset

        let timeIntervalTillSunrise = sunrise.timeIntervalSince(Date())
        let timIntervalSinceSunrise = Date().timeIntervalSince(sunrise)
        let timeIntervalTillSunset = sunset.timeIntervalSince(Date())
        let timIntervalSinceSunset = Date().timeIntervalSince(sunset)

        let stillNight = timeIntervalTillSunrise > 0
        let dayTime = timIntervalSinceSunrise > 0 && timeIntervalTillSunset > 0
        let alreadyNight = timIntervalSinceSunset > 0


        //TODO: Implement real calculation
        return(0, 100)
    }

    static func getSunPhase() -> SunPhase {
        return .sunrise
//        return SunPhase(rawValue: Int(arc4random_uniform(5))) ?? .sunrise
    }
}
