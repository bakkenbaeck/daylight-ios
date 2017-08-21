import UIKit

public extension UILabel {

    /**
     Calculates the width of the text. Because of a crash in Swift 3, it uses self.attributedText instead of self.text.
     - returns: The width of the text.
     */
    public func width() -> CGFloat {
        let rect = (self.attributedText ?? NSAttributedString()).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        return rect.width
    }

    /**
     Calculates the height of the text.
     - returns: The height of the text for the current width of the label
     */
    public func height() -> CGFloat {
        let size = self.sizeThatFits(CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude))

        return size.height
    }

    /**
     Sets the attributedString with line spacing.
     - parameter text: The text.
     - parameter lineSpacing: The line spacing (as used in Sketch).
     */
    public func setSpacedOutText(_ text: String, lineSpacing: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing - self.font.pointSize
        paragraphStyle.alignment = self.textAlignment

        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}
