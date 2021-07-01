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
    
    func locationAuthorizationStatus() -> CLAuthorizationStatus {
        var locationAuthorizationStatus : CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            locationAuthorizationStatus =  locationManager.authorizationStatus
        } else {
            // Fallback on earlier versions
            locationAuthorizationStatus = CLLocationManager.authorizationStatus()
        }
        return locationAuthorizationStatus
    }
    
    func locateIfPossible() {
        switch self.locationAuthorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.startUpdatingLocation()
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        default: break
        }
    }
}

extension LocationTracker: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.startUpdatingLocation()
        case .denied, .restricted:
            self.delegate?.didFailWithError(Error.authorizationError, on: self)
        default: break
        }
    
        self.delegate?.didUpdateAuthorizationStatus(status, on: self)
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

    private func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.didFailWithError(error, on: self)
    }
}
