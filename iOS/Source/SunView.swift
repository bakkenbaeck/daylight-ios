import CoreLocation
import UIKit

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

    private var controller: DaylightModelController

    init(withController controller: DaylightModelController) {
        self.controller = controller
        super.init(frame: CGRect.zero)

        self.controller.delegate = self

        self.addSubviewsAndConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let labelWidth = CGFloat(35.0)

//        self.sunMask.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 108)
        self.moon.frame = CGRect(x: self.sunViewLocation.x + (SunView.sunSize / 2), y: self.sunViewLocation.y, width: SunView.sunSize / 2, height: SunView.sunSize)
    }

    func addSubviewsAndConstraints() {
        self.addSubview(self.horizon)
        self.addSubview(self.sunriseLabel)
        self.addSubview(self.sunsetLabel)
        self.addSubview(self.sun)
        self.addSubview(self.currentTimeLabel)

        self.addSubview(self.sunMask)
        self.sunMask.addSubview(self.moon)

        let labelWidth = CGFloat(35.0)

        self.sunriseLabel.bottom(to: self)
        self.sunriseLabel.left(to: self)
        self.sunriseLabel.size(CGSize(width: labelWidth, height: 16))

        self.sunsetLabel.bottom(to: self)
        self.sunsetLabel.right(to: self)
        self.sunsetLabel.size(CGSize(width: labelWidth, height: 16))

        sunViewLeftAnchor = self.sun.left(to: self)
        sunViewBottomAnchor = self.sun.bottom(to: horizon)
        sun.size(CGSize(width: SunView.sunSize, height: SunView.sunSize))

        self.horizon.left(to: self)
        self.horizon.bottom(to: self, offset: -24)
        self.horizon.right(to: self)
        self.horizon.height(1)

        self.currentTimeLabel.bottomToTop(of: self.sun, offset: -8)
        self.currentTimeLabel.centerX(to: self.sun)
        self.currentTimeLabel.size(CGSize(width: labelWidth, height: 16))
    }

    override open var bounds: CGRect  {
        didSet {
            self.updateInterface(controller: self.controller)
        }
    }

    func location(for percentageInDay: CGFloat) -> SunViewLocation {
        let position = CGFloat.pi + (percentageInDay * CGFloat.pi)
        let x = 50.0 + cos(position) * 50.0
        let y = abs(sin(position) * 100.0)
        let absoluteX = ((self.bounds.width - SunView.sunSize) / 100) * x
        let absoluteY = -(108 / 100.0) * y

        return SunViewLocation(x: absoluteX, y: absoluteY)
    }

    func updateInterface(controller: DaylightModelController) {
        self.sunriseLabel.textColor = controller.secondaryColor
        self.sunsetLabel.textColor = controller.secondaryColor
        self.currentTimeLabel.textColor = controller.secondaryColor
        self.horizon.backgroundColor = controller.secondaryColor
        self.sun.tintColor = controller.secondaryColor
        self.moon.backgroundColor = controller.primaryColor

        self.sunViewLocation = self.location(for: controller.percentageInDay)
        self.sunViewLocation = self.location(for: 0.0)
//        if controller.shouldShowMoon {
//            self.moon.isHidden = false
//            self.sunViewLocation = SunViewLocation(x: (self.frame.width - SunView.sunSize) / 2.0, y: 0.0)
//        }
        self.currentTimeLabel.isHidden = controller.shouldShowTimeLabel

        self.currentTimeLabel.text = self.timeFormatter.string(from: Date())
        self.sunriseLabel.text = controller.sunriseTimeString
        self.sunsetLabel.text = controller.sunsetTimeString

        self.sunViewLeftAnchor?.constant = self.sunViewLocation.x
        self.sunViewBottomAnchor?.constant = self.sunViewLocation.y

        self.setNeedsLayout()
    }
}

extension SunView: DaylightModelControllerDelegate {
    func daylightModelControllerDidUpdate(_ controller: DaylightModelController) {
        self.updateInterface(controller: controller)
    }
}