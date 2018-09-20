import UIKit
import PlaygroundSupport
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
        label.font = UIFont.systemFont(ofSize: 12)

        return label
    }()

    lazy var sunsetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
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

        self.aboveHorizonLayoutView.backgroundColor = .white
        self.aboveHorizonLayoutView.edgesToSuperview(insets: .bottom(24) + .top(24))

        let labelWidth = CGFloat(35.0)

        self.sunriseLabel.bottom(to: self)
        self.sunriseLabel.left(to: self)
        self.sunriseLabel.size(CGSize(width: labelWidth, height: 16))

        self.sunsetLabel.bottom(to: self)
        self.sunsetLabel.right(to: self)
        self.sunsetLabel.size(CGSize(width: labelWidth, height: 16))

        sunViewLeftAnchor = self.sun.left(to: self)
        sunViewBottomAnchor = self.sun.bottom(to: aboveHorizonLayoutView)
        sun.size(CGSize(width: SunView.sunSize, height: SunView.sunSize))

        self.moon.size(CGSize(width: SunView.sunSize * 0.5, height: SunView.sunSize))
        self.moon.top(to: self, offset: 24)
        self.moon.centerX(to: self)

        self.horizon.left(to: self)
        self.horizon.bottom(to: aboveHorizonLayoutView)
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

    func updateInterface(daylightModelController: DaylightModelController) {
        self.superview?.backgroundColor = daylightModelController.primaryColor
        self.backgroundColor = daylightModelController.primaryColor
        self.sunriseLabel.textColor = daylightModelController.secondaryColor
        self.sunsetLabel.textColor = daylightModelController.secondaryColor
        self.dayTimeLabel.textColor = daylightModelController.secondaryColor
        self.nightTimeLabel.textColor = daylightModelController.secondaryColor
        self.horizon.backgroundColor = daylightModelController.secondaryColor
        self.sun.tintColor = daylightModelController.secondaryColor
        self.moon.tintColor = daylightModelController.secondaryColor

        self.sunViewLocation = self.location(for: daylightModelController.percentageInDay)
        self.moon.isHidden = !daylightModelController.shouldShowMoon
        self.nightTimeLabel.isHidden = !daylightModelController.shouldShowMoon
        self.sun.isHidden = daylightModelController.shouldShowMoon
        self.dayTimeLabel.isHidden = !daylightModelController.shouldShowTimeLabel

        self.dayTimeLabel.text = daylightModelController.currentTimeString
        self.nightTimeLabel.text = daylightModelController.currentTimeString
        self.sunriseLabel.text = daylightModelController.sunriseTimeString
        self.sunsetLabel.text = daylightModelController.sunsetTimeString

        self.sunViewLeftAnchor?.constant = self.sunViewLocation.x
        self.sunViewBottomAnchor?.constant = self.sunViewLocation.y

        self.setNeedsLayout()
    }
}

class SunSliderView : UIView {
    let date = SunTime.dateFormatter.date(from: "2018-09-18 00:00:47+0000")!

    let sunView = SunView()
    let slider = UISlider()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(sunView)
        sunView.height(133)
        sunView.edgesToSuperview(excluding: .bottom, insets: .top(50) + .left(50) + .right(50) + .bottom(150))

        slider.addTarget(self, action: #selector(slide), for: .touchDragInside)
        slider.minimumValue = 0
        slider.maximumValue = 24

        self.addSubview(slider)
        slider.topToBottom(of: sunView)
        slider.edges(to: self, excluding: .top)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func slide() {
        let newDate = date.addingTimeInterval(Double(slider.value * 3600))
        let sunTime = SunTime(date: newDate)
        sunView.updateInterface(daylightModelController: DaylightModelController(sunTime: sunTime))
    }
}

let sunSliderView = SunSliderView(frame: CGRect(x: 0, y: 0, width: 495, height: 357))
sunSliderView.backgroundColor = .white

PlaygroundPage.current.liveView = sunSliderView

