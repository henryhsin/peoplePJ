//
//  ActionSheetTableViewCell.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/10/21.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class ActionSheetTableViewCell: UITableViewCell {

    @IBOutlet weak var iconimageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPlayerMoreCellUI() {
        self.contentView.backgroundColor = UIColor.blackColor()
        self.nameLabel.textColor = UIColor.whiteColor()
    }
 
    func configCell(data: (String, String)) {
        let (imageName, name) = data
        
        self.iconimageView.image = UIImage(named: imageName)
        self.nameLabel.text = name
    }
}
