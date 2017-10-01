//
//  AfterAddPostTrackView.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/26.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

class AfterAddPostTrackView: UIView {
    
    
    class func instanceFromNib() -> AfterAddPostTrackView {
        return UINib(nibName: "AfterAddPostTrackView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! AfterAddPostTrackView
    }
    @IBOutlet weak var coverImg: UIImageView!
    
    @IBOutlet weak var songName: UILabel!
    
    @IBOutlet weak var artistNameAndAlbumName: UILabel!
    
    func configureView(song: Song) {
        self.artistNameAndAlbumName.text = "\(song.songArtistName)" + "/" + "\(song.songAlbumName)"
        self.songName.text = song.songName
        
        if let albumCoverImageUrl = NSURL(string: song.songAlbumImgUrl){
            let albumCoverImageData = NSData(contentsOfURL: albumCoverImageUrl)
            let albumCoverImg = UIImage(data: albumCoverImageData!)
            self.coverImg.image = albumCoverImg
        }
    }
}
