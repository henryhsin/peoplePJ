//
//  ActionSheetAlbumTableViewCell.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/10/21.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class ActionSheetAlbumTableViewCell: UITableViewCell {
    
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
    
    func configCell(song: Song) {
        let imageURLString = song.album?.imageURL
        let imageURL = NSURL(string: imageURLString!)
        
        self.photoImageView.hnk_setImageFromURL(imageURL!)
        self.viceNameLabel.text = "專輯"
        self.nameLabel.text = song.songName
    }
}
