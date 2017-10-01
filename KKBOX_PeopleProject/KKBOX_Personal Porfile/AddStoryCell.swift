//
//  AddStoryCell.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/16.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit
import Haneke

class AddStoryCell: UITableViewCell {
    
    @IBOutlet weak var artistNameAndAlbumNameLabel: UILabel!
    
    @IBOutlet weak var coverImg: UIImageView!
    
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    func configureCell(song: Song)  {
        self.songNameLabel.text = song.songName
        self.artistNameAndAlbumNameLabel.text = "\(song.songArtistName)" + " / " + "\(song.songAlbumName)"
        let albumCoverImageUrl = NSURL(string: song.songAlbumImgUrl)
//        let albumCoverImageData = NSData(contentsOfURL: albumCoverImageUrl!)
//        if let imgData = albumCoverImageData{
//            let albumCoverImg = UIImage(data: imgData)
//            self.coverImg.image = albumCoverImg
//        }
        
        self.coverImg.hnk_setImageFromURL(albumCoverImageUrl!)
        
        
    }
    
}
