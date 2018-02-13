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
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "There are 0 minutes less sun than last week, but don't worry!",  // weekly summary
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "There’s about a minute of extra light at the end of this tunnel.",
            "Hooray, you've gained more than 5 minutes sunshine since last week!",  // weekly summary
            "2 minutes more daylight today. Just let it sink in…",
            "Smile! Today has 2 minutes more daylight than yesterday!",
            "After darkness comes daylight. 2 minutes more to be precise!",
            "Today is 2 minutes longer. It’s getting better and better!",
            "After darkness comes daylight. 2 minutes more to be precise!",
            "Smile! Today has 2 minutes more daylight than yesterday!",
            "10 minutes more sunlight since last week!", // weekly summary
            "Smile! Today has 2 minutes more daylight than yesterday!",
            "Make sure to soak up that vitamin D. 2 minutes more daylight today!",
            "Bring out your shorts, because today has 2 minutes more sunlight.",
            "Smile! Today has 2 minutes more daylight than yesterday!",
            "Make sure to soak up that vitamin D. 3 minutes more daylight today!",
            "3 minutes extra sunshine today. Make them count!",
            "14 minutes more sunlight since last week!", // weekly summary
            "Today is 3 minutes longer. It’s getting better and better!",
            "Make sure to soak up that vitamin D. 3 minutes more daylight today!",
            "Have a great day and enjoy those 3 minutes extra daylight.",
            "Bring out your shorts, because today has 3 minutes more sunlight.",
            "Today is 3 minutes longer. It’s getting better and better!",
            "Today is 3 minutes longer than yesterday. Happy days!",
        ]

        let initialDate = self.decemberSolsticeDate
        let futureDates = initialDate.andNext30Days()

        // Expected string should match date list count. 31 messages for 31 days.
        XCTAssertEqual(expected.count, futureDates.count)

        // var actual = [String]()

        for (index, date) in futureDates.enumerated() {
            let message = Notifier.formattedMessage(location: self.location, date: date)
           // actual.append(message)
            XCTAssertEqual(message, expected[index], "Index: \(index).")
        }

        // print(actual)
    }

    func testMessageDeterminismAfterSolstice() {
        // For a given day, we'll always get the same message format.
        // For a given day and location, always the same message.
        let expected = [
            "After darkness comes daylight. 2 minutes more to be precise!",
            "Smile! Today has 2 minutes more daylight than yesterday!",
            "10 minutes more sunlight since last week!", // weekly summary
            "Smile! Today has 2 minutes more daylight than yesterday!",
            "Make sure to soak up that vitamin D. 2 minutes more daylight today!",
            "Bring out your shorts, because today has 2 minutes more sunlight.",
            "Smile! Today has 2 minutes more daylight than yesterday!",
            "Make sure to soak up that vitamin D. 3 minutes more daylight today!",
            "3 minutes extra sunshine today. Make them count!",
            "14 minutes more sunlight since last week!", // weekly summary
            "Today is 3 minutes longer. It’s getting better and better!",
            "Make sure to soak up that vitamin D. 3 minutes more daylight today!",
            "Have a great day and enjoy those 3 minutes extra daylight.",
            "Bring out your shorts, because today has 3 minutes more sunlight.",
            "Today is 3 minutes longer. It’s getting better and better!",
            "Today is 3 minutes longer than yesterday. Happy days!",
            "18 minutes more sunlight since last week!", // weekly summary
            "Have a great day and enjoy those 3 minutes extra daylight.",
            "Bring out your shorts, because today has 3 minutes more sunlight.",
            "3 minutes extra sunshine today. Make them count!",
            "3 minutes more daylight today. Just let it sink in…",
            "Have a great day and enjoy those 3 minutes extra daylight.",
            "Make sure to soak up that vitamin D. 3 minutes more daylight today!",
            "Hooray, you've gained more than 21 minutes sunshine since last week!", // weekly summary
            "Make sure to soak up that vitamin D. 4 minutes more daylight today!",
            "Bring out your shorts, because today has 4 minutes more sunlight.",
            "Have a great day and enjoy those 4 minutes extra daylight.",
            "4 minutes more daylight today. Just let it sink in…",
            "Smile! Today has 4 minutes more daylight than yesterday!",
            "Bring out your shorts, because today has 4 minutes more sunlight.",
            "Hooray, you've gained more than 23 minutes sunshine since last week!" // weekly summary
        ]

        let initialDate = self.afterDecemberSolticeDate
        let futureDates = initialDate.andNext30Days()

        // Expected string should match date list count. 31 messages for 31 days.
        XCTAssertEqual(expected.count, futureDates.count)

        // var actual = [String]()

        for (index, date) in futureDates.enumerated() {
            let message = Notifier.formattedMessage(location: self.location, date: date)
           // actual.append(message)
            XCTAssertEqual(message, expected[index], "Index: \(index).")
        }

        // print(actual)
    }

    func testMessageDeterminismIncludingSolstice() {
        // For a given day, we'll always get the same message format.
        // For a given day and location, always the same message.
        let expected = [
            "1 minute less sunlight today, unfortunately. It’ll get better!",
            "Sadly, the day will be 1 minute shorter. Make the most out of it!",
            "Sadly, the day will be 1 minute shorter. Make the most out of it!",
            "The sun will be out 1 minute less today. Keep your head up!",
            "10 minutes less sunshine. Fuck this 💩!", // weekly summary
            "Sadly, the day will be 1 minute shorter. Make the most out of it!",
            "1 minute less sunlight today, unfortunately. It’ll get better!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "There are 5 minutes less sun than last week, but don't worry!", // weekly summary
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Have a magical winter solstice! The light will soon brighten up your days again.",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "There are 0 minutes less sun than last week, but don't worry!", // weekly summary
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "We’ll have about a minute of extra light today. It’s upwards from here.",
            "About a minute of extra light. You’ll start noticing the difference soon!",
            "There’s about a minute of extra light at the end of this tunnel.",
            "Hooray, you've gained more than 5 minutes sunshine since last week!", // weekly summary
            "2 minutes more daylight today. Just let it sink in…",
            "Smile! Today has 2 minutes more daylight than yesterday!",
            "After darkness comes daylight. 2 minutes more to be precise!",
            "Today is 2 minutes longer. It’s getting better and better!",
            "After darkness comes daylight. 2 minutes more to be precise!",
        ]

        // Date is now two days after
        let initialDate = self.beforeDecemberSolsticeDate
        let futureDates = initialDate.andNext30Days()

        // Expected string should match date list count. 31 messages for 31 days.
        XCTAssertEqual(expected.count, futureDates.count)

        // var actual = [String]()

        for (index, date) in futureDates.enumerated() {
            let message = Notifier.formattedMessage(location: self.location, date: date)
            // actual.append(message)
            XCTAssertEqual(message, expected[index], "Index: \(index).")
        }

        // print(actual)
    }

    func testMessageDeterminismIncludingJuneSolstice() {
        // For a given day, we'll always get the same message format.
        // For a given day and location, always the same message.
        let expected = [
            "The sun is out for 2 minutes more today. Enjoy!",
            "Today is 2 minutes longer. It’s getting better and better!",
            "After darkness comes daylight. 2 minutes more to be precise!",
            "Today is 2 minutes longer. It’s getting better and better!",
            "Have a great day and enjoy those 2 minutes extra daylight.",
            "9 minutes more sunlight since last week!", // weekly summary
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "There’s about a minute of extra light at the end of this tunnel.",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "Hooray, you've gained more than 5 minutes sunshine since last week!",  // weekly summary
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "Happy summer solstice! Get yourself a healthy summer glow.",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "There are 0 minutes less sun than last week, but don't worry!", // weekly summary
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "5 minutes less sunshine. Fuck this 💩!", // weekly summary
            "1 minute less sunlight today, unfortunately. It’ll get better!",
            "Sadly, the day will be 1 minute shorter. Make the most out of it!",
            "The sun will be out 1 minute less today. Keep your head up!",
            "The sun will be out 1 minute less today. Keep your head up!",
        ]

        // Date is now two days after
        let initialDate = self.juneSolsticeDate
        let futureDates = initialDate.andNext30Days()

        // Expected string should match date list count. 31 messages for 31 days.
        XCTAssertEqual(expected.count, futureDates.count)

        // var actual = [String]()

        for (index, date) in futureDates.enumerated() {
            let message = Notifier.formattedMessage(location: self.location, date: date)
            // actual.append(message)
            XCTAssertEqual(message, expected[index], "Index: \(index).")
        }

        // print(actual)
    }

    func testMessageDeterminismForSouthernHemisphere() {
        // For a given day, we'll always get the same message format.
        // For a given day and location, always the same message.
        // Remeber, in the south, it's winter in july!
        let expected = [
            "The sun is out for 2 minutes more today. Enjoy!",
            "Today is 2 minutes longer. It’s getting better and better!",
            "After darkness comes daylight. 2 minutes more to be precise!",
            "Today is 2 minutes longer. It’s getting better and better!",
            "Have a great day and enjoy those 2 minutes extra daylight.",
            "9 minutes more sunlight since last week!", // weekly summary
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "There’s about a minute of extra light at the end of this tunnel.",
            "We’ve reached the tipping point: we’ll have more sunlight every day now!",
            "Hooray, you've gained more than 5 minutes sunshine since last week!", // weekly summary
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "Little less than a minute of extra sunlight today. It’s getting better!",
            "Happy summer solstice! Get yourself a healthy summer glow.",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "There are 0 minutes less sun than last week, but don't worry!", // weekly summary
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Today is shorter than yesterday. But fear not, brighter times ahead!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Unfortunately, the day is a little bit shorter today. Make the most out of it!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "Sadly, today is a tiny bit shorter than yesterday. Enjoy it while it lasts!",
            "5 minutes less sunshine. Fuck this 💩!", // weekly summary
            "1 minute less sunlight today, unfortunately. It’ll get better!",
            "Sadly, the day will be 1 minute shorter. Make the most out of it!",
            "The sun will be out 1 minute less today. Keep your head up!",
            "The sun will be out 1 minute less today. Keep your head up!",
        ]

        // Date is now two days after
        let initialDate = self.juneSolsticeDate
        let futureDates = initialDate.andNext30Days()

        // Expected string should match date list count. 31 messages for 31 days.
        XCTAssertEqual(expected.count, futureDates.count)

        // var actual = [String]()

        for (index, date) in futureDates.enumerated() {
            let message = Notifier.formattedMessage(location: self.location, date: date)
           //  actual.append(message)
            XCTAssertEqual(message, expected[index], "Index: \(index).")
        }

        // print(actual)
    }

    func testMessageFormatting() {
        // For a given day, we'll always get the same message format.
        // For a given day and location, always the same message.
        let expected = [
            "**%@** less sunlight today, unfortunately. It’ll get better!",
            "Sadly, the day will be **%@** shorter. Make the most out of it!",
            "Sadly, the day will be **%@** shorter. Make the most out of it!",
            "The sun will be out **%@** less today. Keep your head up!",
            "Sadly, the day will be **%@** shorter. Make the most out of it!",
            "Sadly, the day will be **%@** shorter. Make the most out of it!",
            "**%@** less sunlight today, unfortunately. It’ll get better!",
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
            "**%@** more daylight today. Just let it sink in…",
            "Smile! Today has **%@** more daylight than yesterday!",
            "After darkness comes daylight. **%@** more to be precise!",
            "Today is **%@** longer. It’s getting better and better!",
            "After darkness comes daylight. **%@** more to be precise!",
        ]

        // Date is now two days after
        let initialDate = self.beforeDecemberSolsticeDate
        let futureDates = initialDate.andNext30Days()

        // Expected string should match date list count. 31 messages for 31 days.
        XCTAssertEqual(expected.count, futureDates.count)

        // var actual = [String]()

        for (index, date) in futureDates.enumerated() {
            let message = Message(for: date, coordinates: self.location.coordinates).preformattedMessage
           // actual.append(message)
            XCTAssertEqual(message, expected[index], "Index: \(index).")
        }

        // print(actual)
    }

    func testWeeklyMessages() {
        // 12th of November 2018 12:00 GMT
        let sunday = Date(timeIntervalSince1970: 1518350400)
        let messageNorth = Message(for: sunday, coordinates: self.location.coordinates, weeklySummary: true).formattedMessage
        let messageSouth = Message(for: sunday, coordinates: self.locationSouth.coordinates, weeklySummary: true).formattedMessage

        XCTAssertEqual(messageNorth, "Hooray, you've gained more than 25 minutes sunshine since last week!")
        XCTAssertEqual(messageSouth, "There are 9 minutes less sun than last week, but don't worry!")
    }
}
