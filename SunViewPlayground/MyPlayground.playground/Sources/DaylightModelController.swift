import UIKit

public struct DaylightModelController {
    let sunTime: SunTime

    public var primaryColor: UIColor {
        return primaryColor(for: sunTime.sunPhase)
    }

    public var secondaryColor: UIColor {
        return secondaryColor(for: sunTime.sunPhase)
    }

    public var highlightColor: UIColor {
        return secondaryColor(for: sunTime.sunPhase).withAlphaComponent(0.6)
    }

    public var percentageInDay: CGFloat {
        return CGFloat(sunTime.daylightLengthProgress)
    }

    public var sunriseTimeString: String {
        return sunTime.sunriseTimeString
    }

    public var sunsetTimeString: String {
        return sunTime.sunsetTimeString
    }

    public var currentTimeString: String {
        return sunTime.currentTimeString
    }

    public init(sunTime: SunTime) {
        self.sunTime = sunTime
    }

    public var shouldShowMoon: Bool {
        return sunTime.sunPhase == .night || sunTime.sunPhase == .predawn
    }

    public var shouldShowTimeLabel: Bool {
        return sunTime.sunPhase == .sunrise || sunTime.sunPhase == .solarNoon || sunTime.sunPhase == .sunset
    }

    func primaryColor(for sunPhase: SunPhase) -> UIColor {
        let color: UIColor

        switch sunPhase {
        case .sunrise:
            color = Theme.sunriseBackground
        case .solarNoon:
            color = Theme.daylightBackground
        case .sunset:
            color = Theme.sunsetBackground
        case .dusk, .dawn:
            color = Theme.twilightBackground
        case .night, .predawn:
            color = Theme.nightBackground
        }

        return color
    }

    func secondaryColor(for sunPhase: SunPhase) -> UIColor {
        let color: UIColor

        switch sunPhase {
        case .sunrise:
            color = Theme.sunriseText
        case .solarNoon:
            color = Theme.daylightText
        case .sunset:
            color = Theme.sunsetText
        case .dusk, .dawn:
            color = Theme.twilightText
        case .night, .predawn:
            color = Theme.nightText
        }

        return color
    }
}
