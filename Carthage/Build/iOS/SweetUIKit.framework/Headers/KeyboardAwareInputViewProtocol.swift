import UIKit

/*
 Due to how the keyboard works on iOS, to have an input bar always above it, the usual way is
 to set the _inputAccessoryView_ to the view we want to display above it and let the system take care of it.
 Sadly, this means that the input accessory view disappears from the screen if the keyboard is dismissed.
 To improve on this, what we do here is create a fake input accessory view, that has no height, and the view we wanted to use
 as the input accessory view is attached to the bottom of the screen instead.

 We use the fake accessory to access its superview (before iOS10, that was not needed, we could observe the input accessory view's own frame),
 and observe if it's _centre_ property changes. When it does, we use the superview frame to recalculate the actual input accessory view (attached
 to the main window, no the keyboard window) position. Thus, we're able to keep the input accessory always above the keyboard, but also always visible.
 */

/// A UIViewController that conforms to this protocol can use the inputView(:shouldUpdatePosition:) callback
/// to keep a view always in sync with the keyboard.
public protocol KeyboardAwareAccessoryViewDelegate: class {

    /// This method is called every time the keyboard moves and sends back the keyboard origin y coordinate point.
    /// Use this to keep your view always above the keyboard.
    ///
    /// - Also:
    ///   - When the keyboard is offscreen, the point returned is 0.
    ///
    /// - Parameters:
    ///   - inputView: The KeyboardAwareInputAccessoryView instance. You don't usually need it.
    ///   - keyboardOriginYDistance: The distance from the top of the keyboard to the bottom of the screen.
    func inputView(_ inputView: KeyboardAwareInputAccessoryView, shouldUpdatePosition keyboardOriginYDistance: CGFloat)

    /// This is not the actual input view. This is a view we use as proxy to get the exact position of the keyboard.
    var keyboardAwareInputView: KeyboardAwareInputAccessoryView { get }

    /// You need to implement this property to return the keyboardAwareInputView for everything to work.
    var inputAccessoryView: UIView? { get }
}

private var valueKey: UInt8 = 0 // We still need this boilerplate

public extension KeyboardAwareAccessoryViewDelegate where Self: UIResponder {
    var keyboardAwareInputView: KeyboardAwareInputAccessoryView {
        return self.associatedObject(base: self, key: &valueKey) { () -> KeyboardAwareInputAccessoryView in

            let view = KeyboardAwareInputAccessoryView(withAutoLayout: true)
            view.delegate = self

            return view
        }
    }

    func associatedObject<ValueType: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, initialiser: () -> ValueType) -> ValueType {
        if let associated = objc_getAssociatedObject(base, key) as? ValueType {
            return associated
        }

        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)

        return associated
    }

    func associateObject<ValueType: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, value: ValueType?) {
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
    }
}

open class KeyboardAwareInputAccessoryView: UIView {
    open weak var delegate: KeyboardAwareAccessoryViewDelegate?

    fileprivate var storedSuperview = UIView()

    fileprivate var inputAccessoryContext = 0

    fileprivate lazy var observableKeyPath: String = {
        "self.center"
    }()

    open var height: CGFloat = 0 {
        didSet {
            self.invalidateLayout()
        }
    }

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: self.height)
    }

    open override func didMoveToSuperview() {
        if let superview = self.delegate?.inputAccessoryView?.superview {
            self.storedSuperview = superview
            self.storedSuperview.addObserver(self, forKeyPath: self.observableKeyPath, options: .new, context: &self.inputAccessoryContext)
        } else {
            self.storedSuperview.removeObserver(self, forKeyPath: self.observableKeyPath, context: &self.inputAccessoryContext)
        }
    }

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == self.observableKeyPath {
            let superview = self.storedSuperview

            /*
             To get the constant we need here, to keep input view on the correct position at all times,
             we need the following:
             First, we need the visible height of the keyboard on screen. We get that by intersecting the fakeInputAccessorySuperview
             (in actuality, the UIInputSetHostView, a subview inside the keyboard window), with the app's main window.
             We then use it's negative value, as we're dealing with an inversed constraint. That's it.
             */
            guard let window = self.window else { return }
            let constant = -(superview.frame.intersection(window.bounds).height)

            self.delegate?.inputView(self, shouldUpdatePosition: constant)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    func invalidateLayout() {
        if self.frame.isEmpty { return }
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
}
