import CoreLocation
@testable import Daylight
import UIKit
import XCTest

class SunPhaseTests: XCTestCase {

    func testSunPhase() {
        let coordinate = CLLocationCoordinate2D(latitude: 50.5, longitude: 30.5)

        let timeZone = TimeZone(identifier: "UTC")!
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = timeZone

        var dateComponents = DateComponents()
        dateComponents.timeZone = timeZone
        dateComponents.day = 5
        dateComponents.month = 3
        dateComponents.year = 2013

        dateComponents.hour = 0
        dateComponents.minute = 0
        var date = calendar.date(from: dateComponents)!
        var sunTime = SunTime(date: date, coordinate: coordinate)
        XCTAssertEqual(sunTime.sunPhase, .predawn)

        dateComponents.hour = 4
        dateComponents.minute = 2
        dateComponents.second = 18
        date = calendar.date(from: dateComponents)!
        sunTime = SunTime(date: date, coordinate: coordinate)
        XCTAssertEqual(sunTime.sunPhase, .dawn)

        dateComponents.hour = 4
        dateComponents.minute = 34
        dateComponents.second = 57
        date = calendar.date(from: dateComponents)!
        sunTime = SunTime(date: date, coordinate: coordinate)
        XCTAssertEqual(sunTime.sunPhase, .sunrise)

        dateComponents.hour = 10
        dateComponents.minute = 10
        dateComponents.second = 58
        date = calendar.date(from: dateComponents)!
        sunTime = SunTime(date: date, coordinate: coordinate)
        XCTAssertEqual(sunTime.sunPhase, .solarNoon)

        dateComponents.hour = 15
        dateComponents.minute = 46
        dateComponents.second = 58
        date = calendar.date(from: dateComponents)!
        sunTime = SunTime(date: date, coordinate: coordinate)
        XCTAssertEqual(sunTime.sunPhase, .sunset)

        dateComponents.hour = 16
        dateComponents.minute = 19
        dateComponents.second = 37
        date = calendar.date(from: dateComponents)!
        sunTime = SunTime(date: date, coordinate: coordinate)
        XCTAssertEqual(sunTime.sunPhase, .dusk)

        dateComponents.hour = 17
        dateComponents.minute = 35
        dateComponents.second = 37
        date = calendar.date(from: dateComponents)!
        sunTime = SunTime(date: date, coordinate: coordinate)
        XCTAssertEqual(sunTime.sunPhase, .night)
    }
}
