//
//  MainCheckCell.swift
//  Tutorial_001
//
//  Created by 위대연 on 2020/04/23.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class MainCheckCell: UITableViewCell {
    static let reuse_cell_id = "cell_id_check"
    
    @IBOutlet weak var timeImageView:UIImageView!
    @IBOutlet weak var checkTimeLabel:UILabel!
    
    override func prepareForReuse() {
        checkTimeLabel.text = ""
    }
    
/*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
*/
}
