import UIKit

class CloseButton: InformationButton {
    lazy var maskForHalfMoonView: UIView = {
        let view = UIView(withAutoLayout: true)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        nameLabel.text = NSLocalizedString("Close", comment: "")
        self.addSubviewsAndConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addSubviewsAndConstraints() {
        super.addSubviewsAndConstraints()

        self.addSubview(self.maskForHalfMoonView)

        self.maskForHalfMoonView.widthAnchor.constraint(equalToConstant: InformationButton.sunSize / 2).isActive = true
        self.maskForHalfMoonView.heightAnchor.constraint(equalToConstant: InformationButton.sunSize).isActive = true
        self.maskForHalfMoonView.topAnchor.constraint(equalTo: self.sun.topAnchor).isActive = true
        self.maskForHalfMoonView.rightAnchor.constraint(equalTo: self.sun.rightAnchor).isActive = true
    }

    override func updateInterface(controller: DaylightModelController) {
        super.updateInterface(controller: controller)

        self.maskForHalfMoonView.backgroundColor = controller.primaryColor
    }
}
