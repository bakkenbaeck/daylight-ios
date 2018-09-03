import UIKit

class DaylightModelController {
    private var location: Location

    init(location: Location) {
        self.location = location
    }
}

extension  DaylightModelController {
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