import Foundation
import CoreLocation
import Suntimes

enum SunPhase {
    case sunrise
    case daylight
    case sunset
    case twilight
    case night
    case none
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
