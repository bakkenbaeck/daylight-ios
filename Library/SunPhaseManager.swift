import Foundation
import UIKit

enum SunPhase: Int {
    case sunrise
    case daylight
    case sunset
    case twilight
    case night
}

class SunPhaseManager: NSObject {
    var completionHandler: ((UIColor, UIColor)->Void)

    var sunPhase: SunPhase = .sunrise  {
        willSet {
            if self.sunPhase != newValue {
                self.getNewColors()
            }
        }
    }

    init(completionHandler: @escaping ((UIColor, UIColor)->Void)) {
        self.completionHandler = completionHandler
        super.init()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
    }

    func update() {
        self.sunPhase = APIClient.getSunPhase()
    }

    func getNewColors() {
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
        }

        self.completionHandler(backgroundColor, textColor)
    }
}

