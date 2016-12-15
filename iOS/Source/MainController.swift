import UIKit
import CoreLocation

class MainController: UIViewController {
    lazy var locationTracker: LocationTracker = {
        let tracker = LocationTracker()
        tracker.delegate = self

        return tracker
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.numberOfLines = 0
        label.font = .bold(size: 40)
        label.textColor = .messageColor
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    lazy var backgroundImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "background")!)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
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
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.descriptionLabel)

        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true

        let insets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        self.descriptionLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: insets.top).isActive = true
        self.descriptionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: insets.left).isActive = true
        self.descriptionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -insets.right).isActive = true
        self.descriptionLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -insets.bottom).isActive = true
    }
}

extension MainController: LocationTrackerDelegate {
    func locationTracker(_ locationTracker: LocationTracker, didFailWith error: NSError) {
        self.descriptionLabel.text = "We need to know where you are, enable location access in your Settings."

        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    func locationTracker(_ locationTracker: LocationTracker, didFindLocation placemark: CLPlacemark) {
        let city = placemark.locality!
        let interval = APIClient.dayLengthDifference(for: placemark)
        let minutes = interval / 60
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        let minutesString = formatter.string(from: NSNumber(value: abs(minutes)))!
        if minutes > 0 {
            self.descriptionLabel.text = "Today, \(city) has \n\(minutesString) minutes more sunlight than yesterday. Enjoy!"
        } else {
            self.descriptionLabel.text = "Today, \(city) has \n\(minutesString) minutes less sunlight than yesterday. Sorry."
        }
    }
}
