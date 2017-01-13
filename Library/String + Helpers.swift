import UIKit

extension String {
    func  attributedString(withColoredPart coloredPart: String, withTextColor textColor: UIColor) -> NSAttributedString {
        let range = (self as NSString).range(of: coloredPart)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: textColor, range: range)
        attributedString.addAttribute(NSKernAttributeName, value: -0.75, range: NSMakeRange(0, self.characters.count))

        return attributedString
    }
}
