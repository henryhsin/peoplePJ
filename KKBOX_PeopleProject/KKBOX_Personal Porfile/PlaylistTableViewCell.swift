//
//  PlaylistTableViewCell.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tie Lin on 2016/8/27.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Haneke

class PlaylistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBOutlet weak var numberOfCollectedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configCell(playlist: Playlist) {
        let imageURLString = playlist.songs![0].album?.imageURL
        let imageURL = NSURL(string: imageURLString!)
        
        self.playlistImageView.hnk_setImageFromURL(imageURL!)
        self.playlistNameLabel.text = playlist.playlistName
    }
}
