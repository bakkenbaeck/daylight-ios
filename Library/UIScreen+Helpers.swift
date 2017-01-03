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

        var canvasSize = imageSize
        canvasSize.height = 450

        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0)
        for window in UIApplication.shared.windows {
            var bounds = window.bounds
            bounds.origin.y = -(bounds.height - canvasSize.height)
            window.drawHierarchy(in: bounds, afterScreenUpdates: true)
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
