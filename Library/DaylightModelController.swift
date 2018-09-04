import CoreLocation
import UIKit

protocol DaylightModelControllerObserver: AnyObject {
    func daylightModelControllerDidUpdate(_ controller: DaylightModelController)
}

class DaylightModelController {
    private var location: Location? {
        didSet {
            updateObservers()
        }
    }

    lazy var locationTracker: LocationTracker = {
        let tracker = LocationTracker()
        tracker.delegate = self

        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.updateObservers), userInfo: nil, repeats: true)

        return tracker
    }()

    init() {
        self.locationTracker.locateIfPossible()
    }

    @objc func updateObservers() {
        
    }
}

extension DaylightModelController {
    var sunPhase: SunTime.SunPhase {
        return location.sunTime.sunPhase
    }
    
    var primaryColor: UIColor {
        return Theme.primaryColor(for: sunPhase)
    }

    var secondaryColor: UIColor {
        return Theme.secondaryColor(for: sunPhase)
    }

    var locationLabel: String {
        return "\(location.city), \(location.country)"
    }

    var attributedMessage: NSAttributedString {
        let message = Message(for: Date(), coordinates: location.coordinates)
        return message.attributedString(textColor: secondaryColor.withAlphaComponent(0.6), highlightColor: secondaryColor)
    }
}
extension DaylightModelController {
    func addObserver(_ observer: DaylightModelControllerObserver) {

    }
}

extension DaylightModelController: LocationTrackerDelegate {

    func locationTracker(_ locationTracker: LocationTracker, didFailWith error: Error) {
        guard Location.current == nil else { return }

        let isUnexpectedError = (error as NSError).code != 0
        if isUnexpectedError {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func locationTracker(_ locationTracker: LocationTracker, didFindLocation placemark: CLPlacemark) {
        self.location = Location(placemark: placemark)

    }
}