import Foundation
import UIKit

protocol SunPhaseSchedulerDelegate: class {
    func sunPhaseScheduler(_ sunPhaseScheduler: SunPhaseScheduler, didUpdateWith backgroundColor: UIColor, and textColor: UIColor)
}

protocol SunPhaseSchedulerDataSource: class {
    func sunPhase(for sunPhaseScheduler: SunPhaseScheduler) -> SunPhase
}

class SunPhaseScheduler: NSObject {
    weak var dataSource: SunPhaseSchedulerDataSource?
    weak var delegate: SunPhaseSchedulerDelegate?

    override init() {
        super.init()

        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
    }

    func update() {
        let sunPhase = self.dataSource?.sunPhase(for: self) ?? .none

        var backgroundColor = UIColor.white
        var textColor = UIColor.black

        switch sunPhase {
        case .sunrise:
            backgroundColor = Theme.sunriseBackground
            textColor = Theme.sunriseText
        case .daylight:
            backgroundColor = Theme.daylightBackground
            textColor = Theme.daylightText
        case .sunset:
            backgroundColor = Theme.sunsetBackground
            textColor = Theme.sunsetText
        case .twilight:
            backgroundColor = Theme.twilightBackground
            textColor = Theme.twilightText
        case .night:
            backgroundColor = Theme.nightBackground
            textColor = Theme.nightText
        default:
            backgroundColor = .white
            textColor = .black
        }

        self.delegate?.sunPhaseScheduler(self, didUpdateWith: backgroundColor, and: textColor)
    }
}

