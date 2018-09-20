import CoreLocation
import UIKit
import TinyConstraints

struct SunViewLocation {
    let x: CGFloat
    let y: CGFloat
}

class SunView: UIView {
    static let sunSize = CGFloat(18.0)

    var sunViewLocation = SunViewLocation(x: 0, y: 0)

    var sunViewLeftAnchor: NSLayoutConstraint?
    var sunViewBottomAnchor: NSLayoutConstraint?

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

    lazy var dayTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center

        label.font = UIFont.systemFont(ofSize: 12)

        return label
    }()
    
    lazy var aboveHorizonLayoutView: UIView = {
        let view = UIView()
        view.clipsToBounds = true

        return view
    }()

    lazy var sun: UIImageView = {
        let image = UIImage(named: "sun")!
        let tintImage = image.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: tintImage)
        imageView.contentMode = .center

        return imageView
    }()

    lazy var moon: UIView = {
        let image = UIImage(named: "moon")!
        let tintImage = image.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: tintImage)
        imageView.contentMode = .center
        imageView.isHidden = true

        return imageView
    }()

    lazy var nightTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 12)

        return label
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

    init() {
        super.init(frame: CGRect.zero)

        self.addSubviewsAndConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviewsAndConstraints() {
        self.addSubview(self.aboveHorizonLayoutView)
        self.aboveHorizonLayoutView.addSubview(self.horizon)
        self.aboveHorizonLayoutView.addSubview(self.sun)
        self.aboveHorizonLayoutView.addSubview(self.moon)
        self.addSubview(self.sunriseLabel)
        self.addSubview(self.sunsetLabel)
        self.addSubview(self.dayTimeLabel)
        self.addSubview(self.nightTimeLabel)

        self.aboveHorizonLayoutView.edgesToSuperview(insets: .top(24) + .bottom(24))

        let labelWidth = CGFloat(35.0)

        self.sunriseLabel.bottom(to: self)
        self.sunriseLabel.left(to: self)
        self.sunriseLabel.size(CGSize(width: labelWidth, height: 16))

        self.sunsetLabel.bottom(to: self)
        self.sunsetLabel.right(to: self)
        self.sunsetLabel.size(CGSize(width: labelWidth, height: 16))

        sunViewLeftAnchor = self.sun.left(to: self)
        sunViewBottomAnchor = self.sun.bottom(to: aboveHorizonLayoutView)
        self.sun.size(CGSize(width: SunView.sunSize, height: SunView.sunSize))

        self.moon.size(CGSize(width: SunView.sunSize * 0.5, height: SunView.sunSize))
        self.moon.top(to: self, offset: 24)
        self.moon.centerX(to: self)

        self.horizon.left(to: self)
        self.horizon.bottom(to: self.aboveHorizonLayoutView)
        self.horizon.right(to: self)
        self.horizon.height(1)

        self.dayTimeLabel.bottomToTop(of: self.sun, offset: -8)
        self.dayTimeLabel.centerX(to: self.sun)
        self.dayTimeLabel.size(CGSize(width: labelWidth, height: 16))

        self.nightTimeLabel.bottomToTop(of: self.moon, offset: -8)
        self.nightTimeLabel.centerX(to: self.moon)
        self.nightTimeLabel.size(CGSize(width: labelWidth, height: 16))
    }

    func location(for percentageInDay: CGFloat) -> SunViewLocation {
        let position = CGFloat.pi + (percentageInDay * CGFloat.pi)
        let x = 50.0 + cos(position) * 50.0
        let y = abs(sin(position) * 100.0)
        let absoluteX = ((self.bounds.width - SunView.sunSize) / 100) * x
        let absoluteY = -(self.aboveHorizonLayoutView.frame.height / 100.0) * y + SunView.sunSize

        return SunViewLocation(x: absoluteX, y: absoluteY)
    }

    func updateInterface(controller: DaylightModelController) {
        self.superview?.backgroundColor = controller.primaryColor
        self.backgroundColor = controller.primaryColor
        self.sunriseLabel.textColor = controller.secondaryColor
        self.sunsetLabel.textColor = controller.secondaryColor
        self.dayTimeLabel.textColor = controller.secondaryColor
        self.nightTimeLabel.textColor = controller.secondaryColor
        self.horizon.backgroundColor = controller.secondaryColor
        self.sun.tintColor = controller.secondaryColor
        self.moon.tintColor = controller.secondaryColor

        self.sunViewLocation = self.location(for: controller.percentageInDay)
        self.moon.isHidden = !controller.shouldShowMoon
        self.nightTimeLabel.isHidden = !controller.shouldShowMoon
        self.sun.isHidden = controller.shouldShowMoon
        self.dayTimeLabel.isHidden = !controller.shouldShowTimeLabel

        self.dayTimeLabel.text = controller.currentTimeString
        self.nightTimeLabel.text = controller.currentTimeString
        self.sunriseLabel.text = controller.sunriseTimeString
        self.sunsetLabel.text = controller.sunsetTimeString

        self.sunViewLeftAnchor?.constant = self.sunViewLocation.x
        self.sunViewBottomAnchor?.constant = self.sunViewLocation.y

        self.setNeedsLayout()
    }
}
