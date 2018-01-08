import UIKit
import XCTest
import CoreLocation

@testable import Daylight

class MessageGeneratorTests: XCTestCase {
    let initialDate: Date = Date(timeIntervalSince1970: 1513854000)

    var afterDate: Date {
        return Calendar.autoupdatingCurrent.date(byAdding: .day, value: 15, to: self.initialDate)!
    }

    var beforeDate: Date {
        return Calendar.autoupdatingCurrent.date(byAdding: .day, value: -15, to: self.initialDate)!
    }

    private var location: Location!

    override func setUp() {
        super.setUp()

        // Bonn, Germany, 21st of December 2017 12:00
        // <+50.73390258,+7.09812965> +/- 65.00m (speed -1.00 mps / course -1.00) @ 08.01.18, 11:33:02 Central European Standard Time
        let coordinate = CLLocationCoordinate2D(latitude: 50.73390258, longitude: 7.09812965)
        self.location = Location(coordinate: coordinate, city: "Bonn", country: "Germany")
    }

    override func tearDown() {
        super.tearDown()
    }

    func testMessageGeneration() {
        let expected = [
            "Today is the winter solstice ☀️! From now on, every day should get a bit brighter! Enjoy!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "Bring out your shorts, because today has 1 minute more sunlight.",
            "Smile! Today has 1 minute more daylight than yesterday!",
            "After darkness comes daylight. 1 minute more to be precise!",
            "Today is 1 minute longer. It’s getting better and better!",
            "1 minute more daylight today. Just let it sink in…",
            "2 minutes extra sunshine today. Make them count!",
            "After darkness comes daylight. 2 minutes more to be precise!",
            "Today is 2 minutes longer than yesterday. Happy days!",
            "Make sure to soak up that vitamin D. 2 minutes more daylight today!",
            "2 minutes more daylight today. Just let it sink in…",
            "Today is 2 minutes longer. It’s getting better and better!",
            "2 minutes more daylight today. Just let it sink in…",
            "2 minutes extra sunshine today. Make them count!",
            "Make sure to soak up that vitamin D. 2 minutes more daylight today!",
            "2 minutes extra sunshine today. Make them count!",
            "2 minutes more daylight today. Just let it sink in…",
            "Today is 2 minutes longer than yesterday. Happy days!",
            "Bring out your shorts, because today has 2 minutes more sunlight.",
            "Smile! Today has 3 minutes more daylight than yesterday!",
            "Smile! Today has 3 minutes more daylight than yesterday!",
        ]

        let initialDate = self.initialDate
        let futureDates = initialDate.futureDates()
        var actual = [String]()

        // Expected string should match date list
        XCTAssertEqual(expected.count, futureDates.count)

        for (index, date) in futureDates.enumerated() {
            let message = Notifier.formattedMessage(location: self.location, date: date)
            actual.append(message)
            XCTAssertEqual(message, expected[index], "Index: \(index).")
        }

        print(actual)
    }

    func testAndDemonstrateMessageDeterminism() {
        // same list as before, without the first 2 elements, with two new ones appended at the end.
        // For a given day, we'll always get the same message format.
        // For a given day and location, always the same message.
        let expected = [
            "1 minute more daylight today. Just let it sink in…",
            "2 minutes extra sunshine today. Make them count!",
            "After darkness comes daylight. 2 minutes more to be precise!",
            "Today is 2 minutes longer than yesterday. Happy days!",
            "Make sure to soak up that vitamin D. 2 minutes more daylight today!",
            "2 minutes more daylight today. Just let it sink in…",
            "Today is 2 minutes longer. It’s getting better and better!",
            "2 minutes more daylight today. Just let it sink in…",
            "2 minutes extra sunshine today. Make them count!",
            "Make sure to soak up that vitamin D. 2 minutes more daylight today!",
            "2 minutes extra sunshine today. Make them count!",
            "2 minutes more daylight today. Just let it sink in…",
            "Today is 2 minutes longer than yesterday. Happy days!",
            "Bring out your shorts, because today has 2 minutes more sunlight.",
            "Smile! Today has 3 minutes more daylight than yesterday!",
            "Smile! Today has 3 minutes more daylight than yesterday!",
            "The sun is out for 3 minutes more today. Enjoy!",
            "3 minutes extra sunshine today. Make them count!",
            "3 minutes more daylight today. Just let it sink in…",
            "Today is 3 minutes longer than yesterday. Happy days!",
            "Make sure to soak up that vitamin D. 3 minutes more daylight today!",
            "Today is 3 minutes longer than yesterday. Happy days!",
            "After darkness comes daylight. 3 minutes more to be precise!",
            "Smile! Today has 3 minutes more daylight than yesterday!",
            "The sun is out for 3 minutes more today. Enjoy!",
            "After darkness comes daylight. 3 minutes more to be precise!",
            "Today is 3 minutes longer than yesterday. Happy days!",
            "Bring out your shorts, because today has 3 minutes more sunlight.",
            "Today is 3 minutes longer than yesterday. Happy days!",
            "After darkness comes daylight. 3 minutes more to be precise!",
            "3 minutes extra sunshine today. Make them count!",
        ]

        let initialDate = self.afterDate
        let futureDates = initialDate.futureDates()
        var actual = [String]()

        // Expected string should match date list
        XCTAssertEqual(expected.count, futureDates.count)

        for (index, date) in futureDates.enumerated() {
            let message = Notifier.formattedMessage(location: self.location, date: date)
            actual.append(message)

            XCTAssertEqual(message, expected[index], "Index: \(index).")
        }

        print(actual)
    }

    func testEarlier() {
        // same list as before, without the first 2 elements, with two new ones appended at the end.
        // For a given day, we'll always get the same message format.
        // For a given day and location, always the same message.
        let expected = [
            "2 minutes less sunlight today, unfortunately. It’ll get better!",
            "The sun will be out  1 minute less today. Keep your head up!",
            "1 minute less sunlight today, unfortunately. It’ll get better!",
            "1 minute less sunlight today, unfortunately. It’ll get better!",
            "Sadly, the day will be 1 minute shorter. Make the most out of it!",
            "The sun will be out  1 minute less today. Keep your head up!",
            "Sadly, the day will be 1 minute shorter. Make the most out of it!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Today is the winter solstice ☀️! From now on, every day should get a bit brighter! Enjoy!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "Bring out your shorts, because today has 1 minute more sunlight.",
            "Smile! Today has 1 minute more daylight than yesterday!",
            "After darkness comes daylight. 1 minute more to be precise!",
            "Today is 1 minute longer. It’s getting better and better!",
            "1 minute more daylight today. Just let it sink in…",
            ]

        // Date is now two days after
        let initialDate = self.beforeDate
        let futureDates = initialDate.futureDates()
        var actual = [String]()

        // Expected string should match date list
        XCTAssertEqual(expected.count, futureDates.count)

        for (index, date) in futureDates.enumerated() {
            let message = Notifier.formattedMessage(location: self.location, date: date)
            actual.append(message)

            XCTAssertEqual(message, expected[index], "Index: \(index).")
        }

        print(actual)
    }
}
