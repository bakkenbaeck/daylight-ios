import Sunrise

extension SunriseSet {
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
}
