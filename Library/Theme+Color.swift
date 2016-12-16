import UIKit

extension UIColor {
    class var messageColor: UIColor {
        return .white
    }

    class var sunrise: UIColor {
        return UIColor(hex: "#FDEDA8")
    }

    class var daylight: UIColor {
        return UIColor(hex: "#FADDA4")
    }

    class var sunset: UIColor {
        return UIColor(hex: "#F7C5B1")
    }

    class var twilight: UIColor {
        return UIColor(hex: "#D3E5FD")
    }

    class var night: UIColor {
        return UIColor(hex: "#06131F")
    }

    class var sunriseText: UIColor {
        return UIColor(hex: "#DB6028")
    }

    class var daylightText: UIColor {
        return UIColor(hex: "#A04C2C")
    }

    class var sunsetText: UIColor {
        return UIColor(hex: "#A04C2C")
    }

    class var twilightText: UIColor {
        return UIColor(hex: "#40589B")
    }

    class var nightText: UIColor {
        return .white
    }

    public convenience init(hex: String) {
        let noHashString = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: noHashString)
        scanner.charactersToBeSkipped = CharacterSet.symbols

        var alpha: CGFloat = 1.0
        if noHashString.characters.count > 6 {
            let startIndex = noHashString.characters.index(noHashString.endIndex, offsetBy: -2)
            let alphaString = noHashString.substring(from: startIndex)
            if let value = NumberFormatter().number(from: alphaString) {
                alpha = CGFloat(Float(value) * 0.01)
            }
        }

        var hexInt: UInt32 = 0
        if (scanner.scanHexInt32(&hexInt)) {
            let red = (hexInt >> 16) & 0xFF
            let green = (hexInt >> 8) & 0xFF
            let blue = (hexInt) & 0xFF

            self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
        } else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }
}
