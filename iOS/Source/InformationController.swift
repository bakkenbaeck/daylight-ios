import UIKit

protocol InformationControllerDelegate: class {
    func informationController(_ informationController: InformationController, didToggleNotifications isNotificationsEnabled: Bool)
}

class InformationController: UIViewController {
    weak var delegate: InformationControllerDelegate?

    var messageLabelHeightAnchor: NSLayoutConstraint?

    lazy var webButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.addTarget(self, action: #selector(didSelectLinkButton), for: .touchUpInside)

        return button
    }()

    lazy var closeButton: CloseButton = {
        let button = CloseButton()
        button.addTarget(self, action: #selector(didSelectClose), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Theme.light(size: 32)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.textColor = .white

        return label
    }()

    lazy var notificationButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Theme.light(size: 16)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsetsMake(28, 0, 0, 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: ""), for: .disabled)

        return button
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSubviewsAndConstraints()

        self.updateInterface()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateInterface), userInfo: nil, repeats: true)
        self.addObservers()
    }

    func addObservers() {
        self.removeObservers()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateInterface), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    func addSubviewsAndConstraints() {
        self.view.addSubview(self.closeButton)
        self.view.addSubview(self.messageLabel)
        self.view.addSubview(self.notificationButton)
        self.view.addSubview(self.webButton)

        let insets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)

        self.closeButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.closeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.closeButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.closeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -insets.right).isActive = true

        self.messageLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: (2 * -insets.bottom)).isActive = true
        self.messageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: insets.left).isActive = true
        self.messageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -insets.right).isActive = true
        self.messageLabelHeightAnchor = self.messageLabel.heightAnchor.constraint(equalToConstant: self.messageLabel.height())

        self.notificationButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -insets.top).isActive = true
        self.notificationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: insets.left).isActive = true
        self.notificationButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.notificationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -insets.right).isActive = true

        self.webButton.bottomAnchor.constraint(equalTo: self.messageLabel.bottomAnchor).isActive = true
        self.webButton.leftAnchor.constraint(equalTo: self.messageLabel.leftAnchor).isActive = true
        self.webButton.rightAnchor.constraint(equalTo: self.messageLabel.rightAnchor).isActive = true
        self.webButton.heightAnchor.constraint(equalToConstant: 44)
    }

    @objc func updateInterface() {
        let sunPhase = Location.current?.sunTime.sunPhase ?? .night
        let (backgroundColor, textColor) = Theme.colors(for: sunPhase)

        var messageString: NSAttributedString {
            let message = Message.informationMessage

            return message.attributedString(withTextColor: textColor)
        }

        var enableNotificationsString: NSAttributedString {
            let content = "Enable notifications"
            let attributedString = NSMutableAttributedString(string: content)
            let range = (content as NSString).range(of: "Enable")
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: range)

            return attributedString
        }

        var turnNotificationsOffString: NSAttributedString {
            let content = "Turn off notifications"
            let attributedString = NSMutableAttributedString(string: content)
            let range = (content as NSString).range(of: "off")
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: range)

            return attributedString
        }

        var turnNotificationsOnString: NSAttributedString {
            let content = "Turn on notifications"
            let attributedString = NSMutableAttributedString(string: content)
            let range = (content as NSString).range(of: "on")
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: range)

            return attributedString
        }

        UIView.animate(withDuration: 0.4) {
            self.view.backgroundColor = backgroundColor
            self.closeButton.updateInterface(withBackgroundColor: backgroundColor, andTextColor: textColor)
            self.notificationButton.titleLabel?.textColor = textColor.withAlphaComponent(0.6)

            self.notificationButton.removeTarget(nil, action: nil, for: .allEvents)
            if Settings.isAllowedToSendNotifications == false {
                self.notificationButton.setAttributedTitle(enableNotificationsString, for: .normal)
                self.notificationButton.addTarget(self, action: #selector(self.openSettings), for: .touchUpInside)
            } else {
                self.notificationButton.addTarget(self, action: #selector(self.didSelectNotifications), for: .touchUpInside)
                if Settings.isNotificationsEnabled {
                    self.notificationButton.setAttributedTitle(turnNotificationsOffString, for: .normal)
                } else {
                    self.notificationButton.setAttributedTitle(turnNotificationsOnString, for: .normal)
                }
            }

            self.messageLabel.textColor = textColor.withAlphaComponent(0.6)
            self.messageLabel.attributedText = messageString
            self.messageLabelHeightAnchor = self.messageLabel.heightAnchor.constraint(equalToConstant: self.messageLabel.height())
            self.view.setNeedsLayout()
        }
    }

    @objc func openSettings() {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
    }

    @objc func didSelectNotifications() {
        self.notificationButton.isEnabled = false
        Settings.isNotificationsEnabled = !Settings.isNotificationsEnabled
        Settings.registerForNotifications()
        self.delegate?.informationController(self, didToggleNotifications: Settings.isNotificationsEnabled)
        self.notificationButton.isEnabled = true
        self.updateInterface()
    }

    @objc func didSelectClose() {
        self.dismiss(animated: true)
    }

    @objc func didSelectLinkButton() {
        UIApplication.shared.open(URL(string: "https://bakkenbaeck.com")!, options: [:], completionHandler: nil)
    }
}
