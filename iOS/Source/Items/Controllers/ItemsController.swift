import UIKit

class ItemsController: UITableViewController {
    var fetcher: Fetcher

    var cellIdentifier: String {
        return String(describing: UITableViewCell.self)
    }

    init(style: UITableViewStyle = .plain, fetcher: Fetcher) {
        self.fetcher = fetcher

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.register(ItemCell.self, forCellReuseIdentifier: self.cellIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! ItemCell
        cell.textLabel?.text = "Hi there"

        return cell
    }
}
