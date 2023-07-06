//
//  Constant.swift
//  BombSide
//
//  Created by Andy on 2017/5/18.
//  Copyright © 2017年 com.andy. All rights reserved.
//

import Foundation
import UIKit

struct ScreenSize {
    static var width  = UIScreen.main.bounds.width
    static var height = UIScreen.main.bounds.height
}

extension UIColor {
    
    var redInt: Int{ return Int(255 * self.cgColor.components![0]) }
    var greenInt: Int{ return Int(255 * self.cgColor.components![1]) }
    var blueInt: Int{ return Int(255 * self.cgColor.components![2]) }
    var alpha: CGFloat{ return self.cgColor.components![3] }
}
