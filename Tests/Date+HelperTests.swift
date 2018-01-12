@testable import Daylight
import UIKit
import XCTest

class Date_HelperTests: XCTestCase {

    func testDatesOfComingYear() {
        let date = Date()

        let datesOfComingYear: Array = date.next31days()

        let firstDay = datesOfComingYear.first
        let lastDay = datesOfComingYear.last

        let dayInAYear = Calendar.autoupdatingCurrent.date(byAdding: .day, value: 30, to: date)

        XCTAssertEqual(date, firstDay)
        XCTAssertEqual(dayInAYear, lastDay)
    }
}
