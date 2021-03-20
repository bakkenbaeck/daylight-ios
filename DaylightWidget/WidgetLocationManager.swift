//
//  WidgetLocationManager.swift
//  DaylightWidgetExtension
//
//  Created by Wesley Cheung on 20/03/2021.
//
import CoreLocation

class WidgetLocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager? {
        didSet {
            self.locationManager!.delegate = self
        }
    }
    private var handler: ((CLLocation) -> Void)?
    
    func fetchLocation(handler: @escaping (CLLocation) -> Void) {
        self.handler = handler
        self.locationManager!.requestLocation()
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality, placemarks?.first?.country, error)
        }
    }    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.handler!(locations.last!)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
