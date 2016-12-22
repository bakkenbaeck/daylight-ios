import UIKit
import XCTest
import CoreLocation
import Suntimes

class SunPhaseTests: XCTestCase {
    func testSunPhase() {
        let osloCoordinate = CLLocationCoordinate2D(latitude: 59.917, longitude: 10.75)

        let timeZone = TimeZone(identifier: "UTC")!
        var calendar = Calendar.current
        calendar.timeZone = timeZone

        var dateComponents = DateComponents()
        dateComponents.timeZone = timeZone
        dateComponents.day = 1
        dateComponents.month = 1
        dateComponents.year = 2017

        dateComponents.hour = 0
        dateComponents.minute = 0
        var date = calendar.date(from: dateComponents)!
        var suntimes = Suntimes(date: date, timeZone: timeZone, latitude: osloCoordinate.latitude, longitude: osloCoordinate.longitude)
        XCTAssertEqual(suntimes.sunPhase, .twilight)

        dateComponents.hour = 5
        dateComponents.minute = 35
        date = calendar.date(from: dateComponents)!
        suntimes = Suntimes(date: date, timeZone: timeZone, latitude: osloCoordinate.latitude, longitude: osloCoordinate.longitude)
        XCTAssertEqual(suntimes.sunPhase, .twilight)

        dateComponents.hour = 6
        dateComponents.minute = 26
        date = calendar.date(from: dateComponents)!
        suntimes = Suntimes(date: date, timeZone: timeZone, latitude: osloCoordinate.latitude, longitude: osloCoordinate.longitude)
        XCTAssertEqual(suntimes.sunPhase, .twilight)

        dateComponents.hour = 7
        dateComponents.minute = 22
        date = calendar.date(from: dateComponents)!
        suntimes = Suntimes(date: date, timeZone: timeZone, latitude: osloCoordinate.latitude, longitude: osloCoordinate.longitude)
        XCTAssertEqual(suntimes.sunPhase, .twilight)

        dateComponents.hour = 8
        dateComponents.minute = 19
        date = calendar.date(from: dateComponents)!
        suntimes = Suntimes(date: date, timeZone: timeZone, latitude: osloCoordinate.latitude, longitude: osloCoordinate.longitude)
        XCTAssertEqual(suntimes.sunPhase, .sunrise)

        dateComponents.hour = 14
        dateComponents.minute = 24
        date = calendar.date(from: dateComponents)!
        suntimes = Suntimes(date: date, timeZone: timeZone, latitude: osloCoordinate.latitude, longitude: osloCoordinate.longitude)
        XCTAssertEqual(suntimes.sunPhase, .sunset)

        dateComponents.hour = 15
        dateComponents.minute = 20
        date = calendar.date(from: dateComponents)!
        suntimes = Suntimes(date: date, timeZone: timeZone, latitude: osloCoordinate.latitude, longitude: osloCoordinate.longitude)
        XCTAssertEqual(suntimes.sunPhase, .twilight)

        dateComponents.hour = 16
        dateComponents.minute = 16
        date = calendar.date(from: dateComponents)!
        suntimes = Suntimes(date: date, timeZone: timeZone, latitude: osloCoordinate.latitude, longitude: osloCoordinate.longitude)
        XCTAssertEqual(suntimes.sunPhase, .twilight)

        dateComponents.hour = 17
        dateComponents.minute = 07
        date = calendar.date(from: dateComponents)!
        suntimes = Suntimes(date: date, timeZone: timeZone, latitude: osloCoordinate.latitude, longitude: osloCoordinate.longitude)
        XCTAssertEqual(suntimes.sunPhase, .night)

        dateComponents.hour = 23
        dateComponents.minute = 59
        date = calendar.date(from: dateComponents)!
        suntimes = Suntimes(date: date, timeZone: timeZone, latitude: osloCoordinate.latitude, longitude: osloCoordinate.longitude)
        XCTAssertEqual(suntimes.sunPhase, .night)
    }
}
