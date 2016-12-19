import UIKit
import CoreLocation

class SunView: UIView {

    static let sunSize = CGFloat(16.0)

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

        self.sunriseLabel.frame = CGRect(x: 0, y: 108, width: 33, height: 16)
        self.sunsetLabel.frame = CGRect(x: self.bounds.width - 33, y: 108, width: 33, height: 16)
        self.sun.frame = CGRect(x: self.sunLocation.x, y: self.sunLocation.y, width: SunView.sunSize, height: SunView.sunSize)
        self.sunMask.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 108)
        self.horizon.frame = CGRect(x: 0, y: 108, width: self.bounds.width, height: 1)
        self.currentTimeLabel.frame = CGRect(x: self.sunLocation.x - 10, y: self.sunLocation.y - 24, width: 33, height: 16)
    }

    func addSubviewsAndConstraints() {
        self.addSubview(self.horizon)
        self.addSubview(self.sunriseLabel)
        self.addSubview(self.sunsetLabel)
        self.addSubview(self.sunMask)
        self.sunMask.addSubview(self.sun)
        self.addSubview(self.currentTimeLabel)
    }

    func update(for location: Location) {
        self.currentTimeLabel.text = APIClient.timeFormatter.string(from: Date())
        self.sunriseLabel.text = APIClient.sunriseTimeString(for: location.coordinate)
        self.sunsetLabel.text = APIClient.sunsetTimeString(for: location.coordinate)

        self.sunLocation = APIClient.sunLocation(for: location.coordinate)
    }

    func updateInterface(withColor color: UIColor) {
        self.sunriseLabel.textColor = color
        self.sunsetLabel.textColor = color
        self.currentTimeLabel.textColor = color
        self.horizon.backgroundColor = color
        self.sun.backgroundColor = color
    }
}
