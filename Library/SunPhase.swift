import Foundation
import CoreLocation

enum SunPhase {
    case sunrise // found
    case daylight // golden hour?
    case sunset // found
    case twilight // blue hour?
    case night // found

    static func get(for date: Date, in coordinate: CLLocationCoordinate2D) -> SunPhase {
        let sunCalc = SunCalc(date: date, latitude: coordinate.latitude, longitude: coordinate.longitude)
        if date.isBetween(sunCalc.sunrise, and: sunCalc.sunriseEnd) {
            return .sunrise
        } else if date.isBetween(sunCalc.goldenHour, and: sunCalc.goldenHourEnd) {
            return .daylight
        } else if date.isBetween(sunCalc.sunsetStart, and: sunCalc.sunset) {
            return .sunset
        } else if date.isBetween(sunCalc.blueHour, and: sunCalc.blueHourEnd) {
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
