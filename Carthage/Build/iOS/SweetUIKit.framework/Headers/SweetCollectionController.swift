import UIKit

open class SweetCollectionController: UIViewController {
    open var collectionView: UICollectionView

    public init(collectionViewLayout layout: UICollectionViewLayout = UICollectionViewFlowLayout()) {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView = view

        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder _: NSCoder) {
        fatalError("The method `init?(coder)` is not implemented for this class.")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.collectionView)

        self.addConstraints()
    }

    func addConstraints() {
        let anchors = [self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor), self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor), self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor), self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)]
        for anchor in anchors {
            anchor.priority = UILayoutPriorityDefaultLow
            anchor.isActive = true
        }
    }
}
