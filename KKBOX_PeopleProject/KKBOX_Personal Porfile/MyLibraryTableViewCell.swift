//
//  MyLibraryTableViewCell.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/10/11.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class MyLibraryTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
