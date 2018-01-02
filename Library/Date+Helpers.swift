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

    func dayAfter() -> Date {
        return Calendar.autoupdatingCurrent.date(byAdding: .day, value: 1, to: self)!
    }

    func futureDates() -> [Date] {
        var dayArray = [self]

        for i in 0 ..< 30 {
            dayArray.append(dayArray[i].dayAfter())
        }

        return dayArray
    }
}
