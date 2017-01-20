import UIKit
import QuartzCore

class Sun: UIView {
    var circleColor = UIColor.clear {
        didSet {
            self.setNeedsDisplay()
        }
    }

    var sunBackgroundColor = UIColor.clear {
        didSet {
            self.setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: rect.width / 2, y: rect.width / 2), radius: CGFloat((rect.width - 2) / 2), startAngle: CGFloat(0), endAngle: CGFloat(M_PI * 2), clockwise: true)

        self.backgroundColor = self.sunBackgroundColor

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = self.circleColor.cgColor
        shapeLayer.magnificationFilter = kCAFilterNearest
        self.layer.addSublayer(shapeLayer)
    }
}
