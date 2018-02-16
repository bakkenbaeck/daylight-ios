@testable import Daylight
import UIKit
import XCTest

class Date_HelperTests: XCTestCase {

    func testNext30Dates() {
        let date = Date()

        let dateWithNext30: Array = date.andNext30Days()

        let firstDay = dateWithNext30.first
        let lastDay = dateWithNext30.last

        let day31 = Calendar.autoupdatingCurrent.date(byAdding: .day, value: 30, to: date)

        XCTAssertEqual(date, firstDay)
        XCTAssertEqual(day31, lastDay)
    }
}
