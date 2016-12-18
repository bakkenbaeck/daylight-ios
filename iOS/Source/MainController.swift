import UIKit
import CoreLocation

class MainController: UIViewController {
    var sunPhase = SunPhase.night { didSet { self.updateInterface(forSunPhase: self.sunPhase) }}

    var messageLabelHeightAnchor: NSLayoutConstraint?

    var message = ""
    var colored = ""

    lazy var locationTracker: LocationTracker = {
        let tracker = LocationTracker()
        tracker.delegate = self

        return tracker
    }()

    lazy var informationButton: InformationButton = {
        let button = InformationButton()
        button.addTarget(self, action: #selector(didClickInformation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

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
        label.font = .light(size: 32)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.textColor = .white

        return label
    }()

    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .light(size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.textColor = .white

        return label
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
        self.updateInterface(forSunPhase: .sunrise)

        self.locationTracker.checkAuthorization()
        self.updateLocation()
        self.updateMessage()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
    }

    func addSubviewsAndConstraints() {
        self.view.addSubview(self.informationButton)
        self.view.addSubview(self.sunView)
        self.view.addSubview(self.messageLabel)
        self.view.addSubview(self.locationLabel)

        let insets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)

        self.informationButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: insets.top).isActive = true
        self.informationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: insets.left).isActive = true
        self.informationButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.informationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -insets.right).isActive = true

        self.sunView.heightAnchor.constraint(equalToConstant: 133).isActive = true
        self.sunView.bottomAnchor.constraint(equalTo: self.messageLabel.topAnchor, constant: -10).isActive = true
        self.sunView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: insets.left).isActive = true
        self.sunView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -insets.right).isActive = true

        self.messageLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: (2 * -insets.bottom)).isActive = true
        self.messageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: insets.left).isActive = true
        self.messageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -insets.right).isActive = true
        self.messageLabelHeightAnchor = self.messageLabel.heightAnchor.constraint(equalToConstant: self.messageLabel.height())

        self.locationLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -insets.top).isActive = true
        self.locationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: insets.left).isActive = true
        self.locationLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        self.locationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -insets.right).isActive = true
    }

    func update() {
        self.updateInterface(forSunPhase: .daylight)
    }

    func updateInterface(forSunPhase sunPhase: SunPhase) {
        var backgroundColor = UIColor.white
        var textColor = UIColor.black

        switch sunPhase {
        case .sunrise:
            backgroundColor = .sunrise
            textColor = .sunriseText
        case .daylight:
            backgroundColor = .daylight
            textColor = .daylightText
        case .sunset:
            backgroundColor = .sunset
            textColor = .sunsetText
        case .twilight:
            backgroundColor = .twilight
            textColor = .twilightText
        case .night:
            backgroundColor = .night
            textColor = .nightText
        }

        let range = (self.message as NSString).range(of: self.colored)
        let attributedString = NSMutableAttributedString(string: self.message)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: textColor, range: range)

        UIView.animate(withDuration: 0.4) {
            self.view.backgroundColor = backgroundColor
            self.sunView.updateInterface(withColor: textColor)
            self.informationButton.updateInterface(withColor: textColor)

            self.locationLabel.textColor = textColor.withAlphaComponent(0.6)
            self.messageLabel.textColor = textColor.withAlphaComponent(0.6)
            self.messageLabel.attributedText = attributedString
            self.messageLabelHeightAnchor = self.messageLabel.heightAnchor.constraint(equalToConstant: self.messageLabel.height())
            self.view.setNeedsLayout()
        }
    }

    func didClickInformation() {
        //TODO: Implement information functionality
    }

    func updateLocation() {
        if let location = Location.current {
            self.locationLabel.text = "\(location.city), \(location.country)"
        }
    }

    func updateMessage() {
        if let location = Location.current {
            let interval = APIClient.dayLengthDifference(for: location.coordinate)
            let minutes = interval / 60

            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 2
            let minutesString = formatter.string(from: NSNumber(value: abs(minutes)))!

            let messageGenerator = MessageGenerator()
            let message = messageGenerator.message(forDay: Date(), withInterval: interval)

            self.message = String(format: message.0, minutesString)
            self.colored = String(format: message.1, minutesString)
            
            self.sunView.update(for: location)
        }
    }
}

extension MainController: LocationTrackerDelegate {
    func locationTracker(_ locationTracker: LocationTracker, didFailWith error: NSError) {
        self.messageLabel.text = "We need to know where you are, enable location access in your Settings."

        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    func locationTracker(_ locationTracker: LocationTracker, didFindLocation placemark: CLPlacemark) {
        Location.current = Location(placemark: placemark)
        self.updateLocation()
        self.updateMessage()
    }
}

extension UILabel {

    public func height() -> CGFloat {
        let size = self.sizeThatFits(CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude))

        return size.height
    }
}
