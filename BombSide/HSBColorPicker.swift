//
//  ColorPickerView.swift
//  BombSide
//
//  Created by Andy on 2017/4/14.
//  Copyright © 2017年 com.andy. All rights reserved.
//

import Foundation
import UIKit


internal protocol HSBColorPickerDelegate : NSObjectProtocol {
    func HSBColorColorPickerTouched(sender:HSBColorPicker, color:UIColor, point:CGPoint, state:UIGestureRecognizer.State)
    func HSBColorPickerChangedColor(sender:HSBColorPicker, color:UIColor)
}

@IBDesignable
class HSBColorPicker : UIView {
    
    weak internal var delegate: HSBColorPickerDelegate?
    let saturationExponentTop:Float = 2.0
    let saturationExponentBottom:Float = 1.3
    
    @IBInspectable var elementSize: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private func initialize() {
        self.clipsToBounds = true
//        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(touchedColor(gestureRecognizer:)))
//        touchGesture.minimumPressDuration = 0
//        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
//        self.addGestureRecognizer(touchGesture)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        //oringin
//        for y in stride(from:0, to: rect.height, by: elementSize) {
//            
//            var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : 2.0 * CGFloat(rect.height - y) / rect.height
//            saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
//            let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height
//            
//            for x in stride(from:0, to: rect.width, by: elementSize) {
//                let hue = x / rect.width
//                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
//                context!.setFillColor(color.cgColor)
//                context!.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
//            }
//        }
        
        let all = rect.height + rect.width
        
        for y in stride(from:0, to: rect.height, by: elementSize) {
            
            
            
            for x in stride(from:0, to: rect.width, by: elementSize) {
                
                let color = getColorFromXY(x: x, y: y)
                
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
            }
        }
    }
    
    func getColorAtPoint(point:CGPoint) -> UIColor {
//        let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
//                                   y:elementSize * CGFloat(Int(point.y / elementSize)))
//        var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height
//            : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
//        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
//        let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
//        let hue = roundedPoint.x / self.bounds.width
//        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        
        let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                                   y:elementSize * CGFloat(Int(point.y / elementSize)))
        
        return getColorFromXY(x: roundedPoint.x, y: roundedPoint.y)
        
    }
    
    func getColorFromXY(x:CGFloat, y:CGFloat) -> UIColor {
        let green = 0.5 * (x / self.bounds.width) + 0.1    //0.2~0.7
        let red   = 0.7 * (y / self.bounds.height)  + 0.2  //0.2~0.9
        let blue  = 40.0  * (x+y) / (self.bounds.width + self.bounds.height)

        
        let color = UIColor(red: red, green: green, blue: blue/255.0, alpha: 1.0);
        return color
    }
    func getPointForColor(color:UIColor) -> CGPoint {
        var hue:CGFloat=0;
        var saturation:CGFloat=0;
        var brightness:CGFloat=0;
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
        
        var yPos:CGFloat = 0
        let halfHeight = (self.bounds.height / 2)
        
        if (brightness >= 0.99) {
            let percentageY = powf(Float(saturation), 1.0 / saturationExponentTop)
            yPos = CGFloat(percentageY) * halfHeight
        } else {
            //use brightness to get Y
            yPos = halfHeight + halfHeight * (1.0 - brightness)
        }
        
        let xPos = hue * self.bounds.width
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touch move")
        if let touch = touches.first{
            let end  = touch.location(in: self)
            if self.bounds.contains(end){
                print("point : \(end)")
                let color = getColorAtPoint(point: end)
                print(color)
                self.delegate?.HSBColorPickerChangedColor(sender: self, color: color)
            }
            
        }
    }
    
    
    
    func touchedColor(gestureRecognizer: UILongPressGestureRecognizer){
        let point = gestureRecognizer.location(in: self)
        let color = getColorAtPoint(point: point)
        
        self.delegate?.HSBColorColorPickerTouched(sender: self, color: color, point: point, state:gestureRecognizer.state)
    }
}
