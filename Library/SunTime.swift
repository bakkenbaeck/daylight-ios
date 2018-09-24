import CoreLocation
import Foundation

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
            case nightTimeStart = "night"
            case solarNoonTime = "solarNoon"
            case sunriseTimeStart = "sunrise"
            case sunsetTimeEnd = "sunset"
        }

        let dawnTime: Date
        let duskTime: Date
        let nightTimeStart: Date
        let solarNoonTime: Date
        let sunriseTimeStart: Date
        let sunsetTimeEnd: Date
    }

    private let latitude: CLLocationDegrees
    private let longitude: CLLocationDegrees

    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }

    var date: Date

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

    var currentTimeString: String {
        return self.timeFormatter.string(from: Date())
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
                             nightTimeStart: times[SunPhaseTimes.Keys.nightTimeStart.rawValue]!,
                             solarNoonTime: times[SunPhaseTimes.Keys.solarNoonTime.rawValue]!,
                             sunriseTimeStart: times[SunPhaseTimes.Keys.sunriseTimeStart.rawValue]!,
                             sunsetTimeEnd: times[SunPhaseTimes.Keys.sunsetTimeEnd.rawValue]!)
    }

    func sunriseStartTime(for date: Date) -> Date {
        return SunTime.sunPhaseTimes(for: date, latitude: self.latitude, longitude: self.longitude).sunriseTimeStart
    }

    func daylightLengthDifference(on date: Date) -> Double {
        let dayBefore = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: date)!

        return self.daylightLenghtDifference(from: date, to: dayBefore)
    }

    func daylightLenghtDifference(from fromDate: Date, to toDate: Date) -> Double {
        let daySunTimes = SunTime.sunPhaseTimes(for: toDate, latitude: self.latitude, longitude: self.longitude)
        let dayBeforeSunTimes = SunTime.sunPhaseTimes(for: fromDate, latitude: self.latitude, longitude: self.longitude)

        let dayLength = daySunTimes.sunsetTimeEnd.timeIntervalSince(daySunTimes.sunriseTimeStart)
        let dayBeforeDayLength = dayBeforeSunTimes.sunsetTimeEnd.timeIntervalSince(dayBeforeSunTimes.sunriseTimeStart)

        return dayLength - dayBeforeDayLength
    }
}
