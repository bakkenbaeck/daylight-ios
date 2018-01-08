import Foundation

extension TimeInterval {
    var day: TimeInterval {
        return self.hour * 24
    }

    var hour: TimeInterval {
        return self.minute * 60.0
    }

    var minute: TimeInterval {
        return self * 60.0
    }
}

extension Int {
    var day: TimeInterval {
        return self.hour * 24
    }

    var hour: TimeInterval {
        return self.minute * 60.0
    }

    var minute: TimeInterval {
        return TimeInterval(self) * 60.0
    }
}
