struct Message {
    enum Kind: Int {
        case longerMoreThanAMinute
        case longerLessThanAMinute

        case shorterMoreThanAMinute
        case shorterLessThanAMinute

        case longerTomorrowMoreThanAMinute
        case longerTomorrowLessThanAMinute

        case shorterTomorrowMoreThanAMinute
        case shorterTomorrowLessThanAMinute

        init(sunPhase: SunPhase, yesterdayDaylightLength: Double, todayDaylightLength: Double, tomorrowDaylightLength: Double) {
            var kindRawValue = 0

            if sunPhase == .night {
                let tomorrowIsLonger = tomorrowDaylightLength - todayDaylightLength > 0
                if tomorrowIsLonger {
                    let longerTomorrowMoreThanAMinute = tomorrowDaylightLength - todayDaylightLength > 60

                    kindRawValue =  longerTomorrowMoreThanAMinute ? Message.Kind.longerTomorrowMoreThanAMinute.rawValue : Message.Kind.longerTomorrowLessThanAMinute.rawValue
                } else {
                    let shorterTomorrowMoreThanAMinute = todayDaylightLength - tomorrowDaylightLength > 60

                    kindRawValue = shorterTomorrowMoreThanAMinute ? Message.Kind.shorterTomorrowMoreThanAMinute.rawValue : Message.Kind.shorterTomorrowLessThanAMinute.rawValue
                }
            } else {
                let todayIsLonger = todayDaylightLength - yesterdayDaylightLength > 0
                if todayIsLonger {
                    let longerMoreThanAMinute = todayDaylightLength - yesterdayDaylightLength > 60

                    kindRawValue = longerMoreThanAMinute ? Message.Kind.longerMoreThanAMinute.rawValue : Message.Kind.longerLessThanAMinute.rawValue
                } else {
                    let shorterMoreThanAMinute = yesterdayDaylightLength - todayDaylightLength > 60

                    kindRawValue = shorterMoreThanAMinute ? Message.Kind.shorterMoreThanAMinute.rawValue : Message.Kind.shorterLessThanAMinute.rawValue
                }
            }

            self.init(rawValue: kindRawValue)!
        }
    }

    let content: String
    let coloredPart: String
}
