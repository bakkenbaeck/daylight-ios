import Foundation

public enum SunPhase: String {
    case predawn
    case dawn
    case sunrise
    case solarNoon
    case sunset
    case dusk
    case night
}

public struct SunTime {

    public enum DayOrNight {
        case day
        case night
    }

    let dawnTime = SunTime.dateFormatter.date(from: "2018-09-18 04:46:29+0000")!
    let sunriseTimeStart = SunTime.dateFormatter.date(from: "2018-09-18 05:20:40+0000")!
    let solarNoonTime = SunTime.dateFormatter.date(from: "2018-09-18 11:36:25+0000")!
    let sunsetTimeStart = SunTime.dateFormatter.date(from: "2018-09-18 17:00:56+0000")!
    let sunsetTimeEnd = SunTime.dateFormatter.date(from: "2018-09-18 17:51:26+0000")!
    let duskTime = SunTime.dateFormatter.date(from: "2018-09-18 18:25:37+0000")!
    let nightTimeStart = SunTime.dateFormatter.date(from: "2018-09-18 19:49:29+0000")!

    let date: Date

    public var sunPhase: SunPhase {
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = .autoupdatingCurrent

        let startOfTheDay = calendar.startOfDay(for: self.date)

        if self.date.isBetween(startOfTheDay, and: self.dawnTime) {
            return .predawn
        } else if self.date.isBetween(self.dawnTime, and: self.sunriseTimeStart) {
            return .dawn
        } else if self.date.isBetween(self.sunriseTimeStart, and: self.solarNoonTime) {
            return .sunrise
        } else if self.date.isBetween(self.solarNoonTime, and: self.sunsetTimeStart) {
            return .solarNoon
        } else if self.date.isBetween(self.sunsetTimeStart, and: self.duskTime) {
            return .sunset
        } else if self.date.isBetween(self.duskTime, and: self.nightTimeStart) {
            return .dusk
        } else {
            return .night
        }
    }

    var dayNightCycle: DayOrNight {
        if self.date.isBetween(self.dawnTime, and: self.duskTime) {
            return .day
        }

        return .night
    }

    private let timeFormatter = DateFormatter(dateFormat: "HH:mm")
    public static let dateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd HH:mm:ssZZZ")

    /// Current percentage of the day (based on sunlight).
    // We use this to place the sun.
    public var daylightLengthProgress: Double {
        let timeSinceSunrise = self.date.timeIntervalSince(self.sunriseTimeStart)
        if self.date.isBetween(self.sunriseTimeStart, and: self.sunsetTimeEnd) {
            let totalDaylightDuration = self.sunsetTimeEnd.timeIntervalSince(self.sunriseTimeStart)
            return timeSinceSunrise / totalDaylightDuration
        } else if timeSinceSunrise > 0 {
            return 1
        } else {
            return 0
        }
    }

    public var sunriseTimeString: String {
        return self.timeFormatter.string(from: self.sunriseTimeStart)
    }

    public var sunsetTimeString: String {
        return self.timeFormatter.string(from: self.sunsetTimeEnd)
    }

    public var currentTimeString: String {
        return self.timeFormatter.string(from: self.date)
    }

    public init(date: Date) {
        self.date = date
    }

    func sunriseStartTime(for date: Date) -> Date {
        return self.sunriseTimeStart
    }
}
