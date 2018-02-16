@testable import Daylight
import UIKit
import XCTest

class Date_HelperTests: XCTestCase {

    func testNext30Dates() {
        let calendar = Calendar.autoupdatingCurrent
        let components = DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 0), year: 2018, month: 1, day: 1, hour: 1, minute: 1, second: 1)
        let date = calendar.date(from: components)!

        let dateWithNext30: Array = date.andNext30Days()

        let firstDay = dateWithNext30.first
        let lastDay = dateWithNext30.last

        let day31 = calendar.date(byAdding: .day, value: 30, to: date)

        XCTAssertEqual(date, firstDay)
        XCTAssertEqual(day31, lastDay)
    }
}
