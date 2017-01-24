import JavaScriptCore
import Foundation

enum SunPhase {
    case predawn
    case dawn
    case sunrise
    case solarNoon
    case sunset
    case dusk
    case night

    enum Sky {
        case dark
        case light
    }

    var sky: Sky {
        switch self {
        case .predawn, .dawn, .dusk, .night:
            return .dark
        default:
            return .light
        }
    }
}

struct SunCalcEngine {
    static var sharedInstance: SunCalcEngine = {
        let instance = SunCalcEngine()

        return instance
    }()

    var bundle: Bundle = Bundle.main

    private lazy var context: JSContext = {
        // Finding a good sun calculation library in Swift or Objective-C wasn't easy. I tried almost 5 different
        // libraries, none of them gave me the results we wanted. That's why I went for using the library used in
        // http://suncalc.net, this library is also used by the web version of Daylight. In our app, I'm embedding
        // a portion of the library as a JavaScript file that I'll use to calculate the times for an specific date
        // and coordinates.
        let sunCalcLibraryPath = self.bundle.path(forResource: "suncalc", ofType: "js")!
        let sunCalcLibrary = try! String(contentsOfFile: sunCalcLibraryPath)
        let context = JSContext()!
        context.evaluateScript(sunCalcLibrary)

        return context
    }()

    mutating func calculateTimes(withArguments arguments: [Any]) -> [String: Any] {
        let getTimesJavaScriptMethod = self.context.objectForKeyedSubscript("getTimes")!
        return getTimesJavaScriptMethod.call(withArguments: arguments)!.toObjectOf(NSDictionary.self)! as! [String: Any]
    }
}

struct SunCalc {
    private(set) var date: Date
    private(set) var timeZone: TimeZone

    private(set) var dawn: Date
    private(set) var dusk: Date
    private(set) var goldenHour: Date
    private(set) var goldenHourEnd: Date
    private(set) var nadir: Date
    private(set) var nauticalDawn: Date
    private(set) var nauticalDusk: Date
    private(set) var night: Date
    private(set) var nightEnd: Date
    private(set) var solarNoon: Date
    private(set) var sunrise: Date
    private(set) var sunriseEnd: Date
    private(set) var sunset: Date
    private(set) var sunsetStart: Date

    init(date: Date, timeZone: TimeZone, latitude: Double, longitude: Double, bundle: Bundle = Bundle.main) {
        self.date = date
        self.timeZone = timeZone

        SunCalcEngine.sharedInstance.bundle = bundle
        let times = SunCalcEngine.sharedInstance.calculateTimes(withArguments: [date, latitude, longitude])

        self.dawn = times["dawn"] as? Date ?? Date()
        self.dusk = times["dusk"] as? Date ?? Date()
        self.goldenHour = times["goldenHour"] as? Date ?? Date()
        self.goldenHourEnd = times["goldenHourEnd"] as? Date ?? Date()
        self.nadir = times["nadir"] as? Date ?? Date()
        self.nauticalDawn = times["nauticalDawn"] as? Date ?? Date()
        self.nauticalDusk = times["nauticalDusk"] as? Date ?? Date()
        self.night = times["night"] as? Date ?? Date()
        self.nightEnd = times["nightEnd"] as? Date ?? Date()
        self.solarNoon = times["solarNoon"] as? Date ?? Date()
        self.sunrise = times["sunrise"] as? Date ?? Date()
        self.sunriseEnd = times["sunriseEnd"] as? Date ?? Date()
        self.sunset = times["sunset"] as? Date ?? Date()
        self.sunsetStart = times["sunsetStart"] as? Date ?? Date()
    }

    var daylightLengthProgress: Double {
        let timeSinceSunrise = self.date.timeIntervalSince(self.sunrise)
        if self.date.isBetween(self.sunrise, and: self.sunset) {
            let totalDaylightDuration = self.sunset.timeIntervalSince(self.sunrise)
            return timeSinceSunrise / totalDaylightDuration
        } else if timeSinceSunrise > 0 {
            return 1
        } else {
            return 0
        }
    }

    var sunPhase: SunPhase {
        var calendar = Calendar.current
        calendar.timeZone = self.timeZone
        let startOfTheDay = calendar.startOfDay(for: self.date)

        if self.date.isBetween(startOfTheDay, and: self.dawn) {
            return .predawn
        } else if date.isBetween(self.dawn, and: self.sunrise) {
            return .dawn
        } else if date.isBetween(self.sunrise, and: self.solarNoon) {
            return .sunrise
        } else if date.isBetween(self.solarNoon, and: self.sunset) {
            return .solarNoon
        } else if date.isBetween(self.sunset, and: self.dusk) {
            return .sunset
        } else if date.isBetween(self.dusk, and: self.night) {
            return .dusk
        } else {
            return .night
        }
    }
}
