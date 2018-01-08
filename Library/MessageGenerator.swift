import Foundation

struct MessageGenerator {
    let informationMessage = Message(format: "Daylight is an experiment inspired by the dark and long winters of the north. Made by **Bakken & Bæck**.")

    func message(for day: Date, hemisphere: Location.Hemisphere, sunPhase: SunPhase, daylightLenghtDifference: Double) -> Message {
        let message = self.generateMessage(date: day, hemisphere: hemisphere, daylightLenghtDifference: daylightLenghtDifference)

        return message
    }

    func messageForNotification(date: Date, hemisphere: Location.Hemisphere, daylightLenghtDifference: Double) -> String {
        let message = self.generateMessage(date: date, hemisphere: hemisphere, daylightLenghtDifference: daylightLenghtDifference)

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

        messages.append(Message(format: "The sun will be out ** %@ less** today. Keep your head up!"))
        messages.append(Message(format: "**%@ less** sunlight today, unfortunately. It’ll get better!"))
        messages.append(Message(format: "Sadly, the day will be **%@ shorter**. Make the most out of it!"))

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

        messages.append(Message(format: "Get a good night’s sleep: tomorrow there’ll be **%@ more** sunlight."))
        messages.append(Message(format: "Lights out. Enjoy **%@** more sunlight tomorrow!"))
        messages.append(Message(format: "Bring out those pyjamas. ** %@** more light await tomorrow."))
        messages.append(Message(format: "The sun has set for today. Embrace those **%@** of extra daylight tomorrow."))
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

        messages.append(Message(format: "Unfortunately, tomorrow will be **%@** shorter than today. Make the most out of it!"))
        messages.append(Message(format: "Sadly, tomorrow will be **%@** shorter than today. Enjoy it while it lasts!"))
        messages.append(Message(format: "Tomorrow will be **%@** shorter than today. But fear not, brighter times ahead!"))

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

    private var summerSolsticeMessages: [Message] {
        return [
            Message(format: "Happy summer solstice! Get yourself a healthy summer glow."),
            Message(format: "Happy first day of summer: make the most out of it!")
        ]
    }

    private func summerSolsticeMessage(for hashValue: UInt32) -> Message {
        let index = Int(hashValue % UInt32(self.summerSolsticeMessages.count))

        return self.summerSolsticeMessages[index]
    }

    private var winterSolsticeMessages: [Message] {
        return [
            Message(format: "Happy winter solstice! The light begins its journey back to full brightness from now on."),
            Message(format: "Have a magical winter solstice! The light will soon brighten up your days again.")
        ]
    }

    private func winterSolsticeMessage(for hashValue: UInt32) -> Message {
        let index = Int(hashValue % UInt32(self.winterSolsticeMessages.count))

        return self.winterSolsticeMessages[index]
    }

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long

        return formatter
    }()

    func generateMessage(date: Date, hemisphere: Location.Hemisphere, daylightLenghtDifference: Double) -> Message {
        let hashValue = self.hashValue(for: date)

        if date.isSolstice {
            if date.isJuneSolstice {
                switch hemisphere {
                case .southern:
                    return self.winterSolsticeMessage(for: hashValue)
                case .northern:
                    return self.summerSolsticeMessage(for: hashValue)
                }
            } else {
                switch hemisphere {
                case .southern:
                    return self.summerSolsticeMessage(for: hashValue)
                case .northern:
                    return self.winterSolsticeMessage(for: hashValue)
                }
            }
        } else {
            let messageKind = Message.Kind(daylightLenghtDifference: daylightLenghtDifference)
            switch messageKind {
            case .longerMoreThanAMinute:
                return self.longerMoreThanAMinuteMessage(for: hashValue)
            case .longerLessThanAMinute:
                return self.longerLessThanAMinuteMessage(for: hashValue)
            case .shorterMoreThanAMinute:
                return shorterMoreThanAMinuteMessage(for: hashValue)
            case .shorterLessThanAMinute:
                return self.shorterLessThanAMinuteMessage(for: hashValue)
            }
        }
    }

    func hashValue(for date: Date) -> UInt32 {
        let dateString = self.dateFormatter.string(from: date)

        // We use an FNV hash of the date string, to ensure that each day has it's own message, instead of randomising.
        let value = FNVHash.fnv1a_32(string: dateString)

        return value
    }
}

