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

    static func kind(isNight: Bool, yesterdayDayLenght: Double, todayDayLenght: Double, tomorrowDayLenght: Double) -> Kind {
        if isNight {
            let tomorrowIsLonger = tomorrowDayLenght - todayDayLenght > 0
            if tomorrowIsLonger {
                let longerTomorrowMoreThanAMinute = tomorrowDayLenght - todayDayLenght > 60

                return longerTomorrowMoreThanAMinute ? .longerTomorrowMoreThanAMinute : .longerTomorrowLessThanAMinute
            } else {
                let shorterTomorrowMoreThanAMinute = todayDayLenght - tomorrowDayLenght > 60

                return shorterTomorrowMoreThanAMinute ? .shorterTomorrowMoreThanAMinute : .shorterTomorrowLessThanAMinute
            }
        } else {
            let todayIsLonger = todayDayLenght - yesterdayDayLenght > 0
            if todayIsLonger {
                let longerMoreThanAMinute = todayDayLenght - yesterdayDayLenght > 60

                return longerMoreThanAMinute ? .longerMoreThanAMinute : .longerLessThanAMinute
            } else {
                let shorterMoreThanAMinute = yesterdayDayLenght - todayDayLenght > 60

                return shorterMoreThanAMinute ? .shorterMoreThanAMinute : .shorterLessThanAMinute
            }
        }
    }
}
