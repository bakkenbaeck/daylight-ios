import UIKit

extension UIScreen {
    class func screenshot() -> UIImage {
        var imageSize = CGSize.zero

        let orientation = UIApplication.shared.statusBarOrientation
        if UIInterfaceOrientationIsPortrait(orientation) {
            imageSize = UIScreen.main.bounds.size
        } else {
            imageSize = CGSize(width: UIScreen.main.bounds.size.height, height: UIScreen.main.bounds.size.width)
        }

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        for window in UIApplication.shared.windows {
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
