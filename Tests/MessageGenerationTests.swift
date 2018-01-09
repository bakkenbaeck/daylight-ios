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
            "Have a magical winter solstice! The light will soon brighten up your days again.",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "There’s about a minute of extra light at the end of this tunnel.",
            "There’s about a minute of extra light at the end of this tunnel.",
            "1 minute more daylight today. Just let it sink in…",
            "Smile! Today has 1 minute more daylight than yesterday!",
            "After darkness comes daylight. 1 minute more to be precise!",
            "Today is 1 minute longer. It’s getting better and better!",
            "After darkness comes daylight. 1 minute more to be precise!",
            "Smile! Today has 2 minutes more daylight than yesterday!",
            "Make sure to soak up that vitamin D. 2 minutes more daylight today!",
            "Smile! Today has 2 minutes more daylight than yesterday!",
            "Make sure to soak up that vitamin D. 2 minutes more daylight today!",
            "Bring out your shorts, because today has 2 minutes more sunlight.",
            "Smile! Today has 2 minutes more daylight than yesterday!",
            "Make sure to soak up that vitamin D. 2 minutes more daylight today!",
            "2 minutes extra sunshine today. Make them count!",
            "The sun is out for 2 minutes more today. Enjoy!",
            "Today is 2 minutes longer. It’s getting better and better!",
            "Make sure to soak up that vitamin D. 2 minutes more daylight today!",
            "Have a great day and enjoy those 2 minutes extra daylight.",
            "Bring out your shorts, because today has 2 minutes more sunlight.",
            "Today is 3 minutes longer. It’s getting better and better!",
            "Today is 3 minutes longer than yesterday. Happy days!",
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
            "After darkness comes daylight. 1 minute more to be precise!",
            "Smile! Today has 2 minutes more daylight than yesterday!",
            "Make sure to soak up that vitamin D. 2 minutes more daylight today!",
            "Smile! Today has 2 minutes more daylight than yesterday!",
            "Make sure to soak up that vitamin D. 2 minutes more daylight today!",
            "Bring out your shorts, because today has 2 minutes more sunlight.",
            "Smile! Today has 2 minutes more daylight than yesterday!",
            "Make sure to soak up that vitamin D. 2 minutes more daylight today!",
            "2 minutes extra sunshine today. Make them count!",
            "The sun is out for 2 minutes more today. Enjoy!",
            "Today is 2 minutes longer. It’s getting better and better!",
            "Make sure to soak up that vitamin D. 2 minutes more daylight today!",
            "Have a great day and enjoy those 2 minutes extra daylight.",
            "Bring out your shorts, because today has 2 minutes more sunlight.",
            "Today is 3 minutes longer. It’s getting better and better!",
            "Today is 3 minutes longer than yesterday. Happy days!",
            "Make sure to soak up that vitamin D. 3 minutes more daylight today!",
            "Have a great day and enjoy those 3 minutes extra daylight.",
            "Bring out your shorts, because today has 3 minutes more sunlight.",
            "3 minutes extra sunshine today. Make them count!",
            "3 minutes more daylight today. Just let it sink in…",
            "Have a great day and enjoy those 3 minutes extra daylight.",
            "Make sure to soak up that vitamin D. 3 minutes more daylight today!",
            "Have a great day and enjoy those 3 minutes extra daylight.",
            "Make sure to soak up that vitamin D. 3 minutes more daylight today!",
            "Bring out your shorts, because today has 3 minutes more sunlight.",
            "Have a great day and enjoy those 3 minutes extra daylight.",
            "3 minutes more daylight today. Just let it sink in…",
            "Smile! Today has 3 minutes more daylight than yesterday!",
            "Bring out your shorts, because today has 3 minutes more sunlight.",
            "Smile! Today has 3 minutes more daylight than yesterday!"
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
            "Sadly, the day will be 1 minute shorter. Make the most out of it!",
            "Sadly, the day will be 1 minute shorter. Make the most out of it!",
            "The sun will be out  1 minute less today. Keep your head up!",
            "Sadly, the day will be 1 minute shorter. Make the most out of it!",
            "Sadly, the day will be 1 minute shorter. Make the most out of it!",
            "1 minute less sunlight today, unfortunately. It’ll get better!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Have a magical winter solstice! The light will soon brighten up your days again.",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "There’s about a minute of extra light at the end of this tunnel.",
            "There’s about a minute of extra light at the end of this tunnel.",
            "1 minute more daylight today. Just let it sink in…",
            "Smile! Today has 1 minute more daylight than yesterday!",
            "After darkness comes daylight. 1 minute more to be precise!",
            "Today is 1 minute longer. It’s getting better and better!",
            "After darkness comes daylight. 1 minute more to be precise!"
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
            "The sun is out for 1 minute more today. Enjoy!",
            "Today is 1 minute longer. It’s getting better and better!",
            "After darkness comes daylight. 1 minute more to be precise!",
            "Today is 1 minute longer. It’s getting better and better!",
            "Have a great day and enjoy those 1 minute extra daylight.",
            "Make sure to soak up that vitamin D. 1 minute more daylight today!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "There’s about a minute of extra light at the end of this tunnel.",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "Happy summer solstice! Get yourself a healthy summer glow.",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "1 minute less sunlight today, unfortunately. It’ll get better!",
            "Sadly, the day will be 1 minute shorter. Make the most out of it!",
            "The sun will be out  1 minute less today. Keep your head up!",
            "The sun will be out  1 minute less today. Keep your head up!",
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
