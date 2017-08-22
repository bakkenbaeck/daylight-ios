import UIKit

public extension IndexPath {

    public enum Direction {
        case same
        case before
        case ahead
    }

    fileprivate func comparePosition(_ ownRow: Int, otherRow: Int) -> Direction {
        if ownRow == otherRow {
            return .same
        } else if ownRow < otherRow {
            return .before
        } else {
            return .ahead
        }
    }

    public func comparePosition(to indexPath: IndexPath) -> Direction {
        if self.section == indexPath.section {
            return self.comparePosition(self.row, otherRow: indexPath.row)
        } else if self.section < indexPath.section {
            return .before
        } else {
            return .ahead
        }
    }

    public static func firstIndexPathForIndex(collectionView: UICollectionView, index: Int) -> IndexPath? {
        var count = 0
        let sections = collectionView.numberOfSections
        for section in 0 ..< sections {
            let rows = collectionView.numberOfItems(inSection: section)
            if index >= count && index < count + rows {
                let foundRow = index - count
                return IndexPath(row: foundRow, section: section)
            }
            count += rows
        }

        return nil
    }

    public func totalRowCount(collectionView: UICollectionView) -> Int {
        var count = 0
        let sections = collectionView.numberOfSections
        for section in 0 ..< sections {
            if section < self.section {
                let rows = collectionView.numberOfItems(inSection: section)
                count += rows
            }
        }

        return count + self.row
    }
}
