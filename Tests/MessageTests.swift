import XCTest

class MessageTests: XCTestCase {
    func testKind() {
        XCTAssertEqual(Message.Kind.longerMoreThanAMinute,          Message.kind(isNight: false, yesterdayDayLenght: 0, todayDayLenght: 61, tomorrowDayLenght: 0))
        XCTAssertEqual(Message.Kind.longerLessThanAMinute,          Message.kind(isNight: false, yesterdayDayLenght: 0, todayDayLenght: 60, tomorrowDayLenght: 0))
        XCTAssertEqual(Message.Kind.shorterMoreThanAMinute,         Message.kind(isNight: false, yesterdayDayLenght: 61, todayDayLenght: 0, tomorrowDayLenght: 0))
        XCTAssertEqual(Message.Kind.shorterLessThanAMinute,         Message.kind(isNight: false, yesterdayDayLenght: 60, todayDayLenght: 0, tomorrowDayLenght: 0))
        XCTAssertEqual(Message.Kind.longerTomorrowMoreThanAMinute,  Message.kind(isNight: true,  yesterdayDayLenght: 0, todayDayLenght: 0, tomorrowDayLenght: 61))
        XCTAssertEqual(Message.Kind.longerTomorrowLessThanAMinute,  Message.kind(isNight: true,  yesterdayDayLenght: 0, todayDayLenght: 0, tomorrowDayLenght: 60))
        XCTAssertEqual(Message.Kind.shorterTomorrowMoreThanAMinute, Message.kind(isNight: true,  yesterdayDayLenght: 0, todayDayLenght: 61, tomorrowDayLenght: 0))
        XCTAssertEqual(Message.Kind.shorterTomorrowLessThanAMinute, Message.kind(isNight: true,  yesterdayDayLenght: 0, todayDayLenght: 60, tomorrowDayLenght: 0))
    }
}
