import UIKit

public extension UIColor {
    /// Base initializer, it creates an instance of `UIColor` using an HEX string.
    ///
    /// - Parameter hex: The base HEX string to create the color.
    public convenience init(hex: String) {
        let noHashString = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: noHashString)
        scanner.charactersToBeSkipped = CharacterSet.symbols

        var hexInt: UInt32 = 0
        if scanner.scanHexInt32(&hexInt) {
            let red = (hexInt >> 16) & 0xFF
            let green = (hexInt >> 8) & 0xFF
            let blue = hexInt & 0xFF

            self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
        } else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }
}

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
}
