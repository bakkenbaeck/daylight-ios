import XCTest
import UIKit

class MessageTests: XCTestCase {
    func testKind() {
        XCTAssertEqual(Message.Kind.longerMoreThanAMinute, Message.Kind(sunPhase: .dawn, yesterdayDaylightLength: 0, todayDaylightLength: 61, tomorrowDaylightLength: 0))
        XCTAssertEqual(Message.Kind.longerLessThanAMinute, Message.Kind(sunPhase: .dawn, yesterdayDaylightLength: 0, todayDaylightLength: 60, tomorrowDaylightLength: 0))
        XCTAssertEqual(Message.Kind.shorterMoreThanAMinute, Message.Kind(sunPhase: .dawn, yesterdayDaylightLength: 61, todayDaylightLength: 0, tomorrowDaylightLength: 0))
        XCTAssertEqual(Message.Kind.shorterLessThanAMinute, Message.Kind(sunPhase: .dawn, yesterdayDaylightLength: 60, todayDaylightLength: 0, tomorrowDaylightLength: 0))
        XCTAssertEqual(Message.Kind.longerTomorrowMoreThanAMinute, Message.Kind(sunPhase: .night, yesterdayDaylightLength: 0, todayDaylightLength: 0, tomorrowDaylightLength: 61))
        XCTAssertEqual(Message.Kind.longerTomorrowLessThanAMinute, Message.Kind(sunPhase: .night, yesterdayDaylightLength: 0, todayDaylightLength: 0, tomorrowDaylightLength: 60))
        XCTAssertEqual(Message.Kind.shorterTomorrowMoreThanAMinute, Message.Kind(sunPhase: .night, yesterdayDaylightLength: 0, todayDaylightLength: 61, tomorrowDaylightLength: 0))
        XCTAssertEqual(Message.Kind.shorterTomorrowLessThanAMinute, Message.Kind(sunPhase: .night, yesterdayDaylightLength: 0, todayDaylightLength: 60, tomorrowDaylightLength: 0))
    }

    func testContent() {
        var message = Message(format: "Hello **mom**.")
        XCTAssertEqual(message.content, "Hello mom.")

        message = Message(format: "**%@ minutes** more.")
        XCTAssertEqual(message.content, "%@ minutes more.")
    }

    func testColoredPart() {
        var message = Message(format: "Hello **mom**.")
        XCTAssertEqual(message.coloredPart, "mom")

        message = Message(format: "**%@ minutes** more.")
        XCTAssertEqual(message.coloredPart, "%@ minutes")
    }

    func testAttributedString() {
        var format = "Hello **mom**."
        var content = "Hello mom."
        var coloredPart = "mom"

        var message = Message(format: format)
        var range = (content as NSString).range(of: coloredPart)
        var attributedString = NSMutableAttributedString(string: content)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: range)
        XCTAssertEqual(message.attributedString(withTextColor: UIColor.red), attributedString)

        format = "**%@ minutes** more."
        content = "%@ minutes more."
        coloredPart = "%@ minutes"

        message = Message(format: format)
        range = (content as NSString).range(of: coloredPart)
        attributedString = NSMutableAttributedString(string: content)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: range)
        XCTAssertEqual(message.attributedString(withTextColor: UIColor.red), attributedString)
    }

    func testHashValueForDateAndSunPhase() {
        let messageGenerator = MessageGenerator()

        let beginningOfDayString = "2014-07-15 01:00"
        let endOfDayString = "2014-07-15 23:40"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        let beginningOfDayDate = dateFormatter.date(from: beginningOfDayString)
        let endOfDayDate = dateFormatter.date(from: endOfDayString)
        
        let beginningOfDayHashValue = messageGenerator.hashValue(forDay: beginningOfDayDate!, andSunPhase: .dawn)
        let endOfDayHashValue = messageGenerator.hashValue(forDay: endOfDayDate!, andSunPhase: .dawn)

        XCTAssertEqual(beginningOfDayHashValue, endOfDayHashValue)
    }
}
