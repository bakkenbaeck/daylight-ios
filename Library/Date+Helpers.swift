import Foundation

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
