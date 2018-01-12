import UIKit

extension String {
    var whole: NSRange {
        return NSRange(location: 0, length: self.count)
    }

    func attributedMessageString(textColor: UIColor, highlightColor: UIColor, highlightedSubstring: String) -> NSAttributedString {
        let string = NSMutableAttributedString(string: self, attributes: [.foregroundColor: textColor, .kern: -0.75])

        let range = (self as NSString).range(of: highlightedSubstring)
        string.addAttribute(.foregroundColor, value: highlightColor, range: range)

        return string
    }
}
