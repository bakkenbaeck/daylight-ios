import UIKit
import CoreLocation

class MainController: UIViewController {
    var apiClient: APIClient

    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self

        return manager
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Today, Oslo has \n4 minutes less sunlight than yesterday. Sorry."
        label.numberOfLines = 4
        label.font = UIFont.bold(size: 40)

        return label
    }()

    init(apiClient: APIClient) {
        self.apiClient = apiClient

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
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
        
        let margin = CGFloat(30)
        self.descriptionLabel.frame = CGRect(x: margin, y: 0, width: self.view.frame.width - margin * 2, height: self.view.frame.height)
    }
}

extension MainController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.startUpdatingLocation()
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
                for placemark in placemarks {
                    print(placemark.locality!)
                }
            }
        }
    }
}
