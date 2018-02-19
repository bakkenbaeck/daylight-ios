import CoreLocation
import UIKit
import SweetSwift

class DateHasher {
    private var hashingDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        // Use a manually created date format.
        // Ensures strings are the same regardless of user locale.
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        return formatter
    }()

    private static let shared = DateHasher()

    static func hashValue(for date: Date) -> UInt32 {
        let dateString = self.shared.hashingDateFormatter.string(from: date)

        // We use an FNV hash of the date string, to ensure that each day has it's own message, instead of randomising.
        let value = FNVHash.fnv1a_32(string: dateString)

        return value
    }
}

/// The messages we display on Today view, main view and notifications.
/// We show a different Today and Main view message depending on time of day. One during daylight times, one during the night.
struct Message {
    // Message list https://github.com/bakkenbaeck/daylight-ios/wiki/Messages
    // Please keep them up to date
    enum TimeDiferential {
        case longerMoreThanAMinute
        case longerLessThanAMinute

        case shorterMoreThanAMinute
        case shorterLessThanAMinute
    }

    private let summerSolsticeMessages = [
        "Happy summer solstice! Get yourself a healthy summer glow.",
        "Happy first day of summer: make the most out of it!"
    ]

    private let winterSolsticeMessages = [
        "Happy winter solstice! The light begins its journey back to full brightness from now on.",
        "Have a magical winter solstice! The light will soon brighten up your days again."
    ]

    private let weeklySummaryMoreSunlightMessages = [
        "The Winter Solstice becomes a distant memory, as we gained **%@** of extra sunlight this past week!",
        "We saw **%@** of daylight during the past week, inching us further away from the dark days of winter!",
        "Daylight time increased by **%@** the past few days. It’s allowed to start daydreaming about the long and toasty days of summer!"
    ]

//    private let weeklySummaryLessSunlightMessages = [
//        "OK, daylight is dwindling. Make sure to bundle up, the sun is out there for **%@** during the coming week!",
//        "Yes, the sun drops and drops. It’s time to leave the Misery Olympics and enjoy all of the **%@** of daylight the coming days!",
//        "The chill of autumn is in the air. Make sure to get a window seat and start soaking up the **%@** of daylight during the coming week!",
//        "Noticed how the light is thicker, almost gold, this time of year? Make sure to admire it closely during the **%@** of daylight this week!"
//    ]

    private let messages: [SunTime.DayOrNight: [TimeDiferential: [String]]] = [
        .day: [
            .longerMoreThanAMinute: [
                "Today is **%@** longer than yesterday. Happy days!",
                "The sun is out for **%@** more today. Enjoy!",
                "**%@** extra sunshine today. Make them count!",
                "Make sure to soak up that vitamin D. **%@** more daylight today!",
                "Smile! Today has **%@** more daylight than yesterday!",
                "**%@** more daylight today. Just let it sink in…",
                "Today is **%@** longer. It’s getting better and better! 🌞",
                "Bring out your shorts, because today has **%@** more sunlight.",
                "Have a great day and enjoy those **%@** extra daylight.",
                "After darkness comes daylight. **%@** more to be precise!"
            ],
            .longerLessThanAMinute: [
                "Little less than a minute of extra sunlight today. It’s getting better!",
                "We’ve reached the tipping point: we’ll have more sunlight every day now!",
                "About a minute of extra light. You’ll start noticing the difference soon!",
                "There’s about a minute of extra light at the end of this tunnel.",
                "We’ll have about a minute of extra light today. It’s upwards from here."
            ],
            .shorterMoreThanAMinute: [
                "The sun will be out **%@** less today. Keep your head up!",
                "**%@** less sunlight today, unfortunately. It’ll get better!",
                "Sadly, the day will be **%@** shorter. Make the most out of it!",
                "Today will be %@  shorter than yesterday. Bundle up and absorb some precious sun rays during your lunch break! ☀️"
            ],
            .shorterLessThanAMinute: [
                "OK, daylight is dwindling. It's time to leave the Misery Olympics and enjoy every minute of daylight you can get today!",
                "The chill of autumn is in the air. Make sure to get a window seat and start soaking up some daylight today!",
                "Noticed how the light is thicker, almost gold, this time of year? Make sure to admire it closely today!",
                "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
                "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
                "Today is shorter than yesterday. But fear not, brighter times ahead!"
            ]
        ],
        .night: [
            .longerMoreThanAMinute: [
                "Get a good night’s sleep: tomorrow there’ll be **%@** more sunlight.",
                "Lights out. Enjoy **%@** more sunlight tomorrow!",
                "Bring out those pyjamas. **%@** more light awaits tomorrow.",
                "The sun has set for today. Embrace those **%@** of extra daylight tomorrow.",
                "The sun has set. Soak up the extra vitamin D tomorrow!"
            ],
            .longerLessThanAMinute: [
                "Get a good night’s sleep: tomorrow there’ll be more sunlight for you.",
                "Bring out those pyjamas. More daylight awaits tomorrow!",
                "The sun has set. Soak up the extra vitamin D tomorrow!"
            ],
            .shorterMoreThanAMinute: [
                "Unfortunately, tomorrow will be **%@** shorter than today. Make the most out of it!",
                "Sadly, tomorrow will be **%@** shorter than today. Enjoy it while it lasts!",
                "Tomorrow will be **%@** shorter than today. But fear not, brighter times ahead!"
            ],
            .shorterLessThanAMinute: [
                "Unfortunately, tomorrow will be a little bit shorter than today. Make the most out of it!",
                "Sadly, tomorrow will be a tiny bit shorter than today. Enjoy it while it lasts!",
                "Tomorrow will be shorter than today. But fear not, brighter times ahead!"
            ]
        ]
    ]

