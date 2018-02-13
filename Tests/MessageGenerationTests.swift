import CoreLocation
@testable import Daylight
import UIKit
import XCTest

class MessageGenerationTests: XCTestCase {
    // 21st of December 2017 12:00 GMT
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
    private var locationSouth: Location!

    override func setUp() {
        super.setUp()

        let coordinate = Location.testLocation
        self.location = Location(coordinate: coordinate, city: "Bonn", country: "Germany")

        let coordinateSouth = CLLocationCoordinate2D(latitude: -27.4698, longitude: 153.0251)
        self.locationSouth = Location(coordinate: coordinateSouth, city: "Brisbane", country: "Australia")
    }

    func testMessageDeterminismFromWinterSolstice() {
        let expected = [
            "Have a magical winter solstice! The light will soon brighten up your days again.",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "There’s about a minute of extra light at the end of this tunnel.",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "There’s about a minute of extra light at the end of this tunnel.",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
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
            "Today is 3 minutes longer than yesterday. Happy days!"
        ]

        let initialDate = self.decemberSolsticeDate
        let futureDates = initialDate.andNext30Days()

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
            "Today is 3 minutes longer. It’s getting better and better!",
            "After darkness comes daylight. 3 minutes more to be precise!",
            "Today is 3 minutes longer. It’s getting better and better!"
        ]

