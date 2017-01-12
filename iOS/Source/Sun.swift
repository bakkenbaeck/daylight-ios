//
//  Sun.swift
//  Project
//
//  Created by Marijn Schilling on 12/01/2017.
//
//

import UIKit

class Sun: UIView {
    var sunColor = UIColor.clear

    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: rect.width/2, y: rect.width/2), radius: CGFloat((rect.width - 2)/2), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = self.sunColor.cgColor
        self.layer.addSublayer(shapeLayer)
    }
}
