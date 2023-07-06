//
//  ShitView.swift
//  BombSide
//
//  Created by Andy on 2017/4/21.
//  Copyright © 2017年 com.andy. All rights reserved.
//

import UIKit




@IBDesignable class ShitView: UIView, CAAnimationDelegate{
    
    let layerAnimate = CAShapeLayer()
    
    var mColor: UIColor = UIColor.brown{
        didSet{
            self.layerAnimate.fillColor = mColor.cgColor
            self.layerAnimate.strokeColor = mColor.cgColor
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        addLayer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLayer()
        self.backgroundColor = UIColor.clear
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        addLayer()
    }
    
    func addLayer()  {
        self.layerAnimate.frame = self.bounds
        self.layerAnimate.path = getShitPath().cgPath
        self.layerAnimate.backgroundColor = UIColor.clear.cgColor
        self.layerAnimate.lineWidth = 3.0
        self.layerAnimate.fillColor = mColor.cgColor
        self.layerAnimate.strokeColor = mColor.cgColor
        
        self.layer.addSublayer(layerAnimate)
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    
    func getShitPath() -> UIBezierPath {
        let path: UIBezierPath = UIBezierPath()
        print(self.bounds)
        let leftX  = bounds.width * 0.35
        let rightX = bounds.width * 0.65
        
        let sYDis = (bounds.height - 16) / 9.0 * 2.0
        let bYDis = (bounds.height - 16) / 9.0 * 3.0
        
        print(sYDis)
        path.move(to: CGPoint(x: leftX, y: 8 + sYDis))
        // Top curve
        path.addQuadCurve(to: CGPoint(x: rightX, y: 8 + sYDis), controlPoint: CGPoint(x: bounds.width / 2, y: -10))
        // Right curve
        path.addCurve(to: CGPoint(x: rightX, y: 8 + (sYDis * 2)),
                      controlPoint1: CGPoint(x: bounds.width * 0.9, y: 8 + sYDis * 0.8 ),
                      controlPoint2: CGPoint(x: bounds.width * 0.9, y: 8 + sYDis * 2.2))
        path.addCurve(to: CGPoint(x: rightX, y: 8 + (sYDis * 3)),
                      controlPoint1: CGPoint(x: bounds.width * 0.95, y: 8 + sYDis * 1.8 ),
                      controlPoint2: CGPoint(x: bounds.width * 0.95, y: 8 + sYDis * 3.2))
        path.addCurve(to: CGPoint(x: rightX, y: 8 + (sYDis * 3) + bYDis),
                      controlPoint1: CGPoint(x: bounds.width * 1, y: 8 + sYDis * 2.8 + bYDis * 0.0 ),
                      controlPoint2: CGPoint(x: bounds.width * 1, y: 8 + sYDis * 3 + bYDis * 1.1))
        
        // Bottom line
        path.addLine(to: CGPoint(x: leftX, y: 8 + sYDis * 3 + bYDis ))
        
        // Left curve
        path.addCurve(to: CGPoint(x: leftX, y: 8 + (sYDis * 3)),
                      controlPoint1: CGPoint(x: 0, y: 8 + sYDis * 3 + bYDis * 1.1 ),
                      controlPoint2: CGPoint(x: 0, y: 8 + sYDis * 2.8 + bYDis * 0.0))
        path.addCurve(to: CGPoint(x: leftX, y: 8 + (sYDis * 2)),
                      controlPoint1: CGPoint(x: bounds.width * 0.05, y: 8 + sYDis * 3.2),
                      controlPoint2: CGPoint(x: bounds.width * 0.05, y: 8 + sYDis * 1.8))
        path.addCurve(to: CGPoint(x: leftX, y: 8 + sYDis),
                      controlPoint1: CGPoint(x: bounds.width * 0.1, y: 8 + sYDis * 2.2 ),
                      controlPoint2: CGPoint(x: bounds.width * 0.1, y: 8 + sYDis * 0.8))
        path.close()
        
//        path.stroke()
        
//        path.fill()
        
        return path
    }
    
    func startAnimate() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.0000
        animation.fromValue = 0
        animation.toValue = 1.0
        
        let animation2 = CABasicAnimation(keyPath: "strokeStart")
        animation2.duration = 1.0000
        animation2.fromValue = 0
        animation2.toValue = 1.0
        animation2.fillMode = CAMediaTimingFillMode.forwards
        animation2.beginTime =  1.50
        
        
        let group = CAAnimationGroup()
        group.animations = [animation]
        group.duration = 3.0000
        group.repeatCount = .infinity
        group.delegate = self
        
        let group2 = CAAnimationGroup()
        group2.animations = [animation2]
        group2.duration = 3.0000
        group2.repeatCount = .infinity
        
        self.layerAnimate.add(group, forKey: "gg")
        self.layerAnimate.add(group2, forKey: "ggg")
    }
    
    
    
    func setColor(color: UIColor) {
        mColor = color
    }

}
