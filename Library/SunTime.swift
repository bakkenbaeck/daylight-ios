import CoreLocation
import Foundation
import JavaScriptCore

extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()

        self.dateFormat = dateFormat
    }
}
/*

 private func suntimes(forDate date: Date) -> SunTime {
 return SunTime(date: date, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
 }

 var sunPhase: SunPhase {
 return self.nowSuntimes.sunPhase
 }

 var daylightLengthProgress: Double {
 return self.nowSuntimes.daylightLengthProgress
 }

 var yesterdayDaylightLength: Double {
 let suntimes = self.suntimes(forDate: self.yesterday)
 return suntimes.sunset.timeIntervalSince(suntimes.sunrise)
 }

 var todayDaylightLength: Double {
 let suntimes = self.suntimes(forDate: self.today)
 return suntimes.sunset.timeIntervalSince(suntimes.sunrise)
 }

 var tomorrowDaylightLength: Double {
 let tomorrowSuntimes = self.suntimes(forDate: self.tomorrow)
 return tomorrowSuntimes.sunset.timeIntervalSince(tomorrowSuntimes.sunrise)
 }

 private var today: Date {
 return Date()
 }

 private var tomorrow: Date {
 return self.calendar.date(byAdding: .day, value: 1, to: self.today)!
 }

 private var yesterday: Date {
 return self.calendar.date(byAdding: .day, value: -1, to: self.today)!
 }

 private var nowSuntimes: SunTime {
 return self.suntimes(forDate: Date())
 }

 */

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

struct SunTime {
    enum SunPhase: String {
        case predawn
        case dawn
        case sunrise
        case solarNoon
        case sunset
        case dusk
        case night
    }

    enum DayOrNight {
        case day
        case night
    }

    struct SunPhaseTimes {
        enum Keys: String {
            case dawnTime = "dawn"
            case duskTime = "dusk"
            case goldenHourStart = "goldenHour"
            case goldenHourEnd
            case nadirTime = "nadir"
            case nauticalDawnTime = "nauticalDawn"
            case nauticalDuskTime = "nauticalDusk"
            case nightTimeStart = "night"
            case nightTimeEnd = "nightEnd"
            case solarNoonTime = "solarNoon"
            case sunriseTimeStart = "sunrise"
            case sunriseTimeEnd = "sunriseEnd"
            case sunsetTimeStart = "sunsetStart"
            case sunsetTimeEnd = "sunset"
        }

        let dawnTime: Date
        let duskTime: Date

        let goldenHourStart: Date
        let goldenHourEnd: Date

        let nadirTime: Date

        let nauticalDawnTime: Date
        let nauticalDuskTime: Date

        let nightTimeStart: Date
        let nightTimeEnd: Date

        let solarNoonTime: Date

        let sunriseTimeStart: Date
        let sunriseTimeEnd: Date

        let sunsetTimeStart: Date
        let sunsetTimeEnd: Date
    }

    private let latitude: CLLocationDegrees
    private let longitude: CLLocationDegrees

    private(set) var date: Date

    let sunTimes: SunPhaseTimes

    var sunPhase: SunPhase {
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = .autoupdatingCurrent

        let startOfTheDay = calendar.startOfDay(for: self.date)

        if self.date.isBetween(startOfTheDay, and: self.sunTimes.dawnTime) {
            return .predawn
        } else if self.date.isBetween(self.sunTimes.dawnTime, and: self.sunTimes.sunriseTimeStart) {
            return .dawn
        } else if self.date.isBetween(self.sunTimes.sunriseTimeStart, and: self.sunTimes.solarNoonTime) {
            return .sunrise
        } else if self.date.isBetween(self.sunTimes.solarNoonTime, and: self.sunTimes.sunsetTimeEnd) {
            return .solarNoon
        } else if self.date.isBetween(self.sunTimes.sunsetTimeEnd, and: self.sunTimes.duskTime) {
            return .sunset
        } else if self.date.isBetween(self.sunTimes.duskTime, and: self.sunTimes.nightTimeStart) {
            return .dusk
        } else {
            return .night
        }
    }

    var dayNightCycle: DayOrNight {
        if self.date.isBetween(self.sunTimes.dawnTime, and: self.sunTimes.duskTime) {
            return .day
        }

        return .night
    }

    private let timeFormatter = DateFormatter(dateFormat: "HH:mm")

