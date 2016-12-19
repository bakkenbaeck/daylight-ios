import Foundation
import CoreLocation

enum SunPhase {
    case sunrise
    case daylight
    case sunset
    case twilight
    case night
    case none

    // TODO: Move inside SunCalc, and add unit tests
    static func get(for date: Date, in coordinate: CLLocationCoordinate2D) -> SunPhase {
        let sunCalc = SunCalc(date: date, latitude: coordinate.latitude, longitude: coordinate.longitude)
        if date.isBetween(sunCalc.sunrise, and: sunCalc.sunriseEnd) {
            return .sunrise
        } else if date.isBetween(sunCalc.goldenHour, and: sunCalc.goldenHourEnd) {
            return .daylight
        } else if date.isBetween(sunCalc.sunsetStart, and: sunCalc.sunset) {
            return .sunset
        } else if date.isBetween(sunCalc.dusk, and: sunCalc.nauticalDusk) {
            return .twilight
        } else if date.isBetween(sunCalc.night, and: sunCalc.nightEnd) {
            return .night
        } else {
            return .none
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
