import Foundation

extension Date {
    static var progress: Double {
        let now = Date()
        let startOfTheDay = Calendar.current.startOfDay(for: now)
        let secondsSinceStartOfTheDay = now.timeIntervalSince(startOfTheDay)
        let totalSeconds = 60 * 60 * 24

        return secondsSinceStartOfTheDay / Double(totalSeconds)
    }
}
