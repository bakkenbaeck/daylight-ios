#if os(iOS) || os(tvOS)
    import UIKit

    open class SweetTableController: UIViewController {
        open var tableView: UITableView

        public init(style: UITableViewStyle = .plain) {
            let view = UITableView(frame: .zero, style: style)
            view.translatesAutoresizingMaskIntoConstraints = false
            self.tableView = view

            super.init(nibName: nil, bundle: nil)
        }

        public required init?(coder aDecoder: NSCoder) {
            fatalError("The method `init?(coder)` is not implemented for this class.")
        }

        open override func viewDidLoad() {
            super.viewDidLoad()

            self.view.addSubview(self.tableView)

            self.addConstraints()
        }

        func addConstraints() {
            let anchors = [self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor), self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor), self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor), self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)]
            for anchor in anchors {
                anchor.priority = UILayoutPriorityDefaultLow
                anchor.isActive = true
            }
        }
    }
#endif
