import UIKit
import XCTest
import CoreLocation

@testable import Daylight

class MessageGenerationTests: XCTestCase {
    // 21st of December 2017 12:00
    let decemberSolsticeDate: Date = Date(timeIntervalSince1970: 1513854000)

    var afterDecemberSolticeDate: Date {
        return Calendar.autoupdatingCurrent.date(byAdding: .day, value: 15, to: self.decemberSolsticeDate)!
    }

    var beforeDecemberSolsticeDate: Date {
        return Calendar.autoupdatingCurrent.date(byAdding: .day, value: -15, to: self.decemberSolsticeDate)!
    }

    var juneSolsticeDate: Date {
        let date = Calendar.autoupdatingCurrent.date(byAdding: .month, value: -6, to: self.decemberSolsticeDate)!
        return Calendar.autoupdatingCurrent.date(byAdding: .day, value: -15, to: date)!
    }

    private var location: Location!

    override func setUp() {
        super.setUp()

        // Bonn, Germany
        // <+50.73390258,+7.09812965> +/- 65.00m (speed -1.00 mps / course -1.00) @ 08.01.18, 11:33:02 Central European Standard Time
        let coordinate = CLLocationCoordinate2D(latitude: 50.73390258, longitude: 7.09812965)
        self.location = Location(coordinate: coordinate, city: "Bonn", country: "Germany")
    }

    func testMessageDeterminismFromWinterSolstice() {
        let expected = [
            "Have a magical winter solstice! The light will soon brighten up your days again.", // Winter solstice ☀️
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
            "Smile! Today has 3 minutes more daylight than yesterday!"
        ]

        let initialDate = self.decemberSolsticeDate
        let futureDates = initialDate.next30days()

        // Expected string should match date list count. 31 messages for 31 days.
        XCTAssertEqual(expected.count, futureDates.count)

        for (index, date) in futureDates.enumerated() {
            let message = Notifier.formattedMessage(location: self.location, date: date)
            XCTAssertEqual(message, expected[index], "Index: \(index).")
        }
    }

    func testMessageDeterminismAfterSolstice() {
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
            "3 minutes extra sunshine today. Make them count!"
        ]

        let initialDate = self.afterDecemberSolticeDate
        let futureDates = initialDate.next30days()

        // Expected string should match date list count. 31 messages for 31 days.
        XCTAssertEqual(expected.count, futureDates.count)

        for (index, date) in futureDates.enumerated() {
            let message = Notifier.formattedMessage(location: self.location, date: date)

            XCTAssertEqual(message, expected[index], "Index: \(index).")
        }
    }

    func testMessageDeterminismIncludingSolstice() {
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
            "Have a magical winter solstice! The light will soon brighten up your days again.", // Solstice ☀️
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
            "1 minute more daylight today. Just let it sink in…"
        ]

        // Date is now two days after
        let initialDate = self.beforeDecemberSolsticeDate
        let futureDates = initialDate.next30days()

        // Expected string should match date list count. 31 messages for 31 days.
        XCTAssertEqual(expected.count, futureDates.count)

        for (index, date) in futureDates.enumerated() {
            let message = Notifier.formattedMessage(location: self.location, date: date)
            XCTAssertEqual(message, expected[index], "Index: \(index).")
        }
    }

    func testMessageDeterminismIncludingJuneSolstice() {
        // For a given day, we'll always get the same message format.
        // For a given day and location, always the same message.
        let expected = [
            "Bring out your shorts, because today has 1 minute more sunlight.",
            "1 minute extra sunshine today. Make them count!",
            "After darkness comes daylight. 1 minute more to be precise!",
            "Today is 1 minute longer than yesterday. Happy days!",
            "Today is 1 minute longer. It’s getting better and better!",
            "1 minute more daylight today. Just let it sink in…",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "There’s about a minute of extra light at the end of this tunnel.",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "There’s about a minute of extra light at the end of this tunnel.",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "There’s about a minute of extra light at the end of this tunnel.",
            "Happy summer solstice! Get yourself a healthy summer glow.", // Solstice ☀️
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Sadly, the day will be 1 minute shorter. Make the most out of it!",
            "1 minute less sunlight today, unfortunately. It’ll get better!",
            "1 minute less sunlight today, unfortunately. It’ll get better!",
            "Sadly, the day will be 1 minute shorter. Make the most out of it!"
        ]

        // Date is now two days after
        let initialDate = self.juneSolsticeDate
        let futureDates = initialDate.next30days()

        // Expected string should match date list count. 31 messages for 31 days.
        XCTAssertEqual(expected.count, futureDates.count)

        for (index, date) in futureDates.enumerated() {
            let message = Notifier.formattedMessage(location: self.location, date: date)
            XCTAssertEqual(message, expected[index], "Index: \(index).")
        }
    }
}
