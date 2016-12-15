import UIKit
import CoreLocation

class MainController: UIViewController {

    var messageLabelHeightAnchor: NSLayoutConstraint?

    lazy var locationTracker: LocationTracker = {
        let tracker = LocationTracker()
        tracker.delegate = self

        return tracker
    }()

    lazy var informationButton: InformationButton = {
        let button = InformationButton()
        button.addTarget(self, action: #selector(didClickInformation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red

        return button
    }()

    lazy var sunView: SunView = {
        let sunView = SunView()
        sunView.translatesAutoresizingMaskIntoConstraints = false
        sunView.backgroundColor = .red

        return sunView
    }()

    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
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
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSubviewsAndConstraints()
        self.locationTracker.checkAuthorization()
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
        self.informationButton.widthAnchor.constraint(equalToConstant: 44).isActive = true

        self.sunView.heightAnchor.constraint(equalToConstant: 157).isActive = true
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

    func didClickInformation() {
        //TODO: Implement information functionality
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
        let city = placemark.locality!
        let country = placemark.country!

        self.locationLabel.text = "\(city), \(country)"

        let interval = APIClient.dayLengthDifference(for: placemark)
        let minutes = interval / 60
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        let minutesString = formatter.string(from: NSNumber(value: abs(minutes)))!
        self.messageLabel.text = "Happy days! This day is \(minutesString) minutes longer than yesterday. Will you make it count?"

        self.messageLabelHeightAnchor = self.messageLabel.heightAnchor.constraint(equalToConstant: self.messageLabel.height())
        self.view.setNeedsDisplay()
    }
}

extension UILabel {

    public func height() -> CGFloat {
        let size = self.sizeThatFits(CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude))

        return size.height
    }
}