    static let informationMessage = Message(format: "Daylight is an experiment inspired by the dark and long winters of the north. Made by **Bakken & Bæck**.")

    private(set) var preformattedMessage: String = ""

    var formattedMessage: String {
        let format = NSLocalizedString("number_of_minutes", comment: "")
        let minuteString = String.localizedStringWithFormat(format, self.minutesRounded)
        let formattedMessage = String(format: self.preformattedMessage, minuteString)

        return formattedMessage.replacingOccurrences(of: "**", with: "")
    }

    private var daylightLengthDifference: Double = 0

    private var minutesRounded: Int {
        return max(abs(Int(Darwin.ceil(self.daylightLengthDifference / 60.0))), 1)
    }

    var coloredPart: String {
        let regex = try! NSRegularExpression(pattern: "\\*\\*([^\"]*)\\*\\*")
        let nsString = self.preformattedMessage as NSString
        let results = regex.matches(in: self.preformattedMessage, range: NSRange(location: 0, length: nsString.length))
        if let firstResultRange = results.first?.range {
            let foundPart = nsString.substring(with: firstResultRange)

            return foundPart.replacingOccurrences(of: "**", with: "")
        } else {
            return ""
        }
    }

    static func notificationMessage(for date: Date, coordinates: CLLocationCoordinate2D, weeklySummary: Bool = false) -> String {
        var weeklySummary = weeklySummary
        if date.components([.weekday]).weekday == 1 {
            weeklySummary = true
        }

        return self.init(for: date, coordinates: coordinates, weeklySummary: weeklySummary).formattedMessage
    }

    init(for date: Date, coordinates: CLLocationCoordinate2D, weeklySummary: Bool = false) {
        self.init(for: date, latitude: coordinates.latitude, longitude: coordinates.longitude, weeklySummary: weeklySummary)
    }

    init(for date: Date, latitude: CLLocationDegrees, longitude: CLLocationDegrees, weeklySummary: Bool = false) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let sunTimes = SunTime(date: date, coordinate: coordinate)

        let sinceDate: Date? = weeklySummary ? Calendar.autoupdatingCurrent.date(byAdding: .day, value: -7, to: date)! : nil
        self.daylightLengthDifference = sunTimes.daylightLenghtDifference(from: sinceDate ?? date.dayBefore, to: date)

        let hemisphere = Location.Hemisphere(latitude: latitude)

        guard let messagesForCycle = self.messages[sunTimes.dayNightCycle] else { fatalError("Could not recover messages for day/night cycle.") }
        let possibleMessages: [String]

        if weeklySummary, self.daylightLengthDifference > 0 {
                possibleMessages = self.weeklySummaryMoreSunlightMessages
        } else if date.isSolstice {
            if date.isJuneSolstice {
                switch hemisphere {
                case .southern:
                    possibleMessages = self.winterSolsticeMessages
                case .northern:
                    possibleMessages = self.summerSolsticeMessages
                }
            } else {
                switch hemisphere {
                case .southern:
                    possibleMessages = self.summerSolsticeMessages
                case .northern:
                    possibleMessages = self.winterSolsticeMessages
                }
            }
        } else {
            // positive values mean days are getting longer
            if self.daylightLengthDifference == abs(self.daylightLengthDifference) {
                if self.daylightLengthDifference >= 1.minute {
                    possibleMessages = messagesForCycle[.longerMoreThanAMinute]!
                } else {
                    possibleMessages = messagesForCycle[.longerLessThanAMinute]!
                }
            } else {
                if abs(self.daylightLengthDifference) >= 1.minute {
                    possibleMessages = messagesForCycle[.shorterMoreThanAMinute]!
                } else {
                    possibleMessages = messagesForCycle[.shorterLessThanAMinute]!
                }
            }
        }

        let hashValue = DateHasher.hashValue(for: date)
        let index = Int(hashValue % UInt32(possibleMessages.count))

        self.preformattedMessage = possibleMessages[index]
    }

    init(format: String) {
        self.preformattedMessage = format
    }

    func attributedString(textColor: UIColor, highlightColor: UIColor) -> NSAttributedString {
        return self.formattedMessage.attributedMessageString(textColor: textColor, highlightColor: highlightColor, highlightedSubstring: self.coloredPart)
    }
}
