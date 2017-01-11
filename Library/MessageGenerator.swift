import Foundation

struct MessageGenerator {
    let informationMessage = Message(format: "Daylight is an experiment inspired by the dark and long winters of the north. Made by **Bakken & Bæck**.")

    func message(forDay day: Date, sunPhase: SunPhase, yesterdayDaylightLength: Double, todayDaylightLength: Double, tomorrowDaylightLength: Double) -> Message {
        let defaults = UserDefaults.standard

        let cachingKey = self.cachingKey(forDay: day, andSunPhase: sunPhase)

        if let format = UserDefaults.standard.string(forKey: cachingKey) {
            return Message(format: format)
        } else {
            if let appDomain = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: appDomain)
            }

            let message = self.generateMessage(sunPhase: sunPhase, yesterdayDaylightLength: yesterdayDaylightLength, todayDaylightLength: todayDaylightLength, tomorrowDaylightLength: tomorrowDaylightLength)
            defaults.set(message.format, forKey: cachingKey)

            return message
        }
    }

    func messageForNotification(sunPhase: SunPhase, yesterdayDaylightLength: Double, todayDaylightLength: Double, tomorrowDaylightLength: Double) -> String {
        let message = self.generateMessage(sunPhase: sunPhase, yesterdayDaylightLength: yesterdayDaylightLength, todayDaylightLength: todayDaylightLength, tomorrowDaylightLength: tomorrowDaylightLength)

        return message.content
    }

    func hashValue(forDay day: Date) -> UInt32 {
        let dayKey = self.dateFormatter.string(from: day)

        let value = FNVHash.fnv1a_32(string: dayKey)

        return value
    }


    private var longerMoreThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(format: "Today is **%@ minutes** longer than yesterday. Happy days!"))
        messages.append(Message(format: "The sun is out for **%@ more minutes** today. Enjoy!"))
        messages.append(Message(format: "**%@ extra minutes** of sunshine today. Make them count!"))
        messages.append(Message(format: "Make sure to soak up that vitamin D. **%@ more minutes** of daylight today!"))
        messages.append(Message(format: "Smile! Today has **%@ more minutes** of daylight than yesterday!"))
        messages.append(Message(format: "**%@ more minutes** of daylight today. Just let it sink in…"))
        messages.append(Message(format: "Today is **%@ minutes** longer. It’s getting better and better!"))
        messages.append(Message(format: "Bring out your shorts, because today has **%@ more minutes** of sunlight."))
        messages.append(Message(format: "Have a great day and enjoy those **%@ extra minutes** of daylight."))
        messages.append(Message(format: "After darkness comes daylight. **%@ more minutes** to be precise!"))

        return messages
    }

    private func longerMoreThanAMinuteMessage(for hashValue: UInt32) -> Message {
        let index = Int(hashValue % UInt32(self.longerMoreThanAMinuteMessages.count))

        return self.longerMoreThanAMinuteMessages[index]
    }

    private var longerLessThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(format: "Little less than **a minute** of extra sunlight today. It’s getting better!"))
        messages.append(Message(format: "We’ve reached the tipping point: we’ll have **more sunlight** every day now!"))
        messages.append(Message(format: "**About a minute** of extra light. You’ll start noticing the difference soon!"))
        messages.append(Message(format: "There’s **about a minute** of extra light at the end of this tunnel."))
        messages.append(Message(format: "We’ll have **about a minute** of extra light today. It’s upwards from here."))

        return messages
    }

    private func longerLessThanAMinuteMessage(for hashValue: UInt32) -> Message {
        let index = Int(hashValue % UInt32(self.longerLessThanAMinuteMessages.count))

        return self.longerLessThanAMinuteMessages[index]
    }

    private var shorterMoreThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(format: "The sun will be out **%@ minutes less** today. Keep your head up!"))
        messages.append(Message(format: "**%@ minutes less** sunlight today, unfortunately. It’ll get better!"))
        messages.append(Message(format: "Sadly, the day will be **%@ minutes shorter**. Make the most out of it!"))

        return messages
    }

    private func shorterMoreThanAMinuteMessage(for hashValue: UInt32) -> Message {
        let index = Int(hashValue % UInt32(self.shorterMoreThanAMinuteMessages.count))

        return self.shorterMoreThanAMinuteMessages[index]
    }

    private var longerTomorrowLessThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(format: "Get a good night’s sleep: tomorrow there’ll be more sunlight for you."))
        messages.append(Message(format: "Bring out those pyjamas. More daylight awaits tomorrow!"))
        messages.append(Message(format: "The sun has set. Soak up the extra vitamin D tomorrow!"))

        return messages
    }

    private func longerTomorrowLessThanAMinuteMessage(for hashValue: UInt32) -> Message {
        let index = Int(hashValue % UInt32(self.longerLessThanAMinuteMessages.count))

        return self.longerTomorrowLessThanAMinuteMessages[index]
    }

    private var longerTomorrowMoreThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(format: "Get a good night’s sleep: tomorrow there’ll be **%@ more minutes** of sunlight."))
        messages.append(Message(format: "Lights out. Enjoy **%@ more minutes** of sunlight tomorrow!"))
        messages.append(Message(format: "Bring out those pyjamas. **%@ more minutes** of light await tomorrow."))
        messages.append(Message(format: "The sun has set for today. Embrace those **%@ minutes** of extra daylight tomorrow."))
        messages.append(Message(format: "The sun has set. Soak up the extra vitamin D tomorrow!"))

        return messages
    }

    private func longerTomorrowMoreThanAMinuteMessage(for hashValue: UInt32) -> Message {
        let index = Int(hashValue % UInt32(self.longerTomorrowMoreThanAMinuteMessages.count))

        return self.longerTomorrowMoreThanAMinuteMessages[index]
    }

    private var shorterLessThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(format: "Unfortunately, the day is a little bit shorter today. Make the most out of it!"))
        messages.append(Message(format: "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!"))
        messages.append(Message(format: "Today is shorter than yesterday. But fear not, brighter times ahead!"))

        return messages
    }

    private func shorterLessThanAMinuteMessage(for hashValue: UInt32) -> Message {
        let index = Int(hashValue % UInt32(self.shorterLessThanAMinuteMessages.count))

        return self.shorterLessThanAMinuteMessages[index]
    }

    private var shorterTomorrowMoreThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(format: "Unfortunately, tomorrow will be **%@ minutes** shorter than today. Make the most out of it!"))
        messages.append(Message(format: "Sadly, tomorrow will be **%@ minutes** shorter than today. Enjoy it while it lasts!"))
        messages.append(Message(format: "Tomorrow will be **%@ minutes** shorter than today. But fear not, brighter times ahead!"))

        return messages
    }

    private func shorterTomorrowMoreThanAMinuteMessage(for hashValue: UInt32) -> Message {
        let index = Int(hashValue % UInt32(self.shorterTomorrowMoreThanAMinuteMessages.count))

        return self.shorterTomorrowMoreThanAMinuteMessages[index]
    }

    private var shorterTomorrowLessThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(format: "Unfortunately, tomorrow will be a little bit shorter than today. Make the most out of it!"))
        messages.append(Message(format: "Sadly, tomorrow will be a tiny bit shorter than today. Enjoy it while it lasts!"))
        messages.append(Message(format: "Tomorrow will be shorter than today. But fear not, brighter times ahead!"))

        return messages
    }

    private func shorterTomorrowLessThanAMinuteMessage(for hashValue: UInt32) -> Message {
        let index = Int(hashValue % UInt32(self.shorterTomorrowLessThanAMinuteMessages.count))

        return self.shorterTomorrowLessThanAMinuteMessages[index]
    }

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long

        return formatter
    }()

    func generateMessage(forHashValue hashValue: UInt32, sunPhase: SunPhase, yesterdayDaylightLength: Double, todayDaylightLength: Double, tomorrowDaylightLength: Double) -> Message {
        let messageKind = Message.Kind(sunPhase: sunPhase, yesterdayDaylightLength: yesterdayDaylightLength, todayDaylightLength: todayDaylightLength, tomorrowDaylightLength: tomorrowDaylightLength)
        switch messageKind {
        case .longerMoreThanAMinute:
            return longerMoreThanAMinuteMessage(for: hashValue)
        case .longerLessThanAMinute:
            return longerLessThanAMinuteMessage(for: hashValue)
        case .shorterMoreThanAMinute:
            return shorterMoreThanAMinuteMessage(for: hashValue)
        case .shorterLessThanAMinute:
            return self.shorterLessThanAMinuteMessage(for: hashValue)
        case .longerTomorrowMoreThanAMinute:
            return self.longerTomorrowMoreThanAMinuteMessage(for: hashValue)
        case .longerTomorrowLessThanAMinute:
            return self.longerTomorrowLessThanAMinuteMessage(for: hashValue)
        case .shorterTomorrowMoreThanAMinute:
            return self.shorterTomorrowMoreThanAMinuteMessage(for: hashValue)
        case .shorterTomorrowLessThanAMinute:
            return self.shorterTomorrowLessThanAMinuteMessage(for: hashValue)
        }
    }
}
