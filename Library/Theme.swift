import UIKit

struct Theme {
    static var sunriseBackground: UIColor {
        return UIColor(hex: "#FDEDA8")
    }

    static var daylightBackground: UIColor {
        return UIColor(hex: "#FADDA4")
    }

    static var sunsetBackground: UIColor {
        return UIColor(hex: "#F7C5B1")
    }

    static var twilightBackground: UIColor {
        return UIColor(hex: "#D3E5FD")
    }

    static var nightBackground: UIColor {
        return UIColor(hex: "#06131F")
    }

    static var sunriseText: UIColor {
        return UIColor(hex: "#DB6028")
    }

    static var daylightText: UIColor {
        return UIColor(hex: "#A04C2C")
    }

    static var sunsetText: UIColor {
        return UIColor(hex: "#A04C2C")
    }

    static var twilightText: UIColor {
        return UIColor(hex: "#40589B")
    }

    static var nightText: UIColor {
        return .white
    }

    static func light(size: CGFloat) -> UIFont {
        return UIFont(name: "GTAmerica-Light", size: size) ?? UIFont.systemFont(ofSize: CGFloat(size), weight: UIFontWeightLight)
    }
}
