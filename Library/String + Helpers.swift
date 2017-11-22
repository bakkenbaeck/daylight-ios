import UIKit

extension String {

    func attributedString(withColoredPart coloredPart: String, withTextColor textColor: UIColor) -> NSAttributedString {
        let range = (self as NSString).range(of: coloredPart)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: range)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: -0.75, range: NSRange(location: 0, length: self.count))

        return attributedString
    }
}
