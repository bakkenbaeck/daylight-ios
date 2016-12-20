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
        print(sunPhase)

        var backgroundColor = UIColor.white
        var textColor = UIColor.black

        switch sunPhase {
        case .sunrise:
            backgroundColor = .sunrise
            textColor = .sunriseText
        case .daylight:
            backgroundColor = .daylight
            textColor = .daylightText
        case .sunset:
            backgroundColor = .sunset
            textColor = .sunsetText
        case .twilight:
            backgroundColor = .twilight
            textColor = .twilightText
        case .night:
            backgroundColor = .night
            textColor = .nightText
        default:
            backgroundColor = .white
            textColor = .black
        }

        self.delegate?.sunPhaseScheduler(self, didUpdateWith: backgroundColor, and: textColor)
    }
}

