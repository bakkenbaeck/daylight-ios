import UIKit

protocol DaylightModelControllerDelegate: class {
    func daylightModelControllerDidUpdate(with daylightController: DaylightModelController)
}

class DaylightModelController {
    weak var delegate: DaylightModelControllerDelegate?

    private var location: Location
    private var sunTime: SunTime

    init(location: Location) {
        self.location = location
        self.sunTime = SunTime(date: Date(), coordinate: location.coordinates)

        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        self.addObservers()
    }

    func addObservers() {
        self.removeObservers()
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }


    @objc func update () {
        self.sunTime.date = Date()
        self.delegate?.daylightModelControllerDidUpdate(with: self)
    }
}

extension DaylightModelController {
    
    var primaryColor: UIColor {
        return Theme.primaryColor(for: sunTime.sunPhase)
    }

    var secondaryColor: UIColor {
        return Theme.secondaryColor(for: sunTime.sunPhase)
    }

    var highlightColor: UIColor {
        return Theme.secondaryColor(for: sunTime.sunPhase).withAlphaComponent(0.6)
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
        return CGFloat(sunTime.daylightLengthProgress)
    }

    var sunriseTimeString: String {
        return sunTime.sunriseTimeString
    }

    var sunsetTimeString: String {
        return sunTime.sunsetTimeString
    }

    public var currentTimeString: String {
        return sunTime.currentTimeString
    }

    public var shouldShowMoon: Bool {
        return sunTime.sunPhase == .night || sunTime.sunPhase == .predawn
    }

    public var shouldShowTimeLabel: Bool {
        return sunTime.sunPhase == .sunrise || sunTime.sunPhase == .solarNoon || sunTime.sunPhase == .sunset
    }
}
