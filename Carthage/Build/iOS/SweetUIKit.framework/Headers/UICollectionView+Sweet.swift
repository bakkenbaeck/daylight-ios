import UIKit

public extension UICollectionView {

    public func register(_ cellClass: UICollectionViewCell.Type) {
        register(cellClass.self, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }

    public func registerNib(_ cellClass: UICollectionViewCell.Type) {
        register(UINib(nibName: cellClass.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }

    public func register(_ supplementaryViewClass: UICollectionReusableView.Type, ofKind kind: String) {
        register(supplementaryViewClass.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: supplementaryViewClass.reuseIdentifier)
    }

    public func dequeue<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T where T: UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as! T
    }

    public func dequeue<T>(_ supplementaryViewClass: T.Type, ofKind kind: String, for indexPath: IndexPath) -> T? where T: UICollectionReusableView {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: supplementaryViewClass.reuseIdentifier, for: indexPath) as? T
    }

    public var indexPaths: [IndexPath] {
        var indexPaths = [IndexPath]()

        let sections = numberOfSections
        for section in 0 ..< sections {
            let rows = numberOfItems(inSection: section)
            for row in 0 ..< rows {
                indexPaths.append(IndexPath(row: row, section: section))
            }
        }

        return indexPaths
    }

    public func nextIndexPath(to indexPath: IndexPath, offset: Int = 0) -> IndexPath? {
        return UICollectionView.nextIndexPath(to: indexPath, offset: offset, source: indexPaths)
    }

    public func previousIndexPath(to indexPath: IndexPath, offset: Int = 0) -> IndexPath? {
        return UICollectionView.nextIndexPath(to: indexPath, offset: offset, source: indexPaths.reversed())
    }

    private class func nextIndexPath(to indexPath: IndexPath, offset: Int = 0, source: [IndexPath]) -> IndexPath? {
        var found = false
        var skippedResults = offset

        for currentIndexPath in source {
            if found == true {
                if skippedResults <= 0 {
                    return currentIndexPath
                }

                skippedResults -= 1
            }

            if currentIndexPath == indexPath {
                found = true
            }
        }

        return nil
    }
}
