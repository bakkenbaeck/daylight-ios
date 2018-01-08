import Foundation

extension Collection where Index == Int {
    var random: Element? {
        return self.isEmpty ? nil : self[Int(arc4random_uniform(UInt32(self.endIndex)))]
    }
}

struct MessageGenerator {
    let informationMessage = Message(format: "Daylight is an experiment inspired by the dark and long winters of the north. Made by **Bakken & Bæck**.")

    func message(forDay day: Date, sunPhase: SunPhase, yesterdayDaylightLength: Double, todayDaylightLength: Double, tomorrowDaylightLength: Double) -> Message {
        let message = self.generateMessage(sunPhase: sunPhase, yesterdayDaylightLength: yesterdayDaylightLength, todayDaylightLength: todayDaylightLength, tomorrowDaylightLength: tomorrowDaylightLength)
        return message
    }

    func messageForNotification(forDate date: Date, yesterdayDaylightLength: Double, todayDaylightLength: Double, tomorrowDaylightLength: Double) -> String {
        let message = self.generateMessage(sunPhase: .solarNoon, yesterdayDaylightLength: yesterdayDaylightLength, todayDaylightLength: todayDaylightLength, tomorrowDaylightLength: tomorrowDaylightLength)

        return message.content
    }

    private var longerMoreThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(format: "Today is **%@** longer than yesterday. Happy days!"))
        messages.append(Message(format: "The sun is out for **%@ more** today. Enjoy!"))
        messages.append(Message(format: "**%@ extra** sunshine today. Make them count!"))
        messages.append(Message(format: "Make sure to soak up that vitamin D. **%@ more** daylight today!"))
        messages.append(Message(format: "Smile! Today has **%@ more** daylight than yesterday!"))
        messages.append(Message(format: "**%@ more** daylight today. Just let it sink in…"))
        messages.append(Message(format: "Today is **%@** longer. It’s getting better and better!"))
        messages.append(Message(format: "Bring out your shorts, because today has **%@ more** sunlight."))
        messages.append(Message(format: "Have a great day and enjoy those **%@ extra** daylight."))
        messages.append(Message(format: "After darkness comes daylight. **%@ more** to be precise!"))

        return messages
    }

    private func longerMoreThanAMinuteRandomMessage() -> Message {
        return self.longerMoreThanAMinuteMessages.random!
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

    private func longerLessThanAMinuteRandomMessage() -> Message {
        return self.longerLessThanAMinuteMessages.random!
    }

    private var shorterMoreThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(format: "The sun will be out ** %@ less** today. Keep your head up!"))
        messages.append(Message(format: "**%@ less** sunlight today, unfortunately. It’ll get better!"))
        messages.append(Message(format: "Sadly, the day will be **%@ shorter**. Make the most out of it!"))

        return messages
    }

    private func shorterMoreThanAMinuteRandomMessage() -> Message {
        return self.shorterMoreThanAMinuteMessages.random!
    }

    private var longerTomorrowLessThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(format: "Get a good night’s sleep: tomorrow there’ll be more sunlight for you."))
        messages.append(Message(format: "Bring out those pyjamas. More daylight awaits tomorrow!"))
        messages.append(Message(format: "The sun has set. Soak up the extra vitamin D tomorrow!"))

        return messages
    }

    private func longerTomorrowLessThanAMinuteRandomMessage() -> Message {
        return self.longerTomorrowLessThanAMinuteMessages.random!
    }

    private var longerTomorrowMoreThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(format: "Get a good night’s sleep: tomorrow there’ll be **%@ more** sunlight."))
        messages.append(Message(format: "Lights out. Enjoy **%@** more sunlight tomorrow!"))
        messages.append(Message(format: "Bring out those pyjamas. ** %@** more light await tomorrow."))
        messages.append(Message(format: "The sun has set for today. Embrace those **%@** of extra daylight tomorrow."))
        messages.append(Message(format: "The sun has set. Soak up the extra vitamin D tomorrow!"))

        return messages
    }

    private func longerTomorrowMoreThanAMinuteRandomMessage() -> Message {
        return self.longerTomorrowMoreThanAMinuteMessages.random!
    }

    private var shorterLessThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(format: "Unfortunately, the day is a little bit shorter today. Make the most out of it!"))
        messages.append(Message(format: "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!"))
        messages.append(Message(format: "Today is shorter than yesterday. But fear not, brighter times ahead!"))

        return messages
    }

    private func shorterLessThanAMinuteRandomMessage() -> Message {
        return self.shorterLessThanAMinuteMessages.random!
    }

    private var shorterTomorrowMoreThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(format: "Unfortunately, tomorrow will be **%@** shorter than today. Make the most out of it!"))
        messages.append(Message(format: "Sadly, tomorrow will be **%@** shorter than today. Enjoy it while it lasts!"))
        messages.append(Message(format: "Tomorrow will be **%@** shorter than today. But fear not, brighter times ahead!"))

        return messages
    }

    private func shorterTomorrowMoreThanAMinuteRandomMessage() -> Message {
        return self.shorterTomorrowMoreThanAMinuteMessages.random!
    }

    private var shorterTomorrowLessThanAMinuteMessages: [Message] {
        var messages = [Message]()

        messages.append(Message(format: "Unfortunately, tomorrow will be a little bit shorter than today. Make the most out of it!"))
        messages.append(Message(format: "Sadly, tomorrow will be a tiny bit shorter than today. Enjoy it while it lasts!"))
        messages.append(Message(format: "Tomorrow will be shorter than today. But fear not, brighter times ahead!"))

        return messages
    }

    private func shorterTomorrowLessThanAMinuteRandomMessage() -> Message {
        return self.shorterTomorrowLessThanAMinuteMessages.random!
    }

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long

        return formatter
    }()

    func generateMessage(sunPhase: SunPhase, yesterdayDaylightLength: Double, todayDaylightLength: Double, tomorrowDaylightLength: Double) -> Message {
        let messageKind = Message.Kind(sunPhase: sunPhase, yesterdayDaylightLength: yesterdayDaylightLength, todayDaylightLength: todayDaylightLength, tomorrowDaylightLength: tomorrowDaylightLength)
        switch messageKind {
        case .longerMoreThanAMinute:
            return self.longerMoreThanAMinuteRandomMessage()
        case .longerLessThanAMinute:
            return self.longerLessThanAMinuteRandomMessage()
        case .shorterMoreThanAMinute:
            return self.shorterMoreThanAMinuteRandomMessage()
        case .shorterLessThanAMinute:
            return self.shorterLessThanAMinuteRandomMessage()
        case .longerTomorrowMoreThanAMinute:
            return self.longerTomorrowMoreThanAMinuteRandomMessage()
        case .longerTomorrowLessThanAMinute:
            return self.longerTomorrowLessThanAMinuteRandomMessage()
        case .shorterTomorrowMoreThanAMinute:
            return self.shorterTomorrowMoreThanAMinuteRandomMessage()
        case .shorterTomorrowLessThanAMinute:
            return self.shorterTomorrowLessThanAMinuteRandomMessage()
        }
    }
}
