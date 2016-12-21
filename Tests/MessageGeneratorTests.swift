import UIKit
import XCTest

class MessageGeneratorTests: XCTestCase {
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
