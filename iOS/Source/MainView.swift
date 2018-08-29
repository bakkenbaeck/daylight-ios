import UIKit
import TinyConstraints

protocol MainViewDelegate: class {
    func mainView(_ mainView: MainView, didSelectAboutButton button: UIButton)
    func mainView(_ mainView: MainView, didSelectShareButton button: UIButton)
}

class MainView: UIView {
    weak var delegate: MainViewDelegate?

    private let insets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)

    private lazy var informationButton: InformationButton = {
        let button = InformationButton()
        button.addTarget(self, action: #selector(didTapAboutButton(button:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var sunView: SunView = {
        let sunView = SunView()
        sunView.translatesAutoresizingMaskIntoConstraints = false

        return sunView
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Theme.light(size: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.light(size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Share", for: .normal)
        button.titleLabel?.font = Theme.light(size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(shareButtonAction(button:)), for: .touchUpInside)

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubviewsAndConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var informationButtonTopAnchor: NSLayoutConstraint?

    private var locationLabelBottomAnchor: NSLayoutConstraint?
    private var locationLabelLeftAnchor: NSLayoutConstraint?
    private var locationLabelRightAnchor: NSLayoutConstraint?

    private var messageLabelHeightAnchor: NSLayoutConstraint?

    private func addSubviewsAndConstraints() {
        self.addSubview(self.informationButton)
        self.addSubview(self.sunView)
        self.addSubview(self.messageLabel)
        self.addSubview(self.locationLabel)
        self.addSubview(self.shareButton)

        self.informationButtonTopAnchor = self.informationButton.top(to: self)
        self.informationButtonTopAnchor?.isActive = true

        self.informationButton.left(to: self)
        self.informationButton.height(80)
        self.informationButton.right(to: self, offset: -self.insets.right)

        self.sunView.height(133)
        self.sunView.topToBottom(of: self.informationButton, offset: 10, relation: .equalOrGreater)
        self.sunView.left(to: self, offset: self.insets.left)
        self.sunView.right(to: self, offset: -self.insets.right)
        self.sunView.bottomToTop(of: self.messageLabel, offset: -10)

        self.messageLabel.bottom(to: self, offset: (2 * -self.insets.bottom))
        self.messageLabel.left(to: self, offset: self.insets.left)
        self.messageLabel.right(to: self, offset: -self.insets.right)

        let shareButtonSize = CGFloat(50.0)
        self.shareButton.bottom(to: self, offset: -shareButtonSize / 2)
        self.shareButton.width(shareButtonSize)
        self.shareButton.height(shareButtonSize)
        self.shareButton.right(to: self, offset: -self.insets.right)

        let rightInset = CGFloat(-10)

        self.locationLabel.height(22)

        self.locationLabelBottomAnchor = self.locationLabel.bottom(to: self, offset: -self.insets.top)
        self.locationLabelBottomAnchor?.isActive = true

        self.locationLabelLeftAnchor = self.locationLabel.left(to: self, offset: self.insets.left)
        self.locationLabelLeftAnchor?.isActive = true

        self.locationLabelRightAnchor = self.locationLabel.right(to: self.shareButton, offset: rightInset)
        self.locationLabelRightAnchor?.isActive = true
    }

    func screenshot() -> UIImage {
        let margin = CGFloat(20)
        let height = CGFloat(450)
        let daylightLabelWidth = CGFloat(100)

        let screenShotInsets = UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32)

        let y = self.messageLabel.frame.maxY - height + margin

        let overlayView = UIView(frame: CGRect(x: 0, y: y, width: self.frame.width, height: height))
        self.addSubview(overlayView)

        self.informationButtonTopAnchor?.isActive = false
        let screenshotInformationTopAnchor = self.informationButton.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: -18)
        screenshotInformationTopAnchor.isActive = true

        self.locationLabelBottomAnchor?.isActive = false
        self.locationLabelLeftAnchor?.isActive = false
        self.locationLabelRightAnchor?.isActive = false

        let screenshotLocationCenterYAnchor = self.locationLabel.topAnchor.constraint(equalTo: self.informationButton.centerYAnchor)
        screenshotLocationCenterYAnchor.isActive = true

        let screenshotLocationRightAnchor = self.locationLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -screenShotInsets.right)
        screenshotLocationRightAnchor.isActive = true

        let screenshotLocationLeftAnchor = self.locationLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: daylightLabelWidth + screenShotInsets.right)
        screenshotLocationLeftAnchor.isActive = true

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

    @objc func shareButtonAction(button: UIButton) {
        self.delegate?.mainView(self, didSelectShareButton: button)
    }

    @objc func didTapAboutButton(button: UIButton) {
        self.delegate?.mainView(self, didSelectAboutButton: button)
    }

    func updateInterface(location: Location?) {
        if let location = location {
            self.locationLabel.text = "\(location.city), \(location.country)"

            self.shareButton.isHidden = false
            self.informationButton.isHidden = false
            self.sunView.isHidden = false
            self.locationLabel.isHidden = false

            let percentageInDay = location.sunTime.daylightLengthProgress

            let sunPhase = location.sunTime.sunPhase
            let (backgroundColor, textColor) = Theme.colors(for: sunPhase)

            let message = Message(for: Date(), coordinates: location.coordinates)
            let attributedString = message.attributedString(textColor: textColor.withAlphaComponent(0.6), highlightColor: textColor)

            UIView.animate(withDuration: 0.4) {
                self.window?.backgroundColor = backgroundColor
                self.backgroundColor = backgroundColor
                self.sunView.updateInterface(withBackgroundColor: backgroundColor, textColor: textColor, andPercentageInDay: percentageInDay, sunPhase: sunPhase)
                self.sunView.update(for: location)

                self.informationButton.updateInterface(withBackgroundColor: backgroundColor, andTextColor: textColor)

                self.shareButton.setTitleColor(textColor, for: .normal)
                self.locationLabel.textColor = textColor.withAlphaComponent(0.6)

                self.messageLabel.attributedText = attributedString
                self.setNeedsLayout()
            }
        } else {
            self.messageLabel.textColor = UIColor.white
            self.backgroundColor = UIColor.black

            self.shareButton.isHidden = true
            self.informationButton.isHidden = true
            self.sunView.isHidden = true
            self.locationLabel.isHidden = true
        }
    }
}
