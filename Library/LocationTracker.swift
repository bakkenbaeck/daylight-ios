import CoreLocation

protocol LocationTrackerDelegate: class {
    func locationTracker(_ locationTracker: LocationTracker, didFailWith error: Error)
    func locationTracker(_ locationTracker: LocationTracker, didFindLocation placemark: CLPlacemark)
}

class LocationTracker: NSObject {
    weak var delegate: LocationTrackerDelegate?

    private var placemark: CLPlacemark?

    static let shared: LocationTracker = {
        let instance = LocationTracker()

        return instance
    }()

    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.delegate = self

        return manager
    }()

    var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }

    func locateIfPossible() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.startUpdatingLocation()
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        default: break
        }
    }
}

extension LocationTracker: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.startUpdatingLocation()
        case .denied, .restricted:
            self.delegate?.locationTracker(self, didFailWith: NSError(domain: "no.bakkenbaeck.sol", code: 9999, userInfo: [NSLocalizedDescriptionKey: "Unauthorized to get location access"]))
        default: break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0 else { return }

        self.locationManager.stopUpdatingLocation()

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locations.first!) { placemarks, error in
            if let error = error {
                self.delegate?.locationTracker(self, didFailWith: error)
            } else if let placemarks = placemarks, let placemark = placemarks.first {
                if self.placemark?.country != placemark.country || self.placemark?.locality != placemark.locality {
                    self.placemark = placemark
                    self.delegate?.locationTracker(self, didFindLocation: placemark)
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.locationTracker(self, didFailWith: error)
    }
}
