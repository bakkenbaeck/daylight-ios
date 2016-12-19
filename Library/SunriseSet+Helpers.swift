import Suntimes

extension Suntimes {
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
        let startOfTheDay = calendar.startOfDay(for: date)

        if self.date.isBetween(startOfTheDay, and: self.astronomicalTwilightStart) {
            return .night
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
        }
    }
}
