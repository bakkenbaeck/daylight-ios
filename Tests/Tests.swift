import UIKit
import XCTest

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLongerDayMessage() {
        let messageGenerator = MessageGenerator()
        let date = Date()

        let message = messageGenerator.message(forDay: date, withInterval: 2)
        let message2 = messageGenerator.message(forDay: date, withInterval: 2)

        XCTAssertEqual(message.text, message2.text)
        XCTAssertEqual(message.colored, message2.colored)
    }

    func testNoChangeMessage() {
        let messageGenerator = MessageGenerator()
        let date = Date()

        let message = messageGenerator.message(forDay: date, withInterval: 0.5)
        let formattedString = String(format: message.text, 0)

        XCTAssert(formattedString.characters.count > 0)
    }

    func testShorterMessage() {
        let messageGenerator = MessageGenerator()
        let date = Date()

        let message = messageGenerator.message(forDay: date, withInterval: -1)
        let formattedString = String(format: message.text, 0)

        XCTAssert(formattedString.characters.count > 0)
    }

    func testNightMessage() {
        let messageGenerator = MessageGenerator()

        let message = messageGenerator.nightMessage()
        let formattedString = String(format: message.text, 0)

        XCTAssert(formattedString.characters.count > 0)
    }
}
