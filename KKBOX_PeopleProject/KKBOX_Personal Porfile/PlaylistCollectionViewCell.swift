//
//  PlaylistCollectionViewCell.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/23.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Haneke

protocol PlaylistPlayButtonDelegate {
    func playlistPlayButton(cell: UICollectionViewCell)
}

class PlaylistCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playlistLabel: UILabel!
    
    var buttonDelegate: PlaylistPlayButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.shadowColor = UIColor.blackColor().CGColor
        imageView.layer.shadowOffset = CGSizeMake(0, 2)
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowRadius = 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configCell(playlist: Playlist) {
        let imageURLString = playlist.songs![0].album?.imageURL
        let imageURL = NSURL(string: imageURLString!)
        
        self.imageView.hnk_setImageFromURL(imageURL!)
        self.playlistLabel.text = playlist.playlistName
    }
    
    @IBAction func playButtonTapped(sender: AnyObject) {
        if let delegate = buttonDelegate {
            delegate.playlistPlayButton(self)
        }

    }
    
}
