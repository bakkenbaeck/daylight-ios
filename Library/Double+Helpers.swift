import Darwin

extension Double {
    func minuteString() -> String {
        let minutesString = String(describing: Int(Darwin.round(self / 60.0)))

        return minutesString
    }
}
