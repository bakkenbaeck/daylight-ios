import JavaScriptCore
import Foundation

enum SunPhase {
    case sunrise
    case daylight
    case sunset
    case twilight
    case night
    case none
}

struct SunCalc {
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

    init(date: Date, timeZone: TimeZone, latitude: Double, longitude: Double) {
        let path = Bundle.main.path(forResource: "suncalc", ofType: "js")!
        let contents = try! String(contentsOfFile: path)
        let context = JSContext()!
        context.evaluateScript(contents)

        let function = context.objectForKeyedSubscript("getTimes")!
        let times = function.call(withArguments: [date, latitude, longitude])!.toObjectOf(NSDictionary.self)!
/*
            {
                dawn = "2013-03-05 04:02:17 +0000";
                dusk = "2013-03-05 16:19:36 +0000";
                goldenHour = "2013-03-05 15:02:52 +0000";
                goldenHourEnd = "2013-03-05 05:19:01 +0000";
                nadir = "2013-03-04 22:10:57 +0000";
                nauticalDawn = "2013-03-05 03:24:31 +0000";
                nauticalDusk = "2013-03-05 16:57:22 +0000";
                night = "2013-03-05 17:35:36 +0000";
                nightEnd = "2013-03-05 02:46:17 +0000";
                solarNoon = "2013-03-05 10:10:57 +0000";
                sunrise = "2013-03-05 04:34:56 +0000";
                sunriseEnd = "2013-03-05 04:38:19 +0000";
                sunset = "2013-03-05 15:46:57 +0000";
                sunsetStart = "2013-03-05 15:43:34 +0000";
        }
*/

        self.dawn = Date()
        self.dusk = Date()
        self.goldenHour = Date()
        self.goldenHourEnd = Date()
        self.nadir = Date()
        self.nauticalDawn = Date()
        self.nauticalDusk = Date()
        self.night = Date()
        self.nightEnd = Date()
        self.solarNoon = Date()
        self.sunrise = Date()
        self.sunriseEnd = Date()
        self.sunset = Date()
        self.sunsetStart = Date()
    }

    var daylightLengthProgress: Double {
        return 0
        /*
        let timeSinceSunrise = self.date.timeIntervalSince(self.sunrise)
        if self.date.isBetween(self.sunrise, and: self.sunset) {
            let totalDaylightDuration = self.sunset.timeIntervalSince(self.sunrise)
            return timeSinceSunrise / totalDaylightDuration
        } else if timeSinceSunrise > 0 {
            return 1
        } else {
            return 0
        }
        */
    }

    var sunPhase: SunPhase {
        return .sunrise
        /*
        var calendar = Calendar.current
        calendar.timeZone = self.timeZone
        let startOfTheDay = calendar.startOfDay(for: self.date)

        if self.date.isBetween(startOfTheDay, and: self.astronomicalTwilightStart) {
            return .twilight
        } else if date.isBetween(self.astronomicalTwilightStart, and: self.nauticalTwilightStart) {
            return .twilight
        } else if date.isBetween(self.nauticalTwilightStart, and: self.civilTwilightStart) {
            return .twilight
        } else if date.isBetween(self.civilTwilightStart, and: self.sunrise) {
            return .twilight
        } else if date.isBetween(self.sunrise, and: self.sunset) {
            return .sunrise
        } else if date.isBetween(self.sunset, and: self.civilTwilightEnd) {
            return .sunset
        } else if date.isBetween(self.civilTwilightEnd, and: self.nauticalTwilightEnd) {
            return .twilight
        } else if date.isBetween(self.nauticalTwilightEnd, and: self.astronomicalTwilightEnd) {
            return .twilight
        } else {
            return .night
        }*/
    }
}
