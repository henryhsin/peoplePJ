//
//  MyPlaylistTableViewCell.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/10/14.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Haneke

class MyPlaylistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var playlistNameLabel: UILabel!
    
    
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
