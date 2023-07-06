//
//  Place.swift
//  BombSide
//
//  Created by Andy on 2017/5/23.
//  Copyright © 2017年 com.andy. All rights reserved.
//

import Foundation
import UIKit

struct Place {
    var id: Int?
    var name: String?
    var address: String?
    var lati: Double?
    var long: Double?
    
    var clean: Int?
    var smell: Int?
    var comfortable: Int?
    var count: Int?
    
    
    init?(json: [String: Any]) {
        guard let name = json["name"],
            let address = json["vicinity"],
            let geo = json["geometry"] as? [String: Any],
            let location = geo["location"] as? [String: Double],
            let lati = location["lat"],
            let long = location["lng"]
            else{
                return nil
        }
        self.name = name as? String
        self.address = address as? String
        self.lati = lati
        self.long = long
    }
    
    init(id: Int, name: String, address: String, lati: Double, long: Double, clean: Int, smell: Int, comfortable: Int) {
        self.id = id
        self.name = name
        self.address = address
        self.lati = lati
        self.long = long
        self.smell = smell
        self.clean = clean
        self.comfortable = comfortable
    }
    
}

extension Place{
    func description() -> String {
        return "Place id: \(id ?? -1) \n Name: \(name!) \n Address:\(address!) \n lati: \(lati!) long: \(long!) "
    }
}


