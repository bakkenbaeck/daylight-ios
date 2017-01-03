import XCTest

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
}
