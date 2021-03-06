import Foundation

extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()

        self.dateFormat = dateFormat
    }
}

extension Date {
    var dayAfter: Date {
        return Calendar.autoupdatingCurrent.date(byAdding: .day, value: 1, to: self)!
    }

    var dayBefore: Date {
        return Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: self)!
    }

    var isSolstice: Bool {
        return self.isJuneSolstice || self.isDecemberSolstice
    }

    var isDecemberSolstice: Bool {
        let components = Calendar.autoupdatingCurrent.dateComponents([.day, .month, .timeZone], from: self)

        return components.day == 21 && components.month == 12
    }

    var isJuneSolstice: Bool {
        let components = Calendar.autoupdatingCurrent.dateComponents([.day, .month, .timeZone], from: self)

        return components.day == 21 && components.month == 6
    }

    func isBetween(_ beginDate: Date, and endDate: Date) -> Bool {
        if self.compare(beginDate) == .orderedAscending {
            return false
        }

        if self.compare(endDate) == .orderedDescending {
            return false
        }

        return true
    }

    func andNext30Days() -> [Date] {
        var dayArray = [self]

        for i in 0..<30 {
            dayArray.append(dayArray[i].dayAfter)
        }

        return dayArray
    }
}
