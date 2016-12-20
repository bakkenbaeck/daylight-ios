import Foundation

struct MessageGenerator {
    let informationMessage = "Daylight is an experiment inspired by the dark and long winters of the north. Made by Bakken & Bæck."
    let coloredInformation = "Bakken & Bæck"

    let longerDayMessage1 = "Today is %@ minutes longer than yesterday. Happy days!"
    let longerDayColored1 = "%@ minutes"
    let longerDayMessage2 = "The sun is out for %@ more minutes today. Enjoy!"
    let longerDayColored2 = "%@ more minutes"
    let longerDayMessage3 = "%@ extra minutes of sunshine today. Make them count!"
    let longerDayColored3 = "%@ extra minutes"
    let longerDayMessage4 = "Make sure to soak up that vitamin D. %@ more minutes of daylight today!"
    let longerDayColored4 = "%@ more minutes"
    let longerDayMessage5 = "Smile! Today has %@ more minutes of daylight than yesterday!"
    let longerDayColored5 = "%@ more minutes"
    let longerDayMessage6 = "%@ more minutes of daylight today. Just let it sink in…"
    let longerDayColored6 = "%@ more minutes"
    let longerDayMessage7 = "Today is %@ minutes longer. It’s getting better and better!"
    let longerDayColored7 = "%@ minutes"
    let longerDayMessage8 = "Bring out your shorts, because today has %@ more minutes of sunlight."
    let longerDayColored8 = "%@ more minutes"
    let longerDayMessage9 = "Have a great day and enjoy those %@ extra minutes of daylight."
    let longerDayColored9 = "%@ extra minutes"
    let longerDayMessage10 = "After darkness comes daylight. %@ more minutes to be precise!"
    let longerDayColored10 = "%@ more minutes"

    func longerDayMessage() -> (text: String, colored: String) {
        let number = arc4random_uniform(10)
        switch number {
        case 0: return (self.longerDayMessage1, self.longerDayColored1)
        case 1: return (self.longerDayMessage2, self.longerDayColored2)
        case 2: return (self.longerDayMessage3, self.longerDayColored3)
        case 3: return (self.longerDayMessage4, self.longerDayColored4)
        case 4: return (self.longerDayMessage5, self.longerDayColored5)
        case 5: return (self.longerDayMessage6, self.longerDayColored6)
        case 6: return (self.longerDayMessage7, self.longerDayColored7)
        case 7: return (self.longerDayMessage8, self.longerDayColored8)
        case 8: return (self.longerDayMessage9, self.longerDayColored9)
        case 9: return (self.longerDayMessage10, self.longerDayColored10)
        default: return ("", "")
        }
    }

    let noChangeMessage1 = "Little less than a minute of extra sunlight today. It’s getting better!"
    let noChangeColored1 = "a minute"
    let noChangeMessage2 = "We’ve reached the tipping point: we’ll have more sunlight every day now!"
    let noChangeColored2 = "more sunlight"
    let noChangeMessage3 = "About a minute of extra light. You’ll start noticing the difference soon!"
    let noChangeColored3 = "About a minute"
    let noChangeMessage4 = "There’s about a minute of extra light at the end of this tunnel."
    let noChangeColored4 = "about a minute"
    let noChangeMessage5 = "We’ll have about a minute of extra light today. It’s upwards from here."
    let noChangeColored5 = "about a minute"

    // TODO: extract number to make it more testable
    func noChangeMessage() -> (text: String, colored: String) {
        let number = arc4random_uniform(5)
        switch number {
        case 0: return (self.noChangeMessage1, self.noChangeColored1)
        case 1: return (self.noChangeMessage2, self.noChangeColored2)
        case 2: return (self.noChangeMessage3, self.noChangeColored3)
        case 3: return (self.noChangeMessage4, self.noChangeColored4)
        case 4: return (self.noChangeMessage5, self.noChangeColored5)
        default: return ("", "")
        }
    }

    let shorterMessage1 = "The sun will be out %@ minutes less today. Keep your head up!"
    let shorterColored1 = "%@ minutes less"
    let shorterMessage2 = "%@ minutes less sunlight today, unfortunately. It’ll get better!"
    let shorterColored2 = "%@ minutes less"
    let shorterMessage3 = "Sadly, the day will be %@ minutes shorter. Make the most out of it!"
    let shorterColored3 = "%@ minutes shorter"

    func shorterMessage() -> (text: String, colored: String) {
        let number = arc4random_uniform(3)
        switch number {
        case 0: return (self.shorterMessage1, self.shorterColored1)
        case 1: return (self.shorterMessage2, self.shorterColored2)
        case 2: return (self.shorterMessage3, self.shorterColored3)
        default: return ("", "")
        }
    }

    let nightMessage1 = "Get a good night’s sleep: tomorrow there’ll be %@ more minutes of sunlight."
    let nightColored1 = "%@ more minutes"
    let nightMessage2 = "Lights out. Enjoy %@ more minutes of sunlight tomorrow!"
    let nightColored2 = "%@ more minutes"
    let nightMessage3 = "Bring out those pyjamas. %@ more minutes of light await tomorrow."
    let nightColored3 = "%@ more minutes"
    let nightMessage4 = "The sun has set for today. Embrace those %@ minutes of extra daylight tomorrow."
    let nightColored4 = "%@ minutes"
    let nightMessage5 = "The sun has set. Soak up the extra vitamin D tomorrow!"
    let nightColored5 = ""

    func nightMessage() -> (text: String, colored: String) {
        let number = arc4random_uniform(5)
        switch number {
        case 0: return (self.nightMessage1, self.nightColored1)
        case 1: return (self.nightMessage2, self.nightColored2)
        case 2: return (self.nightMessage3, self.nightColored3)
        case 3: return (self.nightMessage4, self.nightColored4)
        case 4: return (self.nightMessage5, self.nightColored5)
        default: return ("", "")
        }
    }

    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long

        return formatter
    }()

    func message(forDay day: Date, withInterval interval: Double) -> (text: String, colored: String) {
        let defaults = UserDefaults.standard

        let dayKey = self.dateFormatter.string(from: day)

        if let message = UserDefaults.standard.string(forKey: dayKey), let colored = UserDefaults.standard.string(forKey: "\(dayKey)colored") {
            return (message, colored)
        } else {
            if let appDomain = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: appDomain)
            }

            let message = self.generateMessage(forInterval: interval)
            defaults.set(message.text, forKey: dayKey)
            defaults.set(message.colored, forKey: "\(dayKey)colored")
            return (message.text, message.colored)
        }
    }

    func messageForNotification(withInterval interval: Double) -> String {
        let message = self.generateMessage(forInterval: interval)

        return message.text
    }

    private func generateMessage(forInterval interval: Double) -> (text: String, colored: String) {
        if interval > 1 {
            return longerDayMessage()
        } else if interval >= 0 {
            return noChangeMessage()
        } else {
            return shorterMessage()
        }
    }

    func minuteString(for interval: Double) -> String {
        let minutes = interval / 60

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        let minutesString = formatter.string(from: NSNumber(value: abs(minutes)))!

        return minutesString
    }
}
