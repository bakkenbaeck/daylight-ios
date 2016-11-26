import UIKit
import CoreLocation

class MainController: UIViewController {
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self

        return manager
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

        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.startUpdatingLocation()
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        default: break
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.backgroundImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)

        let margin = CGFloat(30)
        self.descriptionLabel.frame = CGRect(x: margin, y: 0, width: self.view.frame.width - margin * 2, height: self.view.frame.height)
    }
}

extension MainController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.startUpdatingLocation()
        case .denied, .restricted:
            self.descriptionLabel.text = "We need to know where you are, enable location access in your Settings."
        default: break
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0 else { return }

        self.locationManager.stopUpdatingLocation()

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locations.first!) { placemarks, error in
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else if let placemarks = placemarks {
                let placemark = placemarks.first!
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
    }
}
