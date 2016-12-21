import Foundation

struct MessageGenerator {
    let informationMessage = Message(content: "Daylight is an experiment inspired by the dark and long winters of the north. Made by Bakken & Bæck.", coloredPart: "Bakken & Bæck")

    var longerMoreThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(content: "Today is %@ minutes longer than yesterday. Happy days!", coloredPart: "%@ minutes"))
        messages.append(Message(content: "The sun is out for %@ more minutes today. Enjoy!", coloredPart: "%@ more minutes"))
        messages.append(Message(content: "%@ extra minutes of sunshine today. Make them count!", coloredPart: "%@ extra minutes"))
        messages.append(Message(content: "Make sure to soak up that vitamin D. %@ more minutes of daylight today!", coloredPart: "%@ more minutes"))
        messages.append(Message(content: "Smile! Today has %@ more minutes of daylight than yesterday!", coloredPart: "%@ more minutes"))
        messages.append(Message(content: "%@ more minutes of daylight today. Just let it sink in…", coloredPart: "%@ more minutes"))
        messages.append(Message(content: "Today is %@ minutes longer. It’s getting better and better!", coloredPart: "%@ minutes"))
        messages.append(Message(content: "Bring out your shorts, because today has %@ more minutes of sunlight.", coloredPart: "%@ more minutes"))
        messages.append(Message(content: "Have a great day and enjoy those %@ extra minutes of daylight.", coloredPart: "%@ extra minutes"))
        messages.append(Message(content: "After darkness comes daylight. %@ more minutes to be precise!", coloredPart: "%@ more minutes"))

        return messages
    }

    func longerMoreThanAMinuteMessage() -> Message {
        let index = Int(arc4random_uniform(UInt32(self.longerMoreThanAMinuteMessages.count)))

        return self.longerMoreThanAMinuteMessages[index]
    }

    var longerLessThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(content: "Little less than a minute of extra sunlight today. It’s getting better!", coloredPart: "a minute"))
        messages.append(Message(content: "We’ve reached the tipping point: we’ll have more sunlight every day now!", coloredPart: "more sunlight"))
        messages.append(Message(content: "About a minute of extra light. You’ll start noticing the difference soon!", coloredPart: "About a minute"))
        messages.append(Message(content: "There’s about a minute of extra light at the end of this tunnel.", coloredPart: "about a minute"))
        messages.append(Message(content: "We’ll have about a minute of extra light today. It’s upwards from here.", coloredPart: "about a minute"))

        return messages
    }

    func longerLessThanAMinuteMessage() -> Message {
        let index = Int(arc4random_uniform(UInt32(self.longerLessThanAMinuteMessages.count)))

        return self.longerLessThanAMinuteMessages[index]
    }

    var shorterMoreThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(content: "The sun will be out %@ minutes less today. Keep your head up!", coloredPart: "%@ minutes less"))
        messages.append(Message(content: "%@ minutes less sunlight today, unfortunately. It’ll get better!", coloredPart: "%@ minutes less"))
        messages.append(Message(content: "Sadly, the day will be %@ minutes shorter. Make the most out of it!", coloredPart: "%@ minutes shorter"))

        return messages
    }

    func shorterMoreThanAMinuteMessage() -> Message {
        let index = Int(arc4random_uniform(UInt32(self.shorterMoreThanAMinuteMessages.count)))

        return self.shorterMoreThanAMinuteMessages[index]
    }

    var longerTomorrowLessThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(content: "Get a good night’s sleep: tomorrow there’ll be more sunlight for you.", coloredPart: ""))
        messages.append(Message(content: "Bring out those pyjamas. More daylight awaits tomorrow!", coloredPart: ""))
        messages.append(Message(content: "The sun has set. Soak up the extra vitamin D tomorrow!", coloredPart: ""))

        return messages
    }

    func longerTomorrowLessThanAMinuteMessage() -> Message {
        let index = Int(arc4random_uniform(UInt32(self.longerTomorrowLessThanAMinuteMessages.count)))

        return self.longerTomorrowLessThanAMinuteMessages[index]
    }

    var longerTomorrowMoreThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(content: "Get a good night’s sleep: tomorrow there’ll be %@ more minutes of sunlight.", coloredPart: "%@ more minutes"))
        messages.append(Message(content: "Lights out. Enjoy %@ more minutes of sunlight tomorrow!", coloredPart: "%@ more minutes"))
        messages.append(Message(content: "Bring out those pyjamas. %@ more minutes of light await tomorrow.", coloredPart: "%@ more minutes"))
        messages.append(Message(content: "The sun has set for today. Embrace those %@ minutes of extra daylight tomorrow.", coloredPart: "%@ minutes"))
        messages.append(Message(content: "The sun has set. Soak up the extra vitamin D tomorrow!", coloredPart: ""))

        return messages
    }

    func longerTomorrowMoreThanAMinuteMessage() -> Message {
        let index = Int(arc4random_uniform(UInt32(self.longerTomorrowMoreThanAMinuteMessages.count)))

        return self.longerTomorrowMoreThanAMinuteMessages[index]
    }

    var shorterLessThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(content: "Unfortunately, the day is a little bit shorter today. Make the most out of it!", coloredPart: ""))
        messages.append(Message(content: "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!", coloredPart: ""))
        messages.append(Message(content: "Today is shorter than yesterday. But fear not, brighter times ahead!", coloredPart: ""))

        return messages
    }

    func shorterLessThanAMinuteMessage() -> Message {
        let index = Int(arc4random_uniform(UInt32(self.shorterLessThanAMinuteMessages.count)))

        return self.shorterLessThanAMinuteMessages[index]
    }

    var shorterTomorrowMoreThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(content: "Unfortunately, tomorrow will be %@ minutes shorter than today. Make the most out of it!", coloredPart: "%@ minutes"))
        messages.append(Message(content: "Sadly, tomorrow will be %@ minutes shorter than today. Enjoy it while it lasts!", coloredPart: "%@ minutes"))
        messages.append(Message(content: "Tomorrow will be %@ minutes shorter than today. But fear not, brighter times ahead!", coloredPart: "%@ minutes"))

        return messages
    }

    func shorterTomorrowMoreThanAMinuteMessage() -> Message {
        let index = Int(arc4random_uniform(UInt32(self.shorterTomorrowMoreThanAMinuteMessages.count)))

        return self.shorterTomorrowMoreThanAMinuteMessages[index]
    }

    var shorterTomorrowLessThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(content: "Unfortunately, tomorrow will be a little bit shorter than today. Make the most out of it!", coloredPart: ""))
        messages.append(Message(content: "Sadly, tomorrow will be a tiny bit shorter than today. Enjoy it while it lasts!", coloredPart: ""))
        messages.append(Message(content: "Tomorrow will be shorter than today. But fear not, brighter times ahead!", coloredPart: ""))

        return messages
    }

    func shorterTomorrowLessThanAMinuteMessage() -> Message {
        let index = Int(arc4random_uniform(UInt32(self.shorterTomorrowLessThanAMinuteMessages.count)))

        return self.shorterTomorrowLessThanAMinuteMessages[index]
    }

    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long

        return formatter
    }()

    func message(forDay day: Date, isNight: Bool, yesterdayDaylightLength: Double, todayDaylightLength: Double, tomorrowDaylightLength: Double) -> Message {
        let defaults = UserDefaults.standard

        let dayKey = self.dateFormatter.string(from: day)

        if let message = UserDefaults.standard.string(forKey: dayKey), let colored = UserDefaults.standard.string(forKey: "\(dayKey)colored") {
            return Message(content: message, coloredPart: colored)
        } else {
            if let appDomain = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: appDomain)
            }

            let message = self.generateMessage(isNight: isNight, yesterdayDaylightLength: yesterdayDaylightLength, todayDaylightLength: todayDaylightLength, tomorrowDaylightLength: tomorrowDaylightLength)
            defaults.set(message.content, forKey: dayKey)
            defaults.set(message.coloredPart, forKey: "\(dayKey)colored")

            return message
        }
    }

    func messageForNotification(isNight: Bool, yesterdayDaylightLength: Double, todayDaylightLength: Double, tomorrowDaylightLength: Double) -> String {
        let message = self.generateMessage(isNight: isNight, yesterdayDaylightLength: yesterdayDaylightLength, todayDaylightLength: todayDaylightLength, tomorrowDaylightLength: tomorrowDaylightLength)

        return message.content
    }

    private func generateMessage(isNight: Bool, yesterdayDaylightLength: Double, todayDaylightLength: Double, tomorrowDaylightLength: Double) -> Message {
        let messageKind = Message.kind(isNight: isNight, yesterdayDaylightLength: yesterdayDaylightLength, todayDaylightLength: todayDaylightLength, tomorrowDaylightLength: tomorrowDaylightLength)
        switch messageKind {
        case .longerMoreThanAMinute:
            return longerMoreThanAMinuteMessage()
        case .longerLessThanAMinute:
            return longerLessThanAMinuteMessage()
        case .shorterMoreThanAMinute:
            return shorterMoreThanAMinuteMessage()
        case .shorterLessThanAMinute:
            return self.shorterLessThanAMinuteMessage()
        case .longerTomorrowMoreThanAMinute:
            return self.longerTomorrowMoreThanAMinuteMessage()
        case .longerTomorrowLessThanAMinute:
            return self.longerTomorrowLessThanAMinuteMessage()
        case .shorterTomorrowMoreThanAMinute:
            return self.shorterTomorrowMoreThanAMinuteMessage()
        case .shorterTomorrowLessThanAMinute:
            return self.shorterTomorrowLessThanAMinuteMessage()
        }
    }

    func minuteString(for interval: Double) -> String {
        let minutes = interval / 60

        return "\(abs(minutes))"
    }
}
