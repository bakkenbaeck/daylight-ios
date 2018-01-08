import UIKit

struct Message {

    enum Kind: Int {
        case longerMoreThanAMinute
        case longerLessThanAMinute

        case shorterMoreThanAMinute
        case shorterLessThanAMinute

        init(daylightLenghtDifference: Double) {
            // positive values mean days are getting longer
            if daylightLenghtDifference == abs(daylightLenghtDifference) {
                if daylightLenghtDifference >= 1.minute {
                    self = .longerMoreThanAMinute
                } else {
                    self = .longerLessThanAMinute
                }
            } else {
                if abs(daylightLenghtDifference) >= 1.minute {
                    self = .shorterMoreThanAMinute
                } else {
                    self = .shorterLessThanAMinute
                }
            }
        }
    }

    init(format: String) {
        self.format = format
    }

    let format: String

    var content: String {
        return self.format.replacingOccurrences(of: "**", with: "")
    }

    var coloredPart: String {
        let regex = try! NSRegularExpression(pattern: "\\*\\*([^\"]*)\\*\\*")
        let nsString = self.format as NSString
        let results = regex.matches(in: self.format, range: NSRange(location: 0, length: nsString.length))
        if let firstResultRange = results.first?.range {
            let foundPart = nsString.substring(with: firstResultRange)

            return foundPart.replacingOccurrences(of: "**", with: "")
        } else {
            return ""
        }
    }

    func attributedString(withTextColor textColor: UIColor) -> NSAttributedString {
        return self.content.attributedString(withColoredPart: self.coloredPart, withTextColor: textColor)
    }
}
