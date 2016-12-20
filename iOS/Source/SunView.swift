import UIKit
import CoreLocation

class SunView: UIView {

    static let sunSize = Double(16.0)

    var isNight = false {
        didSet {
            if self.isNight {
                self.moon.isHidden = false
                self.sunLocation = (x: Double((self.frame.width - CGFloat(SunView.sunSize)) / CGFloat(2)), y: Double(CGFloat(0)))
            } else {
                self.moon.isHidden = true
            }
        }
    }

    var sunLocation = (x: Double(0.0), y: Double(0.0)) {
        didSet{
            self.setNeedsLayout()
        }
    }

    var sunLeftAnchor: NSLayoutConstraint?
    var sunTopAnchor: NSLayoutConstraint?
    var currentTimeBottomAnchor: NSLayoutConstraint?

    lazy var sunriseLabel: UILabel = {
       let label = UILabel()
        label.font = .light(size: 12)

        return label
    }()

    lazy var sunsetLabel: UILabel = {
        let label = UILabel()
        label.font = .light(size: 12)
        label.textAlignment = .right

        return label
    }()

    lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center


        label.font = .light(size: 12)

        return label
    }()

    lazy var sun: UIView = {
        let view = UIView()
        view.layer.cornerRadius = CGFloat(sunSize * 0.5)

        return view
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
        shortTimeFormatter.dateFormat = "hh:mm"

        return shortTimeFormatter
    }()

    override init(frame: CGRect){
        super.init(frame: frame)

        self.addSubviewsAndConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews(){
        super.layoutSubviews()

        // TODO: check if the view layout is also possible using constraints
        self.sunriseLabel.frame = CGRect(x: 0, y: 108, width: 33, height: 16)
        self.sunsetLabel.frame = CGRect(x: self.bounds.width - 33, y: 108, width: 33, height: 16)
        self.sun.frame = CGRect(x: self.sunLocation.x, y: self.sunLocation.y, width: SunView.sunSize, height: SunView.sunSize)
        self.sunMask.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 108)
        self.horizon.frame = CGRect(x: 0, y: 108, width: self.bounds.width, height: 1)
        self.currentTimeLabel.frame = CGRect(x: self.sunLocation.x - 10, y: self.sunLocation.y - 24, width: 33, height: 16)
        self.moon.frame = CGRect(x: self.sunLocation.x + (SunView.sunSize / 2), y: self.sunLocation.y, width: SunView.sunSize / 2, height: SunView.sunSize)
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

    func location(for percentageInDay: Double) -> (Double, Double) {
        let position = Double.pi + (percentageInDay * Double.pi)
        //TODO: Check these numbers and make them work right
        let x = (50.0 + cos(position) * 50.0)
        let y = (abs(sin(position) * 100.0))

        let absoluteX =  ((self.bounds.width - CGFloat(SunView.sunSize)) / 100) * CGFloat(x)
        let absoluteY  = Double(self.sunMask.frame.height) - ((Double(self.sunMask.frame.height) / 100.0) * y)

        return (Double(absoluteX), Double(absoluteY))
    }

    func updateInterface(withBackgroundColor backgroundColor: UIColor, textColor: UIColor, andPercentageInDay percentageInDay: Double, isNight: Bool) {
        self.sunriseLabel.textColor = textColor
        self.sunsetLabel.textColor = textColor
        self.currentTimeLabel.textColor = textColor
        self.horizon.backgroundColor = textColor
        self.sun.backgroundColor = textColor
        self.moon.backgroundColor = backgroundColor

        self.sunLocation = self.location(for: percentageInDay)
        self.isNight = isNight
    }
}
