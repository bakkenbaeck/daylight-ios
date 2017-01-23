import UIKit
import CoreLocation

struct SunViewLocation {
    let x: CGFloat
    let y: CGFloat
}

class SunView: UIView {
    static let sunSize = CGFloat(18.0)

    var sunPhase = SunPhase.predawn {
        didSet {
            self.moon.isHidden = true
            self.currentTimeLabel.isHidden = false
            switch self.sunPhase {
            case .night, .predawn:
                self.moon.isHidden = false
                self.sunViewLocation = SunViewLocation(x: (self.frame.width - SunView.sunSize) / 2.0, y: 0.0)
            case .dawn:
                self.currentTimeLabel.isHidden = true
            default:
                break
            }
        }
    }

    var sunViewLocation = SunViewLocation(x: 0, y: 0) {
        didSet {
            self.setNeedsLayout()
        }
    }

    var sunLeftAnchor: NSLayoutConstraint?
    var sunTopAnchor: NSLayoutConstraint?
    var currentTimeBottomAnchor: NSLayoutConstraint?

    lazy var sunriseLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.light(size: 12)

        return label
    }()

    lazy var sunsetLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.light(size: 12)
        label.textAlignment = .right

        return label
    }()

    lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center

        label.font = Theme.light(size: 12)

        return label
    }()

    lazy var sun: UIImageView = {
        let image = UIImage(named: "sun")!
        let tintImage = image.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: tintImage)
        imageView.contentMode = .center

        return imageView
    }()

    lazy var moon: UIView = {
        let view = UIView()
        view.isHidden = true

        return view
    }()

    lazy var sunMask: UIView = {
        let view = UIView()

        view.clipsToBounds = true

        return view
    }()

    lazy var horizon: UIView = {
        let view = UIView()

        return view
    }()

    lazy var timeFormatter: DateFormatter = {
        let shortTimeFormatter = DateFormatter()
        shortTimeFormatter.dateFormat = "HH:mm"

        return shortTimeFormatter
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubviewsAndConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let labelWidth = CGFloat(35.0)

        self.sunriseLabel.frame = CGRect(x: 0, y: 116, width: labelWidth, height: 16)
        self.sunsetLabel.frame = CGRect(x: self.bounds.width - labelWidth, y: 116, width: labelWidth, height: 16)
        self.sun.frame = CGRect(x: self.sunViewLocation.x, y: self.sunViewLocation.y, width: SunView.sunSize, height: SunView.sunSize)
        self.sunMask.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 108)
        self.horizon.frame = CGRect(x: 0, y: 108, width: self.bounds.width, height: 1)
        self.currentTimeLabel.frame = CGRect(x: self.sunViewLocation.x - 10, y: self.sunViewLocation.y - 24, width: labelWidth, height: 16)
        self.moon.frame = CGRect(x: self.sunViewLocation.x + (SunView.sunSize / 2), y: self.sunViewLocation.y, width: SunView.sunSize / 2, height: SunView.sunSize)
    }

    func addSubviewsAndConstraints() {
        self.addSubview(self.horizon)
        self.addSubview(self.sunriseLabel)
        self.addSubview(self.sunsetLabel)
        self.addSubview(self.sunMask)
        self.sunMask.addSubview(self.sun)
        self.sunMask.addSubview(self.moon)
        self.addSubview(self.currentTimeLabel)
    }

    func update(for location: Location) {
        self.currentTimeLabel.text = self.timeFormatter.string(from: Date())
        self.sunriseLabel.text = location.sunriseTimeString
        self.sunsetLabel.text = location.sunsetTimeString
    }

    func location(for percentageInDay: CGFloat) -> SunViewLocation {
        let position = CGFloat.pi + (percentageInDay * CGFloat.pi)
        let x = 50.0 + cos(position) * 50.0
        let y = abs(sin(position) * 100.0)

        let absoluteX = ((self.bounds.width - SunView.sunSize) / 100) * x
        let absoluteY = self.sunMask.frame.height - (self.sunMask.frame.height / 100.0) * y

        return SunViewLocation(x: absoluteX, y: absoluteY)
    }

    func updateInterface(withBackgroundColor backgroundColor: UIColor, textColor: UIColor, andPercentageInDay percentageInDay: Double, sunPhase: SunPhase) {
        self.sunriseLabel.textColor = textColor
        self.sunsetLabel.textColor = textColor
        self.currentTimeLabel.textColor = textColor
        self.horizon.backgroundColor = textColor
        self.sun.tintColor = textColor
        self.moon.backgroundColor = backgroundColor

        self.sunViewLocation = self.location(for: CGFloat(percentageInDay))
        self.sunPhase = sunPhase
    }
}
