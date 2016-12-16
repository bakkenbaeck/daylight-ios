#if os(iOS) || os(tvOS)
    import UIKit

    public extension UIImage {

        /**
         Returns the perfect frame to center a UIImage in the screen.
         */
        public func centeredFrame() -> CGRect {
            let screenBounds = UIScreen.main.bounds
            let widthScaleFactor = self.size.width / screenBounds.size.width
            let heightScaleFactor = self.size.height / screenBounds.size.height
            var centeredFrame = CGRect.zero

            let shouldFitHorizontally = widthScaleFactor > heightScaleFactor
            if shouldFitHorizontally && widthScaleFactor > 0 {
                let y = (screenBounds.size.height / 2) - ((self.size.height / widthScaleFactor) / 2)
                centeredFrame = CGRect(x: 0, y: y, width: screenBounds.size.width, height: self.size.height / widthScaleFactor)
            } else if heightScaleFactor > 0 {
                let x = (screenBounds.size.width / 2) - ((self.size.width / heightScaleFactor) / 2)
                centeredFrame = CGRect(x: x, y: 0, width: screenBounds.size.width - (2 * x), height: screenBounds.size.height)
            }

            return centeredFrame
        }

        public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
            let rect = CGRect(origin: .zero, size: size)
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
            color.setFill()
            UIRectFill(rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            guard let cgImage = image?.cgImage else { return nil }
            self.init(cgImage: cgImage)
        }
    }
#endif
