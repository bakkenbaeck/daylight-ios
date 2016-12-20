import UIKit
import CoreLocation
import SweetUIKit

class MainController: UIViewController {
    var messageLabelHeightAnchor: NSLayoutConstraint?

    lazy var informationController: InformationController = {
        let informationController = InformationController()
        informationController.modalTransitionStyle = .crossDissolve

        return informationController
    }()

    lazy var sunPhaseScheduler: SunPhaseScheduler = {
        let scheduler = SunPhaseScheduler()

        return scheduler
    }()

    var message = ""
    var colored = ""
    var percentageInDay = Double(0)

    var backgroundColor = UIColor.white
    var textColor = UIColor.black

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

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSubviewsAndConstraints()

        self.locationTracker.checkAuthorization()

        self.updateLocation()
        self.updateSunView()

        self.sunPhaseScheduler.delegate = self
        self.sunPhaseScheduler.dataSource = self
    }

    func addSubviewsAndConstraints() {
        self.view.addSubview(self.informationButton)
        self.view.addSubview(self.sunView)
        self.view.addSubview(self.messageLabel)
        self.view.addSubview(self.locationLabel)

        let insets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)

        self.informationButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.informationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.informationButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
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

    func updateInterface() {
        let range = (self.message as NSString).range(of: self.colored)
        let attributedString = NSMutableAttributedString(string: self.message)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: self.textColor, range: range)
        let isNight = Location.current?.isNight ?? false

        UIView.animate(withDuration: 0.4) {
            self.view.backgroundColor = self.backgroundColor
            self.sunView.updateInterface(withBackgroundColor: self.backgroundColor, textColor: self.textColor, andPercentageInDay: self.percentageInDay, isNight: isNight)

            self.informationButton.updateInterface(withBackgroundColor: self.backgroundColor, andTextColor: self.textColor)

            self.locationLabel.textColor = self.textColor.withAlphaComponent(0.6)
            self.messageLabel.textColor = self.textColor.withAlphaComponent(0.6)
            self.messageLabel.attributedText = attributedString
            self.messageLabelHeightAnchor = self.messageLabel.heightAnchor.constraint(equalToConstant: self.messageLabel.height())
            self.view.setNeedsLayout()
        }
    }

    func didClickInformation() {
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
}

extension MainController: LocationTrackerDelegate {
    func locationTracker(_ locationTracker: LocationTracker, didFailWith error: NSError) {
        self.messageLabel.text = "We need to know where you are, enable location access in your Settings."

        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    func locationTracker(_ locationTracker: LocationTracker, didFindLocation placemark: CLPlacemark) {
        self.setLocation(with: placemark)
        self.setMessage(for: placemark)
        self.updateInterface()
    }

    func setLocation(with placemark: CLPlacemark) {
        let city = placemark.locality!
        let country = placemark.country!

        self.locationLabel.text = "\(city), \(country)"
    }

    func setMessage(for placemark: CLPlacemark) {
        guard let location = Location(placemark: placemark) else { return }
        let interval = location.dayLengthDifference
        let minutes = interval / 60

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        let minutesString = formatter.string(from: NSNumber(value: abs(minutes)))!

        let messageGenerator = MessageGenerator()
        let message = messageGenerator.message(forDay: Date(), withInterval: interval)

        self.message = String(format: message.text, minutesString)
        self.colored = String(format: message.colored, minutesString)

        self.sunView.update(for: location)
        Location.current = Location(placemark: placemark)
        self.updateLocation()
        self.updateSunView()
        self.updateInterface()
    }
}

extension MainController: SunPhaseSchedulerDelegate {
    func sunPhaseScheduler(_ sunPhaseScheduler: SunPhaseScheduler, didUpdateWith backgroundColor: UIColor, and textColor: UIColor) {
        self.percentageInDay = Location.current?.daylightLengthProgress ?? 0
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.updateSunView()
        self.updateInterface()
    }
}

extension MainController: SunPhaseSchedulerDataSource {
    func sunPhase(for sunPhaseScheduler: SunPhaseScheduler) -> SunPhase {
        let current = Location.current

        return current?.sunPhase ?? .none
    }
}
