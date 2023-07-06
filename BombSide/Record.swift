//
//  Record.swift
//  BombSide
//
//  Created by Andy on 2017/5/24.
//  Copyright © 2017年 com.andy. All rights reserved.
//

import Foundation
import UIKit

struct Record {
    var id: Int
    var placeID: Int
    var time: TimeInterval{
        didSet{
            print("time \(time)")
            self.date = Date(timeIntervalSinceReferenceDate: time)
        }
    }
    var date: Date
    var water: Int
    var smell: Int
    var amount: Int
    var color: UIColor
    
    var place: Place
    
}

extension Record{
    func description() -> String {
        return "Id: \(id) Place ID: \(placeID) Date: \(date)"
    }
}
