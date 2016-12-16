import UIKit
import CoreLocation

class SunView: UIView {

    static let sunSize = CGFloat(16.0)

    var sunLocation = (x: CGFloat(0.0), y: CGFloat(0.0)) {
        didSet{
            self.sunLeftAnchor = self.sun.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.sunLocation.x)
            self.sunTopAnchor = self.sun.topAnchor.constraint(equalTo: self.topAnchor, constant: self.sunLocation.y)
            self.currentTimeBottomAnchor = self.currentTimeLabel.bottomAnchor.constraint(equalTo: self.sun.topAnchor, constant: -8)
            self.setNeedsLayout()
        }
    }

    var sunLeftAnchor: NSLayoutConstraint?
    var sunTopAnchor: NSLayoutConstraint?
    var currentTimeBottomAnchor: NSLayoutConstraint?

    lazy var sunriseLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .light(size: 12)

        return label
    }()

    lazy var sunsetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .light(size: 12)
        label.textAlignment = .right

        return label
    }()

    lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .light(size: 12)

        return label
    }()

    lazy var sun: UIView = {
        let view = UIView()
        view.layer.cornerRadius = sunSize * 0.5
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var horizon: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()


    override init(frame: CGRect){
        super.init(frame: frame)

        self.addSubviewsAndConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviewsAndConstraints() {
        self.addSubview(self.horizon)
        self.addSubview(self.sunriseLabel)
        self.addSubview(self.sunsetLabel)
        self.addSubview(self.sun)
        self.addSubview(self.currentTimeLabel)

        self.horizon.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.horizon.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.horizon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24).isActive = true
        self.horizon.heightAnchor.constraint(equalToConstant: 1).isActive = true

        self.sunriseLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.sunriseLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.sunriseLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        self.sunriseLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true

        self.sunsetLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.sunsetLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.sunsetLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        self.sunsetLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true

        self.sun.widthAnchor.constraint(equalToConstant: SunView.sunSize).isActive = true
        self.sun.heightAnchor.constraint(equalToConstant: SunView.sunSize).isActive = true
        self.sunLeftAnchor = self.sun.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.sunLocation.x)
        self.sunTopAnchor = self.sun.topAnchor.constraint(equalTo: self.topAnchor, constant: self.sunLocation.y)

        self.sunLeftAnchor?.isActive = true
        self.sunTopAnchor?.isActive = true

        self.currentTimeLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        self.currentTimeLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true
        self.currentTimeLabel.centerXAnchor.constraint(equalTo: self.sun.centerXAnchor).isActive = true
        self.currentTimeBottomAnchor = self.currentTimeLabel.bottomAnchor.constraint(equalTo: self.sun.topAnchor, constant: -8)

        self.currentTimeBottomAnchor?.isActive = true
    }

    func update(for placemark: CLPlacemark) {
        self.currentTimeLabel.text = APIClient.timeFormatter.string(from: Date())
        self.sunriseLabel.text = APIClient.sunriseTimeString(for: placemark)
        self.sunsetLabel.text = APIClient.sunsetTimeString(for: placemark)

        self.sunLocation = APIClient.sunLocation(for: placemark)
    }

    func updateInterface(withColor color: UIColor) {
        self.sunriseLabel.textColor = color
        self.sunsetLabel.textColor = color
        self.currentTimeLabel.textColor = color
        self.horizon.backgroundColor = color
        self.sun.backgroundColor = color
    }
}