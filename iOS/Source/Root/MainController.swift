import UIKit

class MainController: UIViewController {
    var apiClient: APIClient

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Today, Oslo has 4 minutes less sunlight than yesterday."
        label.numberOfLines = 3
        label.font = UIFont.bold(size: 30)

        return label
    }()

    init(apiClient: APIClient) {
        self.apiClient = apiClient

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(self.descriptionLabel)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let margin = CGFloat(10)
        self.descriptionLabel.frame = CGRect(x: margin, y: 0, width: self.view.frame.width - margin * 2, height: self.view.frame.height)
    }
}
