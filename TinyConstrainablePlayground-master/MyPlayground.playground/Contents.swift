import UIKit
import PlaygroundSupport
import TinyConstraints

struct SunViewLocation {
    let x: CGFloat
    let y: CGFloat
}

class SunView: UIView {
    static let sunSize = CGFloat(18.0)

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
        label.font = UIFont.systemFont(ofSize: 12)

        return label
    }()

    lazy var sunsetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right

        return label
    }()

    lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center

        label.font = UIFont.systemFont(ofSize: 12)

        return label
    }()

    lazy var sun: UIImageView = {
        let image = UIImage(named: "sun.png")!
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
        super.init(frame: CGRect.zero)

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

    func location(for percentageInDay: CGFloat) -> SunViewLocation {
        let position = CGFloat.pi + (percentageInDay * CGFloat.pi)
        let x = 50.0 + cos(position) * 50.0
        let y = abs(sin(position) * 100.0)

        let absoluteX = ((self.bounds.width - SunView.sunSize) / 100) * x
        let absoluteY = self.sunMask.frame.height - (self.sunMask.frame.height / 100.0) * y

        return SunViewLocation(x: absoluteX, y: absoluteY)
    }
}

let sunView = SunView()
let view = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 200))
view.backgroundColor = .white
view.addSubview(sunView)
sunView.edges(to: view, insets: .uniform(10))
PlaygroundPage.current.liveView = view
