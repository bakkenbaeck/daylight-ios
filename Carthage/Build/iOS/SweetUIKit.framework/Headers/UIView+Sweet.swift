#if os(iOS) || os(tvOS)
    import UIKit

    public extension UIView {

        /**
         Shakes the view. Useful for displaying failures to users.
         */
        public func shake() {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.1
            animation.repeatCount = 2
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10.0, y: self.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10.0, y: self.center.y))
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            self.layer.add(animation, forKey: "position")
        }

        public convenience init(withAutoLayout autoLayout: Bool) {
            self.init()
            self.translatesAutoresizingMaskIntoConstraints = !autoLayout
        }

        public func fillSuperview(with insets: UIEdgeInsets = UIEdgeInsets.zero) {
            guard let superview = self.superview else { return }

            let constants = [
                self.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
                self.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: insets.left),
                self.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -insets.right),
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
            ]

            constants.forEach { constant in
                constant.priority = UILayoutPriorityDefaultLow
                constant.isActive = true
            }
        }

        public func set(height: CGFloat) {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }

        public func set(width: CGFloat) {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        public func attachToTop() {
            guard let superview = self.superview else { return }

            self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            self.leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            self.rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        }
    }

#endif
