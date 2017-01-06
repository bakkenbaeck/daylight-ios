import UIKit
import CoreLocation
import SweetUIKit

class MainController: UIViewController {
    let insets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)

    var messageLabelHeightAnchor: NSLayoutConstraint?

    lazy var informationController: InformationController = {
        let informationController = InformationController()
        informationController.modalTransitionStyle = .crossDissolve
        informationController.delegate = self

        return informationController
    }()

    lazy var locationTracker: LocationTracker = {
        let tracker = LocationTracker()
        tracker.delegate = self
        return tracker
    }()

    lazy var informationButton: InformationButton = {
        let button = InformationButton()
        button.addTarget(self, action: #selector(didSelectInformation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    lazy var shareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Share", for: .normal)
        button.titleLabel?.font = Theme.light(size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(share), for: .touchUpInside)

        return button
    }()

    lazy var sunView: SunView = {
        let sunView = SunView()
        sunView.translatesAutoresizingMaskIntoConstraints = false

        return sunView
    }()

    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Theme.light(size: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white

        return label
    }()

    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.light(size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
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
        self.locationTracker.locateIfPossible()
        self.updateLocation()
        self.updateInterface()

        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateInterface), userInfo: nil, repeats: true)

        Notifier.cancelAllNotifications()
        if Settings.isNotificationsEnabled {
            if let location = Location.current {
                Notifier.scheduleNotifications(for: location)
            }
        }
    }

    var informationButtonTopAnchor: NSLayoutConstraint?

    var locationLabelBottomAnchor: NSLayoutConstraint?
    var locationLabelLeftAnchor: NSLayoutConstraint?
    var locationLabelRightAnchor: NSLayoutConstraint?

    func addSubviewsAndConstraints() {
        self.view.addSubview(self.informationButton)
        self.view.addSubview(self.sunView)
        self.view.addSubview(self.messageLabel)
        self.view.addSubview(self.locationLabel)
        self.view.addSubview(self.shareButton)

        self.informationButtonTopAnchor = self.informationButton.topAnchor.constraint(equalTo: self.view.topAnchor)
        self.informationButtonTopAnchor?.isActive = true

        self.informationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.informationButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.informationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.insets.right).isActive = true

        self.sunView.heightAnchor.constraint(equalToConstant: 133).isActive = true
        self.sunView.bottomAnchor.constraint(equalTo: self.messageLabel.topAnchor, constant: -10).isActive = true
        self.sunView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.insets.left).isActive = true
        self.sunView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.insets.right).isActive = true

        self.messageLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: (2 * -self.insets.bottom)).isActive = true
        self.messageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.insets.left).isActive = true
        self.messageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.insets.right).isActive = true
        self.messageLabelHeightAnchor = self.messageLabel.heightAnchor.constraint(equalToConstant: self.messageLabel.height())

        let size = CGFloat(50.0)
        self.shareButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -size / 2).isActive = true
        self.shareButton.widthAnchor.constraint(equalToConstant: size).isActive = true
        self.shareButton.heightAnchor.constraint(equalToConstant: size).isActive = true
        self.shareButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.insets.right).isActive = true

        let rightInset = CGFloat(-10)
        self.locationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        self.locationLabelBottomAnchor = self.locationLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -self.insets.top)
        self.locationLabelBottomAnchor?.isActive = true

        self.locationLabelLeftAnchor = self.locationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.insets.left)
        self.locationLabelLeftAnchor?.isActive = true

        self.locationLabelRightAnchor = self.locationLabel.rightAnchor.constraint(equalTo: self.shareButton.leftAnchor, constant: rightInset)
        self.locationLabelRightAnchor?.isActive = true
    }

    func updateInterface() {
        if let location = Location.current {
            self.shareButton.isHidden = false
            self.informationButton.isHidden = false
            self.sunView.isHidden = false
            self.locationLabel.isHidden = false

            let percentageInDay = location.daylightLengthProgress

            let sunPhase = location.sunPhase
            let (backgroundColor, textColor) = Theme.colors(for: sunPhase)

            let interval = location.dayLengthDifference

            let messageGenerator = MessageGenerator()
            let minutesString = interval.minuteString()
            let generatedMessage = messageGenerator.message(forDay: Date(), sunPhase: location.sunPhase, yesterdayDaylightLength: location.yesterdayDaylightLength, todayDaylightLength: location.todayDaylightLength, tomorrowDaylightLength: location.tomorrowDaylightLength)

            let formattedMessage = String(format: generatedMessage.format, minutesString)
            let message = Message(format: formattedMessage)
            let attributedString = message.attributedString(withTextColor: textColor)

            UIView.animate(withDuration: 0.4) {
                self.view.backgroundColor = backgroundColor
                self.sunView.updateInterface(withBackgroundColor: backgroundColor, textColor: textColor, andPercentageInDay: percentageInDay, sunPhase: sunPhase)
                self.updateSunView()

                self.informationButton.updateInterface(withBackgroundColor: backgroundColor, andTextColor: textColor)

                self.shareButton.setTitleColor(textColor, for: .normal)
                self.locationLabel.textColor = textColor.withAlphaComponent(0.6)
                self.messageLabel.textColor = textColor.withAlphaComponent(0.6)
                self.messageLabel.attributedText = attributedString
                self.messageLabelHeightAnchor = self.messageLabel.heightAnchor.constraint(equalToConstant: self.messageLabel.height())
                self.view.setNeedsLayout()
            }
        } else {
            self.messageLabel.text = "We need to know where you are, please enable location access."
            self.messageLabel.textColor = UIColor.white
            self.view.backgroundColor = UIColor.black

            self.shareButton.isHidden = true
            self.informationButton.isHidden = true
            self.sunView.isHidden = true
            self.locationLabel.isHidden = true
        }
    }

    func didSelectInformation() {
        self.present(self.informationController, animated: true)
    }

    func updateLocation() {
        if let location = Location.current {
            self.locationLabel.text = "\(location.city), \(location.country)"
        }
    }

    func updateSunView() {
        if let location = Location.current {
            self.sunView.update(for: location)
        }
    }

    func share() {
        let margin = CGFloat(20)
        let height = CGFloat(450)
        let y = self.messageLabel.frame.maxY - height + margin

        let overlayView = UIView(frame: CGRect(x: 0, y: y, width: self.view.frame.width, height: height))
        self.view.addSubview(overlayView)

        self.informationButtonTopAnchor?.isActive = false
        let screenshotInformationTopAnchor = self.informationButton.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: -18)
        screenshotInformationTopAnchor.isActive = true

        self.locationLabelBottomAnchor?.isActive = false
        self.locationLabelLeftAnchor?.isActive = false
        self.locationLabelRightAnchor?.isActive = false

        let screenshotLocationTopAnchor = self.locationLabel.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 20)
        screenshotLocationTopAnchor.isActive = true

        let screenshotLocationRightAnchor = self.locationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.insets.right)
        screenshotLocationRightAnchor.isActive = true

        let screenshotLocationLeftAnchor = self.locationLabel.leftAnchor.constraint(equalTo: self.informationButton.leftAnchor)
        screenshotLocationLeftAnchor.isActive = true

        self.locationLabel.textAlignment = .right

        let screenshot = UIScreen.screenshot(frame: overlayView.frame)

        self.locationLabel.textAlignment = .left
        screenshotLocationLeftAnchor.isActive = false
        screenshotLocationRightAnchor.isActive = false
        screenshotLocationTopAnchor.isActive = false

        self.locationLabelBottomAnchor?.isActive = true
        self.locationLabelLeftAnchor?.isActive = true
        self.locationLabelRightAnchor?.isActive = true

        screenshotInformationTopAnchor.isActive = false
        self.informationButtonTopAnchor?.isActive = true

        overlayView.removeFromSuperview()

        let activityController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        activityController.excludedActivityTypes = [UIActivityType.airDrop]
        self.present(activityController, animated: true, completion: nil)
    }
}

extension MainController: LocationTrackerDelegate {
    func locationTracker(_ locationTracker: LocationTracker, didFailWith error: Error) {
        guard Location.current == nil else { return }

        self.messageLabel.text = "We need to know where you are, please enable location access."

        let isUnexpectedError = (error as NSError).code != 0
        if isUnexpectedError {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func locationTracker(_ locationTracker: LocationTracker, didFindLocation placemark: CLPlacemark) {
        Location.current = Location(placemark: placemark)

        self.updateLocation()
        self.updateSunView()
        self.updateInterface()
    }
}

extension MainController: InformationControllerDelegate {
    func informationController(_ informationController: InformationController, didToggleNotifications isNotificationsEnabled: Bool) {
        if isNotificationsEnabled {
            if let location = Location.current {
                Notifier.scheduleNotifications(for: location)
            }
        } else {
            Notifier.cancelAllNotifications()
        }
    }
}
