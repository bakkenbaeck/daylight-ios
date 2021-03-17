import CoreLocation

protocol LocationTrackerDelegate: class {
    func didFailWithError(_ error: Error, on locationTracker: LocationTracker)
    func didFindLocation(_ placemark: CLPlacemark, on locationTracker: LocationTracker)
    func didUpdateAuthorizationStatus(_ authorizationStatus: CLAuthorizationStatus, on locationTracker: LocationTracker)
}

class LocationTracker: NSObject {
    enum Error: Swift.Error {
        case authorizationError
    }

    weak var delegate: LocationTrackerDelegate?

    private var placemark: CLPlacemark?

    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.delegate = self

        return manager
    }()

    var authorizationStatus: CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }

    func locateIfPossible() {
        switch locationManager.authorizationStatus {
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
            self.delegate?.didFailWithError(Error.authorizationError, on: self)
        default: break
        }

        self.delegate?.didUpdateAuthorizationStatus(authorizationStatus, on: self)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0 else { return }

        self.locationManager.stopUpdatingLocation()

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locations.first!) { placemarks, error in
            if let error = error {
                self.delegate?.didFailWithError(error, on: self)
            } else if let placemarks = placemarks, let placemark = placemarks.first {
                if self.placemark?.country != placemark.country || self.placemark?.locality != placemark.locality {
                    self.placemark = placemark
                    self.delegate?.didFindLocation(placemark, on: self)
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.didFailWithError(error, on: self)
    }
}
