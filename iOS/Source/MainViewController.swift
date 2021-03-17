//import SweetUIKit
import UIKit
import TinyConstraints

class MainViewController: UIViewController {
    let insets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)

    private var daylightController: DaylightModelController {
        didSet {
            self.update(with: self.daylightController)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private lazy var informationButton: InformationButton = {
        let button = InformationButton()
        button.addTarget(self, action: #selector(didTapAboutButton(button:)), for: .touchUpInside)

        return button
    }()

    private lazy var sunView: SunView = { SunView() }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Theme.light(size: 32)
        label.textColor = .white
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.light(size: 16)
        return label
    }()

    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Share", for: .normal)
        button.titleLabel?.font = Theme.light(size: 16)
        button.addTarget(self, action: #selector(didSelectShareButton(button:)), for: .touchUpInside)

        return button
    }()

    private var informationButtonTopAnchor: NSLayoutConstraint?
    private var locationLabelBottomAnchor: NSLayoutConstraint?
    private var locationLabelLeftAnchor: NSLayoutConstraint?
    private var locationLabelRightAnchor: NSLayoutConstraint?

    init(with dayLightModelController: DaylightModelController) {
        self.daylightController = dayLightModelController
        super.init(nibName: nil, bundle: nil)

        self.daylightController.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .blue
        self.addSubviewsAndConstraints()

        self.update(with: self.daylightController)

        Notifier.cancelAllNotifications()
        if Settings.areNotificationsEnabled {
            Notifier.scheduleNotifications(for: daylightController.sunTime)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.view.alpha = 0.1
        UIView.animate(withDuration: TransitionDuration, animations: {
            self.view.alpha = 1.0
        })
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.update(with: self.daylightController)
    }

    private func addSubviewsAndConstraints() {
        self.view.addSubview(self.informationButton)
        self.view.addSubview(self.sunView)
        self.view.addSubview(self.messageLabel)
        self.view.addSubview(self.locationLabel)
        self.view.addSubview(self.shareButton)

        self.informationButtonTopAnchor = self.informationButton.top(to: self.view)

        self.informationButton.left(to: self.view)
        self.informationButton.height(80)
        self.informationButton.right(to: self.view, offset: -self.insets.right)

        self.sunView.height(133)
        self.sunView.topToBottom(of: self.informationButton, offset: 10, relation: .equalOrGreater)
        self.sunView.left(to: self.view, offset: self.insets.left)
        self.sunView.right(to: self.view, offset: -self.insets.right)
        self.sunView.bottomToTop(of: self.messageLabel, offset: -10)

        let shareButtonSize: CGFloat = 50.0

        self.messageLabel.edges(to: self.view, excluding: .top, insets: TinyEdgeInsets(top: 0, left: self.insets.left, bottom: (2 * -self.insets.bottom), right: -self.insets.right))

        self.shareButton.bottom(to: self.view, offset: -shareButtonSize / 2)
        self.shareButton.size(CGSize(width: shareButtonSize, height: shareButtonSize))
        self.shareButton.right(to: self.view, offset: -self.insets.right)

        self.locationLabel.height(22)

        self.locationLabelBottomAnchor = self.locationLabel.bottom(to: self.view, offset: -self.insets.top)
        self.locationLabelLeftAnchor = self.locationLabel.left(to: self.view, offset: self.insets.left)
        self.locationLabelRightAnchor = self.locationLabel.right(to: self.shareButton, offset: -10)
    }

    @objc func didTapAboutButton(button: UIButton) {
        UIView.animate(withDuration: TransitionDuration, animations: {
            self.view.alpha = 0.1
        }) { _ in
            let informationController = InformationViewController(with: self.daylightController)
            informationController.modalTransitionStyle = .crossDissolve
            informationController.delegate = self
            self.present(informationController, animated: false) {
                self.view.alpha = 1.0
            }
        }
    }

    @objc func didSelectShareButton(button: UIButton) {
        let screenshot = self.screenshot()

        let activityController = UIActivityViewController(activityItems: [screenshot, "Made with #daylightapp."], applicationActivities: nil)
        activityController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
        self.present(activityController, animated: true, completion: nil)
    }

    func update(with daylightController: DaylightModelController) {
        UIView.animate(withDuration: 0.4) {
            self.view.window?.backgroundColor = daylightController.primaryColor
            self.view.backgroundColor = daylightController.primaryColor

            self.shareButton.setTitleColor(daylightController.secondaryColor, for: .normal)
            self.locationLabel.textColor = daylightController.highlightColor

            self.locationLabel.text = daylightController.locationLabel
            self.messageLabel.attributedText = daylightController.attributedMessage

            self.informationButton.updateInterface(with: daylightController)

            self.sunView.updateInterface(with: daylightController)
            self.informationButton.updateInterface(with: daylightController)

            self.view.setNeedsLayout()
        }
    }

    func screenshot() -> UIImage {
        let margin: CGFloat = 20
        let height: CGFloat = 450
        let daylightLabelWidth: CGFloat = 100

        let screenShotInsets = UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32)

        let y = self.messageLabel.frame.maxY - height + margin

        let overlayView = UIView(frame: CGRect(x: 0, y: y, width: self.view.frame.width, height: height))
        self.view.addSubview(overlayView)

        self.informationButtonTopAnchor?.isActive = false
        let screenshotInformationTopAnchor = self.informationButton.top(to: overlayView, offset: -18)

        self.locationLabelBottomAnchor?.isActive = false
        self.locationLabelLeftAnchor?.isActive = false
        self.locationLabelRightAnchor?.isActive = false

        let screenshotLocationCenterYAnchor = self.locationLabel.topAnchor.constraint(equalTo: self.informationButton.centerYAnchor)
        screenshotLocationCenterYAnchor.isActive = true

        let screenshotLocationRightAnchor = self.locationLabel.right(to: self.view, offset: -screenShotInsets.right)
        let screenshotLocationLeftAnchor = self.locationLabel.left(to: self.view, offset: daylightLabelWidth + screenShotInsets.right)

        self.locationLabel.textAlignment = .right

        self.informationButton.nameLabel.text = NSLocalizedString("Daylight", comment: "")
        self.informationButton.nameLabel.sizeToFit()

        let screenshot = UIScreen.screenshot(frame: overlayView.frame)

        self.informationButton.nameLabel.text = NSLocalizedString("About", comment: "")

        self.locationLabel.textAlignment = .left
        screenshotLocationLeftAnchor.isActive = false
        screenshotLocationRightAnchor.isActive = false
        screenshotLocationCenterYAnchor.isActive = false

        self.locationLabelBottomAnchor?.isActive = true
        self.locationLabelLeftAnchor?.isActive = true
        self.locationLabelRightAnchor?.isActive = true

        screenshotInformationTopAnchor.isActive = false
        self.informationButtonTopAnchor?.isActive = true

        overlayView.removeFromSuperview()

        return screenshot
    }
}

extension MainViewController: InformationViewControllerDelegate {

    func didToggleNotifications(_ isNotificationsEnabled: Bool, on informationController: InformationViewController) {
        if isNotificationsEnabled {
            Notifier.scheduleNotifications(for: self.daylightController.sunTime)
        } else {
            Notifier.cancelAllNotifications()
        }
    }
}

extension MainViewController: DaylightModelControllerDelegate {
    func daylightModelControllerDidUpdate(with daylightController: DaylightModelController) {
        self.daylightController = daylightController
    }
}
