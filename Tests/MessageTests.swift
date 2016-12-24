import XCTest

class MessageTests: XCTestCase {
    func testKind() {
        XCTAssertEqual(Message.Kind.longerMoreThanAMinute,          Message.kind(sunPhase: .dawn, yesterdayDaylightLength: 0, todayDaylightLength: 61, tomorrowDaylightLength: 0))
        XCTAssertEqual(Message.Kind.longerLessThanAMinute,          Message.kind(sunPhase: .dawn, yesterdayDaylightLength: 0, todayDaylightLength: 60, tomorrowDaylightLength: 0))
        XCTAssertEqual(Message.Kind.shorterMoreThanAMinute,         Message.kind(sunPhase: .dawn, yesterdayDaylightLength: 61, todayDaylightLength: 0, tomorrowDaylightLength: 0))
        XCTAssertEqual(Message.Kind.shorterLessThanAMinute,         Message.kind(sunPhase: .dawn, yesterdayDaylightLength: 60, todayDaylightLength: 0, tomorrowDaylightLength: 0))
        XCTAssertEqual(Message.Kind.longerTomorrowMoreThanAMinute,  Message.kind(sunPhase: .night,  yesterdayDaylightLength: 0, todayDaylightLength: 0, tomorrowDaylightLength: 61))
        XCTAssertEqual(Message.Kind.longerTomorrowLessThanAMinute,  Message.kind(sunPhase: .night,  yesterdayDaylightLength: 0, todayDaylightLength: 0, tomorrowDaylightLength: 60))
        XCTAssertEqual(Message.Kind.shorterTomorrowMoreThanAMinute, Message.kind(sunPhase: .night,  yesterdayDaylightLength: 0, todayDaylightLength: 61, tomorrowDaylightLength: 0))
        XCTAssertEqual(Message.Kind.shorterTomorrowLessThanAMinute, Message.kind(sunPhase: .night,  yesterdayDaylightLength: 0, todayDaylightLength: 60, tomorrowDaylightLength: 0))
    }
}
