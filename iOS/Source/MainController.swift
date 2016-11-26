import UIKit
import CoreLocation

class MainController: UIViewController {
    lazy var locationTracker: LocationTracker = {
        return LocationTracker()
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.numberOfLines = 0
        label.font = .bold(size: 40)
        label.textColor = .messageColor

        return label
    }()

    lazy var backgroundImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "background")!)

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.descriptionLabel)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.backgroundImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)

        let margin = CGFloat(30)
        self.descriptionLabel.frame = CGRect(x: margin, y: 0, width: self.view.frame.width - margin * 2, height: self.view.frame.height)
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
        let interval = APIClient.dayLenghtDifference(for: placemark)
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
