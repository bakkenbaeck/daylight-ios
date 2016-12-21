struct Message {
    enum Kind {
        case longerMoreThanAMinute
        case longerLessThanAMinute

        case shorterMoreThanAMinute
        case shorterLessThanAMinute

        case longerTomorrowMoreThanAMinute
        case longerTomorrowLessThanAMinute

        case shorterTomorrowMoreThanAMinute
        case shorterTomorrowLessThanAMinute
    }

    let content: String
    let coloredPart: String

    static func kind(isNight: Bool, yesterdayDaylightLength: Double, todayDaylightLength: Double, tomorrowDaylightLength: Double) -> Kind {
        if isNight {
            let tomorrowIsLonger = tomorrowDaylightLength - todayDaylightLength > 0
            if tomorrowIsLonger {
                let longerTomorrowMoreThanAMinute = tomorrowDaylightLength - todayDaylightLength > 60

                return longerTomorrowMoreThanAMinute ? .longerTomorrowMoreThanAMinute : .longerTomorrowLessThanAMinute
            } else {
                let shorterTomorrowMoreThanAMinute = todayDaylightLength - tomorrowDaylightLength > 60

                return shorterTomorrowMoreThanAMinute ? .shorterTomorrowMoreThanAMinute : .shorterTomorrowLessThanAMinute
            }
        } else {
            let todayIsLonger = todayDaylightLength - yesterdayDaylightLength > 0
            if todayIsLonger {
                let longerMoreThanAMinute = todayDaylightLength - yesterdayDaylightLength > 60

                return longerMoreThanAMinute ? .longerMoreThanAMinute : .longerLessThanAMinute
            } else {
                let shorterMoreThanAMinute = yesterdayDaylightLength - todayDaylightLength > 60

                return shorterMoreThanAMinute ? .shorterMoreThanAMinute : .shorterLessThanAMinute
            }
        }
    }
}
