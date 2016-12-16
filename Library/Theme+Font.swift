import UIKit

extension UIFont {
    class func light(size: CGFloat) -> UIFont {
        return UIFont(name: "GTAmerica-Light", size: size) ?? UIFont.systemFont(ofSize: CGFloat(size), weight: UIFontWeightLight)
    }
}
