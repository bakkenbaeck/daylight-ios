import UIKit

class InformationController: UIViewController {
    var messageLabelHeightAnchor: NSLayoutConstraint?

    lazy var sunPhaseScheduler: SunPhaseScheduler = {
        let scheduler = SunPhaseScheduler()

        return scheduler
    }()

    var notifications = false

    lazy var closeButton: CloseButton = {
        let button = CloseButton()
        button.addTarget(self, action: #selector(didClickClose), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .light(size: 32)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.textColor = .white

        return label
    }()

    lazy var notificationButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .light(size: 16)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsetsMake(28, 0, 0, 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didClickNotifications), for: .touchUpInside)

        return button
    }()


    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSubviewsAndConstraints()
        self.sunPhaseScheduler.delegate = self
        self.sunPhaseScheduler.dataSource = self
    }

    func addSubviewsAndConstraints() {
        self.view.addSubview(self.closeButton)
        self.view.addSubview(self.messageLabel)
        self.view.addSubview(self.notificationButton)

        let insets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)

        self.closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: insets.top).isActive = true
        self.closeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: insets.left).isActive = true
        self.closeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.closeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -insets.right).isActive = true

        self.messageLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: (2 * -insets.bottom)).isActive = true
        self.messageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: insets.left).isActive = true
        self.messageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -insets.right).isActive = true
        self.messageLabelHeightAnchor = self.messageLabel.heightAnchor.constraint(equalToConstant: self.messageLabel.height())

        self.notificationButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -insets.top).isActive = true
        self.notificationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: insets.left).isActive = true
        self.notificationButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.notificationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -insets.right).isActive = true
    }

    func updateInterface(backgroundColor: UIColor, textColor: UIColor) {
        var messageString: NSAttributedString {
            let message = MessageGenerator().informationMessage
            let colored = MessageGenerator().coloredInformation

            let range = (message as NSString).range(of: colored)
            let attributedString = NSMutableAttributedString(string: message)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: textColor, range: range)

            return attributedString
        }

        var turnNotificationsOffString: NSAttributedString {
            let attributedString = NSMutableAttributedString(string: "Turn notifications off")
            var range = ("Turn notifications off" as NSString).range(of: "Turn notifications")
            attributedString.addAttribute(NSForegroundColorAttributeName, value: textColor.withAlphaComponent(0.6), range: range)
            range = ("Turn notifications off" as NSString).range(of: " off")
            attributedString.addAttribute(NSForegroundColorAttributeName, value: textColor, range: range)

            return attributedString
        }

        var turnNotificationsOnString: NSAttributedString {
            let attributedString = NSMutableAttributedString(string: "Turn notifications on")
            var range = ("Turn notifications on" as NSString).range(of: "Turn notifications")
            attributedString.addAttribute(NSForegroundColorAttributeName, value: textColor.withAlphaComponent(0.6), range: range)
            range = ("Turn notifications on" as NSString).range(of: " on")
            attributedString.addAttribute(NSForegroundColorAttributeName, value: textColor, range: range)

            return attributedString
        }

        UIView.animate(withDuration: 0.4) {
            self.view.backgroundColor = backgroundColor
            self.closeButton.updateInterface(withBackgroundColor: backgroundColor, andTextColor: textColor)

            self.notificationButton.setAttributedTitle(turnNotificationsOnString, for: .normal)
            self.notificationButton.setAttributedTitle(turnNotificationsOffString, for: .selected)
            self.messageLabel.textColor = textColor.withAlphaComponent(0.6)
            self.messageLabel.attributedText = messageString
            self.messageLabelHeightAnchor = self.messageLabel.heightAnchor.constraint(equalToConstant: self.messageLabel.height())
            self.view.setNeedsLayout()
        }
    }

    func didClickNotifications() {
        self.notifications = !self.notifications
        self.notificationButton.isSelected = !self.notificationButton.isSelected
    }

    func didClickClose() {
        self.dismiss(animated: true)
    }
}

extension InformationController: SunPhaseSchedulerDelegate {
    func sunPhaseScheduler(_ sunPhaseScheduler: SunPhaseScheduler, didUpdateWith backgroundColor: UIColor, and textColor: UIColor) {
        self.updateInterface(backgroundColor: backgroundColor, textColor: textColor)
    }
}

extension InformationController: SunPhaseSchedulerDataSource {
    func sunPhase(for sunPhaseScheduler: SunPhaseScheduler) -> SunPhase {
        let current = Location.current

        return current?.sunPhase ?? .none
    }
}
