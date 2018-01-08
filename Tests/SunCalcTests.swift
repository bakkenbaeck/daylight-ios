import XCTest
import CoreLocation

@testable import Daylight

class SunCalcTests: XCTestCase {

    /*
     sunCalc.nadir         2013-03-04 22:10:57 +0000
     sunCalc.nightEnd      2013-03-05 02:46:17 +0000
     sunCalc.nauticalDawn  2013-03-05 03:24:31 +0000
     sunCalc.dawn          2013-03-05 04:02:17 +0000
     sunCalc.sunrise       2013-03-05 04:34:56 +0000
     sunCalc.sunriseEnd    2013-03-05 04:38:19 +0000
     sunCalc.goldenHourEnd 2013-03-05 05:19:01 +0000
     sunCalc.solarNoon     2013-03-05 10:10:57 +0000
     sunCalc.goldenHour    2013-03-05 15:02:52 +0000
     sunCalc.sunsetStart   2013-03-05 15:43:34 +0000
     sunCalc.sunset        2013-03-05 15:46:57 +0000
     sunCalc.dusk          2013-03-05 16:19:36 +0000
     sunCalc.nauticalDusk  2013-03-05 16:57:22 +0000
     sunCalc.night         2013-03-05 17:35:36 +0000
     */
    func testAPI() {
        let bundle = Bundle(for: SunCalcTests.self)

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
        let date = calendar.date(from: dateComponents)!

        let sunCalc = SunCalc(date: date, timeZone: timeZone, latitude: coordinate.latitude, longitude: coordinate.longitude, bundle: bundle)

        // DAY 4
        dateComponents.day = 4

        dateComponents.hour = 22
        dateComponents.minute = 10
        dateComponents.second = 57
        let expectedNadir = calendar.date(from: dateComponents)!
        XCTAssertEqual(sunCalc.nadir.timeIntervalSince1970, expectedNadir.timeIntervalSince1970, accuracy: 0.99)

        // DAY 5
        dateComponents.day = 5

        dateComponents.hour = 2
        dateComponents.minute = 46
        dateComponents.second = 17
        let expectedNightEnd = calendar.date(from: dateComponents)!

        XCTAssertEqual(sunCalc.nightEnd.timeIntervalSince1970, expectedNightEnd.timeIntervalSince1970, accuracy: 0.99)

        dateComponents.hour = 3
        dateComponents.minute = 24
        dateComponents.second = 31
        let expectedNauticalDawn = calendar.date(from: dateComponents)!
        XCTAssertEqual(sunCalc.nauticalDawn.timeIntervalSince1970, expectedNauticalDawn.timeIntervalSince1970, accuracy: 0.99)

        dateComponents.hour = 4
        dateComponents.minute = 2
        dateComponents.second = 17
        let expectedDawn = calendar.date(from: dateComponents)!
        XCTAssertEqual(sunCalc.dawn.timeIntervalSince1970, expectedDawn.timeIntervalSince1970, accuracy: 0.99)

        dateComponents.hour = 4
        dateComponents.minute = 34
        dateComponents.second = 56
        let expectedSunrise = calendar.date(from: dateComponents)!
        XCTAssertEqual(sunCalc.sunrise.timeIntervalSince1970, expectedSunrise.timeIntervalSince1970, accuracy: 0.99)

        dateComponents.hour = 4
        dateComponents.minute = 38
        dateComponents.second = 19
        let expectedSunriseEnd = calendar.date(from: dateComponents)!
        XCTAssertEqual(sunCalc.sunriseEnd.timeIntervalSince1970, expectedSunriseEnd.timeIntervalSince1970, accuracy: 0.99)

        dateComponents.hour = 5
        dateComponents.minute = 19
        dateComponents.second = 1
        let expectedGoldenHourEnd = calendar.date(from: dateComponents)!
        XCTAssertEqual(sunCalc.goldenHourEnd.timeIntervalSince1970, expectedGoldenHourEnd.timeIntervalSince1970, accuracy: 0.99)

        dateComponents.hour = 10
        dateComponents.minute = 10
        dateComponents.second = 57
        let expectedSolarNoon = calendar.date(from: dateComponents)!
        XCTAssertEqual(sunCalc.solarNoon.timeIntervalSince1970, expectedSolarNoon.timeIntervalSince1970, accuracy: 0.99)

        dateComponents.hour = 15
        dateComponents.minute = 2
        dateComponents.second = 52
        let expectedGoldenHour = calendar.date(from: dateComponents)!
        XCTAssertEqual(sunCalc.goldenHour.timeIntervalSince1970, expectedGoldenHour.timeIntervalSince1970, accuracy: 0.99)

        dateComponents.hour = 17
        dateComponents.minute = 35
        dateComponents.second = 36
        let expectedNight = calendar.date(from: dateComponents)!
        XCTAssertEqual(sunCalc.night.timeIntervalSince1970, expectedNight.timeIntervalSince1970, accuracy: 0.99)

        dateComponents.hour = 15
        dateComponents.minute = 43
        dateComponents.second = 34
        let expectedSunsetStart = calendar.date(from: dateComponents)!
        XCTAssertEqual(sunCalc.sunsetStart.timeIntervalSince1970, expectedSunsetStart.timeIntervalSince1970, accuracy: 0.99)

        dateComponents.hour = 15
        dateComponents.minute = 46
        dateComponents.second = 57
        let expectedSunset = calendar.date(from: dateComponents)!
        XCTAssertEqual(sunCalc.sunset.timeIntervalSince1970, expectedSunset.timeIntervalSince1970, accuracy: 0.99)

        dateComponents.hour = 16
        dateComponents.minute = 19
        dateComponents.second = 36
        let expectedDusk = calendar.date(from: dateComponents)!
        XCTAssertEqual(sunCalc.dusk.timeIntervalSince1970, expectedDusk.timeIntervalSince1970, accuracy: 0.99)

        dateComponents.hour = 16
        dateComponents.minute = 57
        dateComponents.second = 22
        let expectedNauticalDusk = calendar.date(from: dateComponents)!
        XCTAssertEqual(sunCalc.nauticalDusk.timeIntervalSince1970, expectedNauticalDusk.timeIntervalSince1970, accuracy: 0.99)
    }
}
