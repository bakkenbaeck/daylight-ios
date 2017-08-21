import UIKit

public extension UIScrollView {
    /// A Boolean value that indicates whether the scrollView's contentOffset is located at the top.
    public var isAtTheTop: Bool {
        return self.contentOffset.y <= self.topVerticalContentOffset
    }

    /// A Boolean value that indicates whether the scrollView's contentOffset is located at the bottom.
    public var isAtTheBottom: Bool {
        return self.contentOffset.y >= self.bottomVerticalContentOffset
    }

    private var topVerticalContentOffset: CGFloat {
        let topInset = self.contentInset.top

        return -topInset
    }

    private var bottomVerticalContentOffset: CGFloat {
        let scrollViewHeight = self.bounds.height
        let scrollContentSizeHeight = self.contentSize.height
        let bottomInset = self.contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight

        return scrollViewBottomOffset
    }
}
