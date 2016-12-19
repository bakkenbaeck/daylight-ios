import Foundation

struct MessageGenerator {
    let informationMessage = "Daylight is an experiment inspired by the dark and long winters of the north and made by Bakken & Bæck"
    let coloredInformation = "Bakken & Bæck"

    let message1 = "Today is %@ minutes longer than yesterday. Happy days!"
    let colored1 = "%@ minutes"
    let message2 = "The sun is out for %@ more minutes today. Enjoy!"
    let colored2 = "%@ more minutes"
    let message3 = "%@ extra minutes of sunshine today. Make them count!"
    let colored3 = "%@ extra minutes"
    let message4 = "Make sure to soak up that vitamin D. %@ more minutes of daylight today!"
    let colored4 = "%@ more minutes"
    let message5 = "Smile! Today has %@ more minutes of daylight than yesterday!"
    let colored5 = "%@ more minutes"
    let message6 = "%@ more minutes of daylight today. Just let it sink in…"
    let colored6 = "%@ more minutes"
    let message7 = "Today is %@ minutes longer. It’s getting better and better!"
    let colored7 = "%@ minutes"
    let message8 = "Bring out your shorts, because today has %@ more minutes of sunlight."
    let colored8 = "%@ more minutes"
    let message9 = "Have a great day and enjoy those %@ extra minutes of daylight."
    let colored9 = "%@ extra minutes"
    let message10 = "After darkness comes daylight. %@ more minutes to be precise!"
    let colored10 = "%@ more minutes"

    func longerDayMessage() -> (String, String) {
        let number = arc4random_uniform(10)
        switch number {
            case 0: return (self.message1, self.colored1)
            case 1: return (self.message2, self.colored2)
            case 2: return (self.message3, self.colored3)
            case 3: return (self.message4, self.colored4)
            case 4: return (self.message5, self.colored5)
            case 5: return (self.message6, self.colored6)
            case 6: return (self.message7, self.colored7)
            case 7: return (self.message8, self.colored8)
            case 8: return (self.message9, self.colored9)
            case 9: return (self.message10, self.colored10)
            default: return ("","")
        }

    }

    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long

        return formatter
    }()

    func message(forDay day: Date, withInterval interval: Double) -> (String, String) {
        let defaults = UserDefaults.standard

        let dayKey = self.dateFormatter.string(from: day)

        if let message = UserDefaults.standard.string(forKey: dayKey), let colored = UserDefaults.standard.string(forKey: "\(dayKey)colored") {
            return (message, colored)
        } else {
            //TODO: maybe clear out old user default values, we don't need them anymore!
            let message = self.generateMessage(forInterval: interval)
            defaults.set(message.0, forKey: dayKey)
            defaults.set(message.1, forKey: "\(dayKey)colored")
            return (message.0, message.1)
        }
    }

    func generateMessage(forInterval interval: Double) -> (String, String) {
        //TODO: Add the messages that need to be displayed for other time intervals
        return longerDayMessage()
    }
}
