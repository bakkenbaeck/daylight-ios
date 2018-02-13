import CoreLocation
@testable import Daylight
import UIKit
import XCTest

extension Location {
    static var testLocation: CLLocationCoordinate2D {
        // Bonn
        return CLLocationCoordinate2D(latitude: 50.73390258, longitude: 7.09812965)
    }
}

class MessageTests: XCTestCase {
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm ZZZZZ"

        return dateFormatter
    }()

    func testContent() {
        var message = Message(format: "Hello **mom**.")
        XCTAssertEqual(message.formattedMessage, "Hello mom.")

        message = Message(format: "**%@** more.")
        XCTAssertEqual(message.formattedMessage, "0 minutes more.")
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
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: attributedString.string.whole)
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        attributedString.addAttribute(.kern, value: -0.75, range: NSRange(location: 0, length: content.count))

        XCTAssertEqual(message.attributedString(textColor: .black, highlightColor: .red), attributedString)

        format = "**0 minutes** more."
        content = "0 minutes more."
        coloredPart = "0 minutes"

        message = Message(format: format)
        range = (content as NSString).range(of: coloredPart)
        attributedString = NSMutableAttributedString(string: content)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: attributedString.string.whole)
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        attributedString.addAttribute(.kern, value: -0.75, range: NSRange(location: 0, length: content.count))

        XCTAssertEqual(message.attributedString(textColor: .black, highlightColor: .red), attributedString)
    }

    func testHashValueForDate() {
        let beginningOfDayString = "2014-07-15 01:00 -0000"
        let endOfDayString = "2014-07-15 23:40 -0000"

        let beginningOfDayDate = self.dateFormatter.date(from: beginningOfDayString)
        let endOfDayDate = self.dateFormatter.date(from: endOfDayString)

        let beginningOfDayHashValue = DateHasher.hashValue(for: beginningOfDayDate!)
        let endOfDayHashValue = DateHasher.hashValue(for: endOfDayDate!)

        XCTAssertEqual(beginningOfDayHashValue, endOfDayHashValue)
    }

    func testMessageForDay() {
        let beginningOfDayString = "2014-07-15 01:00 -0000"
        let endOfDayString = "2014-07-15 23:40 -0000"

        let beginningOfDayDate = self.dateFormatter.date(from: beginningOfDayString)!
        let endOfDayDate = self.dateFormatter.date(from: endOfDayString)!

        let beginMessage = Message(for: beginningOfDayDate, coordinates: Location.testLocation)
        let endMessage = Message(for: endOfDayDate, coordinates: Location.testLocation)

        XCTAssertEqual(beginMessage.formattedMessage, endMessage.formattedMessage)
    }

    func testMessageForNight() {
        let beginningOfDayString = "2014-07-15 01:00 -0000"
        let endOfDayString = "2014-07-15 23:40 -0000"

        let beginningOfDayDate = self.dateFormatter.date(from: beginningOfDayString)!
        let endOfDayDate = self.dateFormatter.date(from: endOfDayString)!

        let beginMessage = Message(for: beginningOfDayDate, coordinates: Location.testLocation)
        let endMessage = Message(for: endOfDayDate, coordinates: Location.testLocation)

        XCTAssertEqual(beginMessage.formattedMessage, endMessage.formattedMessage)
    }

    func testNotificationMessage() {
        let message = Message.notificationMessage(for: Date(), coordinates: Location.testLocation)

        XCTAssertFalse(message.contains("**"))
    }

    func testNightMessageOnlyAtNight() {
        // 20th of December 2017 11:00 UTC
        let date = Date(timeIntervalSince1970: 1513767600.0)
        let dayExpected = "Unfortunately, the day is a little bit shorter today. Make the most out of it!"
        let dayMessage = Message(for: date, coordinates: Location.testLocation)

        XCTAssertEqual(dayMessage.formattedMessage, dayExpected)

        // 20th of December 2017 21:00 UTC
        let nightDate = Date(timeIntervalSince1970: 1513803600.0)
        let nightExpected = "Unfortunately, tomorrow will be a little bit shorter than today. Make the most out of it!"
        let nightMessage = Message(for: nightDate, coordinates: Location.testLocation)

        XCTAssertEqual(nightMessage.formattedMessage, nightExpected)
    }
}