    /// Current percentage of the day (based on sunlight).
    // We use this to place the sun.
    var daylightLengthProgress: Double {
        let timeSinceSunrise = self.date.timeIntervalSince(self.sunTimes.sunriseTimeStart)
        if self.date.isBetween(self.sunTimes.sunriseTimeStart, and: self.sunTimes.sunsetTimeEnd) {
            let totalDaylightDuration = self.sunTimes.sunsetTimeEnd.timeIntervalSince(self.sunTimes.sunriseTimeStart)
            return timeSinceSunrise / totalDaylightDuration
        } else if timeSinceSunrise > 0 {
            return 1
        } else {
            return 0
        }
    }

    var sunriseTimeString: String {
        return self.timeFormatter.string(from: self.sunTimes.sunriseTimeStart)
    }

    var sunsetTimeString: String {
        return self.timeFormatter.string(from: self.sunTimes.sunsetTimeEnd)
    }

    var dayLengthDifference: Double {
        let dayBefore = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: self.date)!

        let daySunTimes = self.sunTimes
        let dayBeforeSunTimes = SunTime.sunPhaseTimes(for: dayBefore, latitude: self.latitude, longitude: self.longitude)

        let dayLength = daySunTimes.sunsetTimeEnd.timeIntervalSince(daySunTimes.sunriseTimeStart)
        let dayBeforeDayLength = dayBeforeSunTimes.sunsetTimeEnd.timeIntervalSince(dayBeforeSunTimes.sunriseTimeStart)

        return dayLength - dayBeforeDayLength
    }

    init(date: Date, coordinate: CLLocationCoordinate2D) {
        self.date = date

        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude

        self.sunTimes = SunTime.sunPhaseTimes(for: self.date, latitude: self.latitude, longitude: self.longitude)
    }

    static func sunPhaseTimes(for date: Date, latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> SunPhaseTimes {
        let times = SunCalcEngine.sharedInstance.calculateTimes(withArguments: [date, latitude, longitude]) as! [String: Date]

        return SunPhaseTimes(dawnTime: times[SunPhaseTimes.Keys.dawnTime.rawValue]!,
                             duskTime: times[SunPhaseTimes.Keys.duskTime.rawValue]!,
                             goldenHourStart: times[SunPhaseTimes.Keys.goldenHourStart.rawValue]!,
                             goldenHourEnd: times[SunPhaseTimes.Keys.goldenHourEnd.rawValue]!,
                             nadirTime: times[SunPhaseTimes.Keys.nadirTime.rawValue]!,
                             nauticalDawnTime: times[SunPhaseTimes.Keys.nauticalDawnTime.rawValue]!,
                             nauticalDuskTime: times[SunPhaseTimes.Keys.nauticalDuskTime.rawValue]!,
                             nightTimeStart: times[SunPhaseTimes.Keys.nightTimeStart.rawValue]!,
                             nightTimeEnd: times[SunPhaseTimes.Keys.nightTimeEnd.rawValue]!,
                             solarNoonTime: times[SunPhaseTimes.Keys.solarNoonTime.rawValue]!,
                             sunriseTimeStart: times[SunPhaseTimes.Keys.sunriseTimeStart.rawValue]!,
                             sunriseTimeEnd: times[SunPhaseTimes.Keys.sunriseTimeEnd.rawValue]!,
                             sunsetTimeStart: times[SunPhaseTimes.Keys.sunsetTimeStart.rawValue]!,
                             sunsetTimeEnd: times[SunPhaseTimes.Keys.sunsetTimeEnd.rawValue]!)
    }

    func sunriseStartTime(for date: Date) -> Date {
        return SunTime.sunPhaseTimes(for: date, latitude: self.latitude, longitude: self.longitude).sunriseTimeStart
    }

    func daylightLengthDifference(on date: Date) -> Double {
        let dayBefore = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: date)!

        let daySunTimes = SunTime.sunPhaseTimes(for: date, latitude: self.latitude, longitude: self.longitude)
        let dayBeforeSunTimes = SunTime.sunPhaseTimes(for: dayBefore, latitude: self.latitude, longitude: self.longitude)

        let dayLength = daySunTimes.sunsetTimeEnd.timeIntervalSince(daySunTimes.sunriseTimeStart)
        let dayBeforeDayLength = dayBeforeSunTimes.sunsetTimeEnd.timeIntervalSince(dayBeforeSunTimes.sunriseTimeStart)

        return dayLength - dayBeforeDayLength
    }
}
