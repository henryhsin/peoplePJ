//
//  FollowingTableViewCell.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/24.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Haneke

class FollowingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var followingImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func drawRect(rect: CGRect) {
        self.followingImageView.layer.cornerRadius = self.followingImageView.bounds.size.width/2
        self.followingImageView.clipsToBounds = true
    }
    
    func configCell(following: [String:String]) {
        let imageString = following["imageURL"]
        let imageURL = NSURL(string: imageString!)
        
        self.nameLabel.text = following["name"]
        self.followingImageView.hnk_setImageFromURL(imageURL!)
    }
}
