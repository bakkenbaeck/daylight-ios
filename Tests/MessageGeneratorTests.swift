import UIKit
import XCTest

class MessageGeneratorTests: XCTestCase {
    func testLongerDayMessage() {
        let messageGenerator = MessageGenerator()
        let date = Date()

        let message = messageGenerator.message(forDay: date, withInterval: 2)
        let message2 = messageGenerator.message(forDay: date, withInterval: 2)

        XCTAssertEqual(message.content, message2.content)
        XCTAssertEqual(message.coloredPart, message2.coloredPart)
    }

    func testNoChangeMessage() {
        let messageGenerator = MessageGenerator()
        let date = Date()

        let message = messageGenerator.message(forDay: date, withInterval: 0.5)
        let formattedString = String(format: message.content, 0)

        XCTAssert(formattedString.characters.count > 0)
    }

    func testShorterMessage() {
        let messageGenerator = MessageGenerator()
        let date = Date()

        let message = messageGenerator.message(forDay: date, withInterval: -1)
        let formattedString = String(format: message.content, 0)

        XCTAssert(formattedString.characters.count > 0)
    }

    func testNightMessage() {
        let messageGenerator = MessageGenerator()

        let message = messageGenerator.longerTomorrowMoreThanAMinuteMessage()
        let formattedString = String(format: message.content, 0)

        XCTAssert(formattedString.characters.count > 0)
    }

    func testDatesOfComingYear() {
        let date = Date()

        let datesOfComingYear: Array = date.datesOfComingYear()

        let firstDay = datesOfComingYear.first
        let lastDay = datesOfComingYear.last

        let dayInAYear = Calendar.current.date(byAdding: .day, value: 365, to: date)

        XCTAssertEqual(date, firstDay)
        XCTAssertEqual(dayInAYear, lastDay)
    }
}