        let initialDate = self.afterDecemberSolticeDate
        let futureDates = initialDate.andNext30Days()

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
            "The sun will be out 2 minutes less today. Keep your head up!",
            "Sadly, the day will be 1 minute shorter. Make the most out of it!",
            "Sadly, the day will be 1 minute shorter. Make the most out of it!",
            "1 minute less sunlight today, unfortunately. It’ll get better!",
            "1 minute less sunlight today, unfortunately. It’ll get better!",
            "Sadly, the day will be 1 minute shorter. Make the most out of it!",
            "Sadly, the day will be 1 minute shorter. Make the most out of it!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Have a magical winter solstice! The light will soon brighten up your days again.",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "There’s about a minute of extra light at the end of this tunnel.",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "There’s about a minute of extra light at the end of this tunnel.",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "1 minute more daylight today. Just let it sink in…",
            "Smile! Today has 1 minute more daylight than yesterday!",
            "After darkness comes daylight. 1 minute more to be precise!",
            "Today is 1 minute longer. It’s getting better and better!",
            "After darkness comes daylight. 1 minute more to be precise!"
        ]

        // Date is now two days after
        let initialDate = self.beforeDecemberSolsticeDate
        let futureDates = initialDate.andNext30Days()

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
            "Today is 1 minute longer. It’s getting better and better!",
            "After darkness comes daylight. 1 minute more to be precise!",
            "Today is 1 minute longer. It’s getting better and better!",
            "Today is 1 minute longer. It’s getting better and better!",
            "The sun is out for 1 minute more today. Enjoy!",
            "Smile! Today has 1 minute more daylight than yesterday!",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "Happy first day of summer: make the most out of it!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "The sun will be out 1 minute less today. Keep your head up!",
            "1 minute less sunlight today, unfortunately. It’ll get better!",
            "1 minute less sunlight today, unfortunately. It’ll get better!",
            "1 minute less sunlight today, unfortunately. It’ll get better!"
        ]

        // Date is now two days after
        let initialDate = self.juneSolsticeDate
        let futureDates = initialDate.andNext30Days()

        // Expected string should match date list count. 31 messages for 31 days.
        XCTAssertEqual(expected.count, futureDates.count)

        for (index, date) in futureDates.enumerated() {
            let message = Notifier.formattedMessage(location: self.location, date: date)
            XCTAssertEqual(message, expected[index], "Index: \(index).")
        }
    }

    func testMessageDeterminismForSouthernHemisphere() {
        // For a given day, we'll always get the same message format.
        // For a given day and location, always the same message.
        // Remeber, in the south, it's winter in july!
        let expected = [
            "Tomorrow will be shorter than today. But fear not, brighter times ahead!",
            "Sadly, tomorrow will be a tiny bit shorter than today. Enjoy it while it lasts!",
            "Unfortunately, tomorrow will be a little bit shorter than today. Make the most out of it!",
            "Sadly, tomorrow will be a tiny bit shorter than today. Enjoy it while it lasts!",
            "Sadly, tomorrow will be a tiny bit shorter than today. Enjoy it while it lasts!",
            "Tomorrow will be shorter than today. But fear not, brighter times ahead!",
            "Tomorrow will be shorter than today. But fear not, brighter times ahead!",
            "Unfortunately, tomorrow will be a little bit shorter than today. Make the most out of it!",
            "Sadly, tomorrow will be a tiny bit shorter than today. Enjoy it while it lasts!",
            "Tomorrow will be shorter than today. But fear not, brighter times ahead!",
            "Sadly, tomorrow will be a tiny bit shorter than today. Enjoy it while it lasts!",
            "Tomorrow will be shorter than today. But fear not, brighter times ahead!",
            "Sadly, tomorrow will be a tiny bit shorter than today. Enjoy it while it lasts!",
            "Tomorrow will be shorter than today. But fear not, brighter times ahead!",
            "Sadly, tomorrow will be a tiny bit shorter than today. Enjoy it while it lasts!",
            "Have a magical winter solstice! The light will soon brighten up your days again.",
            "The sun has set. Soak up the extra vitamin D tomorrow!",
            "Get a good night’s sleep: tomorrow there’ll be more sunlight for you.",
            "The sun has set. Soak up the extra vitamin D tomorrow!",
            "Get a good night’s sleep: tomorrow there’ll be more sunlight for you.",
            "The sun has set. Soak up the extra vitamin D tomorrow!",
            "Get a good night’s sleep: tomorrow there’ll be more sunlight for you.",
            "Get a good night’s sleep: tomorrow there’ll be more sunlight for you.",
            "Get a good night’s sleep: tomorrow there’ll be more sunlight for you.",
            "The sun has set. Soak up the extra vitamin D tomorrow!",
            "Get a good night’s sleep: tomorrow there’ll be more sunlight for you.",
            "The sun has set. Soak up the extra vitamin D tomorrow!",
            "Get a good night’s sleep: tomorrow there’ll be more sunlight for you.",
            "Bring out those pyjamas. More daylight awaits tomorrow!",
            "Bring out those pyjamas. More daylight awaits tomorrow!",
            "Bring out those pyjamas. More daylight awaits tomorrow!",
        ]

        // Date is now two days after
        let initialDate = self.juneSolsticeDate
        let futureDates = initialDate.andNext30Days()

        // Expected string should match date list count. 31 messages for 31 days.
        XCTAssertEqual(expected.count, futureDates.count)

        for (index, date) in futureDates.enumerated() {
            let message = Notifier.formattedMessage(location: self.locationSouth, date: date)
            XCTAssertEqual(message, expected[index], "Index: \(index).")
        }
    }

    func testMessageFormatting() {
        // For a given day, we'll always get the same message format.
        // For a given day and location, always the same message.
        let expected = [
            "The sun will be out **%@** less today. Keep your head up!",
            "Sadly, the day will be **%@** shorter. Make the most out of it!",
            "Sadly, the day will be **%@** shorter. Make the most out of it!",
            "**%@** less sunlight today, unfortunately. It’ll get better!",
            "**%@** less sunlight today, unfortunately. It’ll get better!",
            "Sadly, the day will be **%@** shorter. Make the most out of it!",
            "Sadly, the day will be **%@** shorter. Make the most out of it!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Have a magical winter solstice! The light will soon brighten up your days again.",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "There’s about a minute of extra light at the end of this tunnel.",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "There’s about a minute of extra light at the end of this tunnel.",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "**%@** more daylight today. Just let it sink in…",
            "Smile! Today has **%@** more daylight than yesterday!",
            "After darkness comes daylight. **%@** more to be precise!",
            "Today is **%@** longer. It’s getting better and better!",
            "After darkness comes daylight. **%@** more to be precise!"
        ]

        // Date is now two days after
        let initialDate = self.beforeDecemberSolsticeDate
        let futureDates = initialDate.andNext30Days()

        // Expected string should match date list count. 31 messages for 31 days.
        XCTAssertEqual(expected.count, futureDates.count)

        for (index, date) in futureDates.enumerated() {
            let message = Message(for: date, coordinates: self.location.coordinates).preformattedMessage
            XCTAssertEqual(message, expected[index], "Index: \(index).")
        }
    }

    func testWeeklyMessages() {
        // 12th of November 2018 12:00 GMT
        let sunday = Date(timeIntervalSince1970: 1518350400)
        let messageNorth = Message(for: sunday, coordinates: self.location.coordinates, weeklySummary: true).formattedMessage
        let messageSouth = Message(for: sunday, coordinates: self.locationSouth.coordinates, weeklySummary: true).formattedMessage

        XCTAssertEqual(messageNorth, "Hooray, you've gained more than 24 minutes sunshine since last week!")
        XCTAssertEqual(messageSouth, "There are 10 minutes less sun than last week, but don't worry!")
    }
}
