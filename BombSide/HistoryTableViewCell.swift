//
//  HistoryTableViewCell.swift
//  BombSide
//
//  Created by Andy on 2017/6/1.
//  Copyright © 2017年 com.andy. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var mShitView: ShitView!
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
