import UIKit

public extension UIScrollView {
    /// A Boolean value that indicates whether the scrollView's contentOffset is located at the top.
    public var isAtTheTop: Bool {
        return contentOffset.y <= topVerticalContentOffset
    }

    /// A Boolean value that indicates whether the scrollView's contentOffset is located at the bottom.
    public var isAtTheBottom: Bool {
        return contentOffset.y >= bottomVerticalContentOffset
    }

    private var topVerticalContentOffset: CGFloat {
        let topInset = contentInset.top

        return -topInset
    }

    private var bottomVerticalContentOffset: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight

        return scrollViewBottomOffset
    }
}
