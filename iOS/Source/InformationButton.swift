import UIKit

class InformationButton: UIButton {
    static let sunSize = CGFloat(16.0)

    lazy var sun: UIView = {
        let view = UIView()
        view.layer.cornerRadius = sunSize * 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false

        return view
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .light(size: 12)

        return label
    }()

    override init(frame: CGRect){
        super.init(frame: frame)

        nameLabel.text = NSLocalizedString("Daylight", comment: "")
        self.addSubviewsAndConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviewsAndConstraints() {
        self.addSubview(self.sun)
        self.addSubview(self.nameLabel)

        self.sun.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40).isActive = true
        self.sun.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        self.sun.widthAnchor.constraint(equalToConstant: InformationButton.sunSize).isActive = true
        self.sun.heightAnchor.constraint(equalToConstant: InformationButton.sunSize).isActive = true

        self.nameLabel.leftAnchor.constraint(equalTo: self.sun.rightAnchor, constant: 8).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        self.nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -40).isActive = true
        self.nameLabel.heightAnchor.constraint(equalToConstant: 16)
    }

    func updateInterface(withBackgroundColor backgroundColor: UIColor, andTextColor textColor: UIColor) {
        self.sun.backgroundColor = textColor.withAlphaComponent(0.6)
        self.nameLabel.textColor = textColor.withAlphaComponent(0.6)
    }
}
