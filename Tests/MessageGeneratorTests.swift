import UIKit
import XCTest
import CoreLocation

@testable import Daylight

class MessageGeneratorTests: XCTestCase {
    let initialDate: Date = Date(timeIntervalSince1970: 1513680960)

    var twoDaysAfter: Date {
        return self.initialDate.dayAfter().dayAfter()
    }

    private var location: Location!

    override func setUp() {
        super.setUp()

        // Bonn, Germany, 19th of December 2017 11:56
        // <+50.73390258,+7.09812965> +/- 65.00m (speed -1.00 mps / course -1.00) @ 08.01.18, 11:33:02 Central European Standard Time
        let coordinate = CLLocationCoordinate2D(latitude: 50.73390258, longitude: 7.09812965)
        self.location = Location(coordinate: coordinate, city: "Bonn", country: "Germany")
    }

    override func tearDown() {
        super.tearDown()
    }

    func testMessageGeneration() {
        let expected = [
            "Today is 1 minute longer than yesterday. Happy days!",
            "Smile! Today has 1 minute more daylight than yesterday!",
            "Today is the winter solstice ☀️! From now on, every day will get a bit brighter! Enjoy!",
            "Today is 1 minute longer. It’s getting better and better!",
            "The sun is out for 1 minute more today. Enjoy!",
            "Today is 1 minute longer. It’s getting better and better!",
            "After darkness comes daylight. 1 minute more to be precise!",
            "Today is 1 minute longer. It’s getting better and better!",
            "Bring out your shorts, because today has 1 minute more sunlight.",
            "1 minute extra sunshine today. Make them count!",
            "1 minute more daylight today. Just let it sink in…",
            "After darkness comes daylight. 1 minute more to be precise!",
            "Smile! Today has 1 minute more daylight than yesterday!",
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
            "Today is the winter solstice ☀️! From now on, every day will get a bit brighter! Enjoy!",
            "Today is 1 minute longer. It’s getting better and better!",
            "The sun is out for 1 minute more today. Enjoy!",
            "Today is 1 minute longer. It’s getting better and better!",
            "After darkness comes daylight. 1 minute more to be precise!",
            "Today is 1 minute longer. It’s getting better and better!",
            "Bring out your shorts, because today has 1 minute more sunlight.",
            "1 minute extra sunshine today. Make them count!",
            "1 minute more daylight today. Just let it sink in…",
            "After darkness comes daylight. 1 minute more to be precise!",
            "Smile! Today has 1 minute more daylight than yesterday!",
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

        // Date is now two days after
        let initialDate = self.twoDaysAfter
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
