//
//  MusicStyleTableViewCell.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/10/24.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Haneke

protocol StyleMoreButtonDelegate {
    func cellMoreButtonTapped(cell: MusicStyleTableViewCell)
}

class MusicStyleTableViewCell: UITableViewCell {

    @IBOutlet weak var ratingNumberLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    var buttonDelegate: StyleMoreButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configCell(song: Song) {
        let imageURL = NSURL(string: (song.album?.imageURL)!)
        
        self.albumImageView.hnk_setImageFromURL(imageURL!)
        self.songLabel.text = song.songName
        self.artistLabel.text = song.album?.artist?.artistName
    }
    
    @IBAction func moreButtonTapped(sender: AnyObject) {
        if let delegate = buttonDelegate {
            delegate.cellMoreButtonTapped(self)
        }
    }
    
}
