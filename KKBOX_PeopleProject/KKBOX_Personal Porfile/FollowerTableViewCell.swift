//
//  FollowerTableViewCell.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/24.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Haneke

class FollowerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var followerImageView: UIImageView!
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
        self.followerImageView.layer.cornerRadius = self.followerImageView.bounds.size.width/2
        self.followerImageView.clipsToBounds = true
    }
    
    func configCell(follower: [String:String]) {
        let imageString = follower["imageURL"]
        let imageURL = NSURL(string: imageString!)
        
        self.nameLabel.text = follower["name"]
        self.followerImageView.hnk_setImageFromURL(imageURL!)
    }
}
