import Foundation
import CoreLocation
import Sunrise

enum SunPhase {
    case sunrise
    case daylight
    case sunset
    case twilight
    case night

    // TODO: Move inside SunCalc, and add unit tests
    static func get(for date: Date, in timeZone: TimeZone, at coordinate: CLLocationCoordinate2D) -> SunPhase {
        let sunrise = SunriseSet(date: date, timeZone: timeZone, latitude: coordinate.latitude, longitude: coordinate.longitude)
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        let startOfTheDay = calendar.startOfDay(for: date)

        if date.isBetween(startOfTheDay, and: sunrise.astronomicalTwilightStart) {
            return .night
        } else if date.isBetween(sunrise.astronomicalTwilightStart, and: sunrise.nauticalTwilightStart) {
            return .twilight
        } else if date.isBetween(sunrise.nauticalTwilightStart, and: sunrise.civilTwilightStart) {
            return .twilight
        } else if date.isBetween(sunrise.civilTwilightStart, and: sunrise.sunrise) {
            return .twilight
        } else if date.isBetween(sunrise.sunrise, and: sunrise.sunset) {
            return .sunrise
        } else if date.isBetween(sunrise.sunset, and: sunrise.civilTwilightEnd) {
            return .sunset
        } else if date.isBetween(sunrise.civilTwilightEnd, and: sunrise.nauticalTwilightEnd) {
            return .twilight
        } else if date.isBetween(sunrise.nauticalTwilightEnd, and: sunrise.astronomicalTwilightEnd) {
            return .twilight
        } else {
            return .night
        }
    }
}

extension Date {
    func isBetween(_ beginDate: Date, and endDate: Date) -> Bool {
        if self.compare(beginDate) == .orderedAscending {
            return false
        }

        if self.compare(endDate) == .orderedDescending {
            return false
        }

        return true
    }
}
