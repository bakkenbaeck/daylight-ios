import UIKit

public extension UIView {

    /**
     Disturbs the view. Useful for getting the user's attention when something changed.
     */
    public func disturb() {
        transform = CGAffineTransform(scaleX: 0.98, y: 0.98)

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 150, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction], animations: {
            self.transform = .identity
        }, completion: nil)
    }

    /**
     Shakes the view. Useful for displaying failures to users.
     */
    public func shake() {
        transform = CGAffineTransform(translationX: 10, y: 0)

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 50, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction], animations: {
            self.transform = .identity
        }, completion: nil)
    }

    public convenience init(withAutoLayout autoLayout: Bool) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = !autoLayout
    }

    public func fillSuperview(with insets: UIEdgeInsets = UIEdgeInsets.zero) {
        guard let superview = self.superview else { return }

        let constants = [
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            self.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: insets.left),
            self.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -insets.right),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom),
        ]

        constants.forEach { constant in
            constant.priority = UILayoutPriority(rawValue: 999)
            constant.isActive = true
        }
    }

    public func set(height: CGFloat) {
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    public func set(width: CGFloat) {
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }

    /// Attach a view to the top of its superview or view controller's top layout guide, if one is supplied
    ///
    /// - Parameter viewController: If not nil, attach the view to the bottom of its top layout guide.
    public func attachToTop(viewController: UIViewController? = nil) {
        guard let superview = self.superview else { return }

        topAnchor.constraint(equalTo: viewController?.topLayoutGuide.bottomAnchor ?? superview.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
    }

    /// Helper method to instantiate a nib file.
    ///
    /// - Parameter nibName: The name of the nib to be loaded. If none is passed, it uses the class name. Defaults to nil.
    /// - Parameter bundle: The bundle where the nib is located, by default we'll use the main bundle.
    /// - Parameter owner: The file owner for the nib. Same as when using UINib(nibName:bundle).instantiate(withOwner:options:).
    /// - Parameter options: The nib options. Same as when using UINib(nibName:bundle).instantiate(withOwner:options:).
    ///
    /// - Returns: Returns an instance of the nib as a UIView.
    public class func instanceFromNib<T: UIView>(nibName: String? = nil, bundle: Bundle = .main, owner: Any? = nil, options: [AnyHashable: Any]? = nil) -> T? {
        let name = nibName ?? String(describing: T.self)
        return UINib(nibName: name, bundle: bundle).instantiate(withOwner: owner, options: options)[0] as? T
    }
}
