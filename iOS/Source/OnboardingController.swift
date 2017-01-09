import UIKit

class OnboardingController: UIViewController {
    private let insets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Theme.light(size: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white

        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.light(size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white.withAlphaComponent(0.6)

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSubviewsAndConstraints()

        self.titleLabel.text = "We need to know where you are, please enable location access."
        self.subtitleLabel.text = "Try again"
    }

    private func addSubviewsAndConstraints() {
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.subtitleLabel)

        self.titleLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: (2 * -self.insets.bottom)).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.insets.left).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.insets.right).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: self.titleLabel.height())

        let rightInset = CGFloat(-10)
        self.subtitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        self.subtitleLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -self.insets.top).isActive = true
        self.subtitleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.insets.left).isActive = true
        self.subtitleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: rightInset).isActive = true
    }
}
