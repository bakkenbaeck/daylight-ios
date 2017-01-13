import UIKit

class Sun: UIView {
    var circleColor = UIColor.clear {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: rect.width / 2, y: rect.width / 2), radius: CGFloat((rect.width - 2) / 2), startAngle: CGFloat(0), endAngle: CGFloat(M_PI * 2), clockwise: true)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = self.circleColor.cgColor
        self.layer.addSublayer(shapeLayer)
    }
}
