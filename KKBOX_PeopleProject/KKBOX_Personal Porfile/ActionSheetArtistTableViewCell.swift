//
//  ActionSheetArtistTableViewCell.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/10/24.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class ActionSheetArtistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var viceNameLabel: UILabel!
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
        self.backgroundColor = UIColor.blackColor()
        self.nameLabel.textColor = UIColor.whiteColor()
    }
    
    override func drawRect(rect: CGRect) {
        self.photoImageView.layer.cornerRadius = self.photoImageView.bounds.width/2
        self.photoImageView.clipsToBounds = true
    }
    
    func configCell(song: Song) {
        let imageURLString = song.album?.artist?.imageURL
        let imageURL = NSURL(string: imageURLString!)
        
        self.photoImageView.hnk_setImageFromURL(imageURL!)
        self.viceNameLabel.text = "藝人"
        self.nameLabel.text = song.songArtistName
    }

}
