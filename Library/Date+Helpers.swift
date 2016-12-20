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
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    func datesOfComingYear() -> [Date] {
        var dayArray = [self]

        for i in 0 ..< 365 {
            dayArray.append(dayArray[i].dayAfter())
        }

        return dayArray
    }
}
