import UIKit

protocol MainViewDelegate: class {
    func mainView(_ mainView: MainView, didSelectAboutButton button: UIButton)
    func mainView(_ mainView: MainView, didSelectShareButton button: UIButton)
}

class MainView: UIView {
    weak var delegate: MainViewDelegate?

    private let insets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)

    private lazy var informationButton: InformationButton = {
        let button = InformationButton()
        button.addTarget(self, action: #selector(aboutButtonAction(button:)), for: .touchUpInside)
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

        self.informationButtonTopAnchor = self.informationButton.topAnchor.constraint(equalTo: self.topAnchor)
        self.informationButtonTopAnchor?.isActive = true

        self.informationButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.informationButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.informationButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.insets.right).isActive = true

        self.sunView.heightAnchor.constraint(equalToConstant: 133).isActive = true
        self.sunView.bottomAnchor.constraint(equalTo: self.messageLabel.topAnchor, constant: -10).isActive = true
        self.sunView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.insets.left).isActive = true
        self.sunView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.insets.right).isActive = true

        self.messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: (2 * -self.insets.bottom)).isActive = true
        self.messageLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.insets.left).isActive = true
        self.messageLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.insets.right).isActive = true
        self.messageLabelHeightAnchor = self.messageLabel.heightAnchor.constraint(equalToConstant: self.messageLabel.height())

        let size = CGFloat(50.0)
        self.shareButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -size / 2).isActive = true
        self.shareButton.widthAnchor.constraint(equalToConstant: size).isActive = true
        self.shareButton.heightAnchor.constraint(equalToConstant: size).isActive = true
        self.shareButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.insets.right).isActive = true

        let rightInset = CGFloat(-10)
        self.locationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        self.locationLabelBottomAnchor = self.locationLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.insets.top)
        self.locationLabelBottomAnchor?.isActive = true

        self.locationLabelLeftAnchor = self.locationLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.insets.left)
        self.locationLabelLeftAnchor?.isActive = true

        self.locationLabelRightAnchor = self.locationLabel.rightAnchor.constraint(equalTo: self.shareButton.leftAnchor, constant: rightInset)
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

        let screenshotLocationTopAnchor = self.locationLabel.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 20)
        screenshotLocationTopAnchor.isActive = true

        let screenshotLocationRightAnchor = self.locationLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -screenShotInsets.right)
        screenshotLocationRightAnchor.isActive = true

        let screenshotLocationLeftAnchor = self.locationLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: daylightLabelWidth + screenShotInsets.right)
        screenshotLocationLeftAnchor.isActive = true

        self.locationLabel.textAlignment = .right

        self.informationButton.nameLabel.text = NSLocalizedString("Daylight", comment: "")
        self.informationButton.nameLabel.sizeToFit()

        let screenshot = UIScreen.screenshot(frame: overlayView.frame)
//
//        self.informationButton.nameLabel.text = NSLocalizedString("About", comment: "")
//
//        self.locationLabel.textAlignment = .left
//        screenshotLocationLeftAnchor.isActive = false
//        screenshotLocationRightAnchor.isActive = false
//        screenshotLocationTopAnchor.isActive = false
//
//        self.locationLabelBottomAnchor?.isActive = true
//        self.locationLabelLeftAnchor?.isActive = true
//        self.locationLabelRightAnchor?.isActive = true
//
//        screenshotInformationTopAnchor.isActive = false
//        self.informationButtonTopAnchor?.isActive = true
//
//        overlayView.removeFromSuperview()

        return screenshot
    }

    func shareButtonAction(button: UIButton) {
        self.delegate?.mainView(self, didSelectShareButton: button)
    }

    func aboutButtonAction(button: UIButton) {
        self.delegate?.mainView(self, didSelectAboutButton: button)
    }

    func updateInterface(location: Location?) {
        if let location = location {
            self.locationLabel.text = "\(location.city), \(location.country)"

            self.shareButton.isHidden = false
            self.informationButton.isHidden = false
            self.sunView.isHidden = false
            self.locationLabel.isHidden = false

            let percentageInDay = location.daylightLengthProgress

            let sunPhase = location.sunPhase
            let (backgroundColor, textColor) = Theme.colors(for: sunPhase)

            let interval = location.dayLengthDifference

            let messageGenerator = MessageGenerator()
            let minutesRounded = Int(Darwin.round(interval / 60.0))
            let generatedMessage = messageGenerator.message(forDay: Date(), sunPhase: location.sunPhase, yesterdayDaylightLength: location.yesterdayDaylightLength, todayDaylightLength: location.todayDaylightLength, tomorrowDaylightLength: location.tomorrowDaylightLength)

            let format = NSLocalizedString("number_of_minutes", comment: "")
            let minuteString = String.localizedStringWithFormat(format, minutesRounded)
            let formattedMessage = String(format: generatedMessage.format, minuteString)

            let message = Message(format: formattedMessage)
            let attributedString = message.attributedString(withTextColor: textColor)

            UIView.animate(withDuration: 0.4) {
                self.backgroundColor = backgroundColor
                self.sunView.updateInterface(withBackgroundColor: backgroundColor, textColor: textColor, andPercentageInDay: percentageInDay, sunPhase: sunPhase)
                self.sunView.update(for: location)

                self.informationButton.updateInterface(withBackgroundColor: backgroundColor, andTextColor: textColor)

                self.shareButton.setTitleColor(textColor, for: .normal)
                self.locationLabel.textColor = textColor.withAlphaComponent(0.6)
                self.messageLabel.textColor = textColor.withAlphaComponent(0.6)
                self.messageLabel.attributedText = attributedString
                self.messageLabelHeightAnchor = self.messageLabel.heightAnchor.constraint(equalToConstant: self.messageLabel.height())
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
