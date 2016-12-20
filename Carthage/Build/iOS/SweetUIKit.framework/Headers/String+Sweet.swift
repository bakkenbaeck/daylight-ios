import UIKit

extension String {

    func width(for font: UIFont) -> CGFloat {
        let attributes = [NSFontAttributeName: font]
        let rect = (self as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

        return rect.width
    }
}
