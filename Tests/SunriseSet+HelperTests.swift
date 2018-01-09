import UIKit
import XCTest
import CoreLocation

@testable import Daylight

class Suntimes_HelperTests: XCTestCase {

    func testDaylightLengthProgress() {
        let coordinate = CLLocationCoordinate2D(latitude: 59.917, longitude: 10.75)

        let timeZone = TimeZone(identifier: "UTC")!
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = timeZone

        var dateComponents = DateComponents()
        dateComponents.timeZone = timeZone
        dateComponents.day = 1
        dateComponents.month = 1
        dateComponents.year = 2017

        dateComponents.hour = 0
        dateComponents.minute = 0
        var date = calendar.date(from: dateComponents)!
        var sunTimes = SunTime(date: date, coordinate: coordinate)
        XCTAssertEqual(sunTimes.daylightLengthProgress, 0)

        dateComponents.hour = 8
        dateComponents.minute = 18
        dateComponents.second = 04
        date = calendar.date(from: dateComponents)!
        sunTimes = SunTime(date: date, coordinate: coordinate)
        XCTAssertEqual(sunTimes.daylightLengthProgress, 0)

        dateComponents.hour = 11
        dateComponents.minute = 11
        dateComponents.second = 45
        date = calendar.date(from: dateComponents)!
        sunTimes = SunTime(date: date, coordinate: coordinate)
        XCTAssertEqual(sunTimes.daylightLengthProgress, 0.5, accuracy: 0.05)

        dateComponents.hour = 14
        dateComponents.minute = 23
        dateComponents.second = 15
        date = calendar.date(from: dateComponents)!
        sunTimes = SunTime(date: date, coordinate: coordinate)
        XCTAssertEqual(sunTimes.daylightLengthProgress, 1, accuracy: 0.05)
    }
}
