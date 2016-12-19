import UIKit
import CoreLocation

class SunView: UIView {

    static let sunSize = CGFloat(16.0)

    var percentageInDay = CGFloat(0.0)

    var nightState = false {
        didSet {
            if self.nightState {
                self.moon.isHidden = false
                self.sunLocation = (x: (self.frame.width - SunView.sunSize)/2, y: 0)
            } else {
                self.moon.isHidden = true
            }
        }
    }

    var sunLocation = (x: CGFloat(0.0), y: CGFloat(0.0)) {
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
        view.layer.cornerRadius = sunSize * 0.5

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
        self.currentTimeLabel.text = APIClient.timeFormatter.string(from: Date())
        self.sunriseLabel.text = APIClient.sunriseTimeString(for: location.coordinate)
        self.sunsetLabel.text = APIClient.sunsetTimeString(for: location.coordinate)
    }

    func location(for percentageInDay: CGFloat) -> (CGFloat, CGFloat) {
        let position = CGFloat.pi + (percentageInDay * CGFloat.pi)
        //TODO: Check these numbers and make them work right
        let x = ((self.bounds.width - SunView.sunSize) / 2) + cos(position) * ((self.bounds.width - SunView.sunSize) / 2)
        let y = 100 - (abs(sin(position) * 100))
        print("x = \(x), y = \(y)")

        return (x,y)
    }

    func updateInterface(withBackGroundColor backgroundColor: UIColor, andTextColor textColor: UIColor) {
        self.sunriseLabel.textColor = textColor
        self.sunsetLabel.textColor = textColor
        self.currentTimeLabel.textColor = textColor
        self.horizon.backgroundColor = textColor
        self.sun.backgroundColor = textColor
        self.moon.backgroundColor = backgroundColor

        //TODO: get real percentage in day from Location managare
        self.percentageInDay = self.percentageInDay + 0.05
        if self.percentageInDay >= 0 && self.percentageInDay <= 1 {
            self.sunLocation = self.location(for: self.percentageInDay)
            self.nightState = false
        } else {
            self.nightState = true
        }
    }
}
