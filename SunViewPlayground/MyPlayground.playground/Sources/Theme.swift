import UIKit

public enum SunPhase: String {
    case predawn
    case dawn
    case sunrise
    case solarNoon
    case sunset
    case dusk
    case night
}

var sunPhase: SunPhase {
    var calendar = Calendar.autoupdatingCurrent
    calendar.timeZone = .autoupdatingCurrent

    let startOfTheDay = calendar.startOfDay(for: self.date)

    if self.date.isBetween(startOfTheDay, and: self.sunTimes.dawnTime) {
        return .predawn
    } else if self.date.isBetween(self.sunTimes.dawnTime, and: self.sunTimes.sunriseTimeStart) {
        return .dawn
    } else if self.date.isBetween(self.sunTimes.sunriseTimeStart, and: self.sunTimes.solarNoonTime) {
        return .sunrise
    } else if self.date.isBetween(self.sunTimes.solarNoonTime, and: self.sunTimes.sunsetTimeEnd) {
        return .solarNoon
    } else if self.date.isBetween(self.sunTimes.sunsetTimeEnd, and: self.sunTimes.duskTime) {
        return .sunset
    } else if self.date.isBetween(self.sunTimes.duskTime, and: self.sunTimes.nightTimeStart) {
        return .dusk
    } else {
        return .night
    }
}

public struct Theme {
    public static var sunriseBackground: UIColor {
        return UIColor(hex: "#FDEDA8")
    }

    public static var daylightBackground: UIColor {
        return UIColor(hex: "#FADDA4")
    }

    public static var sunsetBackground: UIColor {
        return UIColor(hex: "#F7C5B1")
    }

    public static var twilightBackground: UIColor {
        return UIColor(hex: "#D3E5FD")
    }

    public static var nightBackground: UIColor {
        return UIColor(hex: "#06131F")
    }

    public static var sunriseText: UIColor {
        return UIColor(hex: "#DB6028")
    }

    public static var daylightText: UIColor {
        return UIColor(hex: "#A04C2C")
    }

    public static var sunsetText: UIColor {
        return UIColor(hex: "#A04C2C")
    }

    public static var twilightText: UIColor {
        return UIColor(hex: "#40589B")
    }

    public static var nightText: UIColor {
        return UIColor(hex: "#90CFEF")
    }

    public static func light(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(size), weight: UIFont.Weight.light)
    }

    public static func primaryColor(for sunPhase: SunPhase) -> UIColor {
        let color: UIColor

        switch sunPhase {
        case .sunrise:
            color = Theme.sunriseBackground
        case .solarNoon:
            color = Theme.daylightBackground
        case .sunset:
            color = Theme.sunsetBackground
        case .dusk, .dawn:
            color = Theme.twilightBackground
        case .night, .predawn:
            color = Theme.nightBackground
        }

        return color
    }

    public static func secondaryColor(for sunPhase: SunPhase) -> UIColor {
        let color: UIColor

        switch sunPhase {
        case .sunrise:
            color = Theme.sunriseText
        case .solarNoon:
            color = Theme.daylightText
        case .sunset:
            color = Theme.sunsetText
        case .dusk, .dawn:
            color = Theme.twilightText
        case .night, .predawn:
            color = Theme.nightText
        }

        return color
    }
}

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
