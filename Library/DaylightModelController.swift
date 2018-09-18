import UIKit

protocol DaylightModelControllerDelegate: class {
    func daylightModelControllerDidUpdate(_ controller: DaylightModelController)
}

class DaylightModelController {
    weak var delegate: DaylightModelControllerDelegate?

    private var location: Location

    init(location: Location) {
        self.location = location

        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.updateDelegate), userInfo: nil, repeats: true)
    }

    @objc func updateDelegate () {
        self.delegate?.daylightModelControllerDidUpdate(self)
    }
}

extension DaylightModelController {
    
    var primaryColor: UIColor {
        return Theme.primaryColor(for: location.sunTime.sunPhase)
    }

    var secondaryColor: UIColor {
        return Theme.secondaryColor(for: location.sunTime.sunPhase)
    }

    var highlightColor: UIColor {
        return Theme.secondaryColor(for: location.sunTime.sunPhase).withAlphaComponent(0.6)
    }

    var locationLabel: String {
        return "\(location.city), \(location.country)"
    }

    var attributedMessage: NSAttributedString? {
        let message = Message(for: Date(), coordinates: location.coordinates)
        return message.attributedString(textColor: secondaryColor.withAlphaComponent(0.6), highlightColor: secondaryColor)
    }

    var informationMessage: NSAttributedString? {
        return Message.informationMessage.attributedString(textColor: secondaryColor, highlightColor: highlightColor)
    }

    var percentageInDay: CGFloat {
        return CGFloat(location.sunTime.daylightLengthProgress)
    }

    var sunriseTimeString: String {
        return location.sunTime.sunriseTimeString
    }

    var sunsetTimeString: String {
        return location.sunTime.sunsetTimeString
    }

    public var currentTimeString: String {
        return location.sunTime.currentTimeString
    }

    public var shouldShowMoon: Bool {
        return location.sunTime.sunPhase == .night || location.sunTime.sunPhase == .predawn
    }

    public var shouldShowTimeLabel: Bool {
        return location.sunTime.sunPhase == .sunrise || location.sunTime.sunPhase == .solarNoon || location.sunTime.sunPhase == .sunset
    }
}
