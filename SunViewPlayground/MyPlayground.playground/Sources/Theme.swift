import UIKit

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
}
