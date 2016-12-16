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

        let message = messageGenerator.message(forDay: Date(), withInterval: 2)
        let message2 = messageGenerator.message(forDay: Date(), withInterval: 2)

        XCTAssertEqual(message.0, message2.0)
        XCTAssertEqual(message.1, message2.1)
    }
}
