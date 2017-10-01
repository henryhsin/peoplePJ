//
//  ListSongTableViewCell.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/11/7.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Haneke

protocol ListSongMoreButtonDelegate {
    func cellMoreButtonTapped(cell: ListSongTableViewCell)
}

class ListSongTableViewCell: UITableViewCell {

    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    var buttonDelegate: ListSongMoreButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configPlaylistCell(song: Song) {
        
        if let imageURL = NSURL(string: (song.album?.imageURL)!) {
            self.songImageView.hnk_setImageFromURL(imageURL)
        }
        
        self.songNameLabel.text = song.songName
        self.artistNameLabel.text = song.album?.artist?.artistName
    }
    
    func configAlbumCell(album: Album, song: Song) {
        
        if let imageURL = NSURL(string: album.imageURL) {
            self.songImageView.hnk_setImageFromURL(imageURL)
        }

        self.songNameLabel.text = song.songName
        self.artistNameLabel.text = song.songArtistName
    }
    
    
    @IBAction func moreButtonTapped(sender: AnyObject) {
        if let delegate = buttonDelegate{
            delegate.cellMoreButtonTapped(self)
        }
    }
}
