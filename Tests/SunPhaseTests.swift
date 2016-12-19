import UIKit
import XCTest
import CoreLocation

class SunPhaseTests: XCTestCase {
    func testSunPhase() {
        let timeZone = TimeZone(identifier: "UTC")!
        var dateComponents = DateComponents()
        dateComponents.timeZone = timeZone
        dateComponents.day = 1
        dateComponents.month = 1
        dateComponents.year = 2017

        dateComponents.hour = 0
        dateComponents.minute = 0
        var date = Calendar.current.date(from: dateComponents)!
        print(date)
        var sunPhase = SunPhase.get(for: date, in: timeZone, at: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        XCTAssertEqual(sunPhase, .night)

        dateComponents.hour = 5
        dateComponents.minute = 46
        date = Calendar.current.date(from: dateComponents)!
        print(date)
        sunPhase = SunPhase.get(for: date, in: timeZone, at: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        XCTAssertEqual(sunPhase, .twilight)

        dateComponents.hour = 6
        dateComponents.minute = 12
        date = Calendar.current.date(from: dateComponents)!
        print(date)
        sunPhase = SunPhase.get(for: date, in: timeZone, at: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        XCTAssertEqual(sunPhase, .twilight)

        dateComponents.hour = 6
        dateComponents.minute = 38
        date = Calendar.current.date(from: dateComponents)!
        print(date)
        sunPhase = SunPhase.get(for: date, in: timeZone, at: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        XCTAssertEqual(sunPhase, .twilight)

        dateComponents.hour = 7
        dateComponents.minute = 1
        date = Calendar.current.date(from: dateComponents)!
        sunPhase = SunPhase.get(for: date, in: timeZone, at: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        XCTAssertEqual(sunPhase, .sunrise)

        dateComponents.hour = 7
        dateComponents.minute = 3
        date = Calendar.current.date(from: dateComponents)!
        sunPhase = SunPhase.get(for: date, in: timeZone, at: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        XCTAssertEqual(sunPhase, .daylight)

        dateComponents.hour = 19
        dateComponents.minute = 6
        date = Calendar.current.date(from: dateComponents)!
        sunPhase = SunPhase.get(for: date, in: timeZone, at: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        XCTAssertEqual(sunPhase, .sunset)

        dateComponents.hour = 19
        dateComponents.minute = 8
        date = Calendar.current.date(from: dateComponents)!
        sunPhase = SunPhase.get(for: date, in: timeZone, at: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        XCTAssertEqual(sunPhase, .twilight)

        dateComponents.hour = 19
        dateComponents.minute = 30
        date = Calendar.current.date(from: dateComponents)!
        sunPhase = SunPhase.get(for: date, in: timeZone, at: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        XCTAssertEqual(sunPhase, .twilight)

        dateComponents.hour = 19
        dateComponents.minute = 56
        date = Calendar.current.date(from: dateComponents)!
        sunPhase = SunPhase.get(for: date, in: timeZone, at: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        XCTAssertEqual(sunPhase, .twilight)

        dateComponents.hour = 20
        dateComponents.minute = 23
        date = Calendar.current.date(from: dateComponents)!
        sunPhase = SunPhase.get(for: date, in: timeZone, at: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        XCTAssertEqual(sunPhase, .night)
    }
}
