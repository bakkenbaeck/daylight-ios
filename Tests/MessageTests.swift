import XCTest
import UIKit
import CoreLocation

@testable import Daylight

extension Location {
    static var testLocation: CLLocationCoordinate2D {
        // Bonn
        return CLLocationCoordinate2D(latitude: 50.73390258, longitude: 7.09812965)
    }
}

class MessageTests: XCTestCase {
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
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: range)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: -0.75, range: NSRange(location: 0, length: content.count))
        XCTAssertEqual(message.attributedString(withTextColor: UIColor.red), attributedString)

        format = "**%@ minutes** more."
        content = "%@ minutes more."
        coloredPart = "%@ minutes"

        message = Message(format: format)
        range = (content as NSString).range(of: coloredPart)
        attributedString = NSMutableAttributedString(string: content)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: range)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: -0.75, range: NSRange(location: 0, length: content.count))
        XCTAssertEqual(message.attributedString(withTextColor: UIColor.red), attributedString)
    }

    func testHashValueForDate() {
        let beginningOfDayString = "2014-07-15 01:00"
        let endOfDayString = "2014-07-15 23:40"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        let beginningOfDayDate = dateFormatter.date(from: beginningOfDayString)
        let endOfDayDate = dateFormatter.date(from: endOfDayString)

        let beginningOfDayHashValue = DateHasher.hashValue(for: beginningOfDayDate!)
        let endOfDayHashValue = DateHasher.hashValue(for: endOfDayDate!)

        XCTAssertEqual(beginningOfDayHashValue, endOfDayHashValue)
    }

    func testMessageForDay() {
        let beginningOfDayString = "2014-07-15 01:00"
        let endOfDayString = "2014-07-15 23:40"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        let beginningOfDayDate = dateFormatter.date(from: beginningOfDayString)!
        let endOfDayDate = dateFormatter.date(from: endOfDayString)!

        let beginMessage = Message(for: beginningOfDayDate, coordinates: Location.testLocation)
        let endMessage = Message(for: endOfDayDate, coordinates: Location.testLocation)

        XCTAssertEqual(beginMessage.content, endMessage.content)
    }

    func testMessageForNight() {
        let beginningOfDayString = "2014-07-15 01:00"
        let endOfDayString = "2014-07-15 23:40"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        let beginningOfDayDate = dateFormatter.date(from: beginningOfDayString)!
        let endOfDayDate = dateFormatter.date(from: endOfDayString)!

        let beginMessage = Message(for: beginningOfDayDate, coordinates: Location.testLocation)
        let endMessage = Message(for: endOfDayDate, coordinates: Location.testLocation)

        XCTAssertEqual(beginMessage.content, endMessage.content)
    }

    func testNotificationMessage() {
        let message = Message.notificationMessage(for: Date(), coordinates: Location.testLocation)

        XCTAssertFalse(message.contains("**"))
    }
}
