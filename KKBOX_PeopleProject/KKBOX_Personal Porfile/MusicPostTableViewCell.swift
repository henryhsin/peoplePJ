//
//  MusicPostTableViewCell.swift
//  KKBox_People_Project
//
//  Created by Chun Tie Lin on 2016/8/27.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

class MusicPostTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var musicImageView: UIImageView!
    @IBOutlet weak var commentHeaderView: CommentHeaderView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
