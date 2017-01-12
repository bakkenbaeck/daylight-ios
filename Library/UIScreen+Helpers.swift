import UIKit

extension UIScreen {

    class func screenshot(frame: CGRect) -> UIImage {
        let imageSize = CGSize(width: UIScreen.main.bounds.size.width, height: frame.size.height)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        for window in UIApplication.shared.windows {
            var bounds = window.bounds
            bounds.origin.y = -frame.origin.y
            window.drawHierarchy(in: bounds, afterScreenUpdates: true)
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }
}
