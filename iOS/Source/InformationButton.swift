import UIKit

class InformationButton: UIButton {
    static let sunSize = CGFloat(18.0)

    lazy var sun: UIImageView = {
        let image = UIImage(named: "sun")!
        let tintImage = image.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: tintImage)
        imageView.alpha = 0.6
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.light(size: 16)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.nameLabel.text = NSLocalizedString("About Daylight", comment: "")
        self.addSubviewsAndConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviewsAndConstraints() {
        self.addSubview(self.sun)
        self.addSubview(self.nameLabel)

        self.sun.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40).isActive = true
        self.sun.centerYAnchor.constraint(equalTo: self.nameLabel.centerYAnchor).isActive = true
        self.sun.widthAnchor.constraint(equalToConstant: InformationButton.sunSize).isActive = true
        self.sun.heightAnchor.constraint(equalToConstant: InformationButton.sunSize).isActive = true

        self.nameLabel.leftAnchor.constraint(equalTo: self.sun.rightAnchor, constant: 8).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        self.nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -40).isActive = true
        self.nameLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }

    func updateInterface(controller: DaylightModelController) {
        self.sun.tintColor = controller.secondaryColor.withAlphaComponent(0.6)
        self.nameLabel.textColor = controller.secondaryColor.withAlphaComponent(0.6)
    }
}
