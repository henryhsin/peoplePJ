//
//  TrackViewCell.swift
//  KKBOX_Personal Porfile
//
//  Created by 辛忠翰 on 2016/8/29.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class CommentTrackPlayViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBOutlet weak var backGroundView: UIView!
    
    @IBOutlet weak var backgroundImgView: UIImageView!
    
    @IBOutlet weak var backgroundBlakBlurView: UIView!
    
    @IBOutlet weak var foregroundImgView: UIImageView!
    @IBOutlet weak var songName: MaterialLabel!
    
    @IBOutlet weak var artistNameAndAlbumNameLabel: MaterialLabel!
    var song: Song?
    func configureCell(story: Story){
        let blurEffect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = backgroundImgView.frame
        blurView.center = backgroundImgView.center
        backgroundImgView.addSubview(blurView)
        guard let imgUrl = NSURL(string: story.storySongCoverUrl)else{
            return
        }
        guard let imageData = NSData(contentsOfURL: imgUrl)else{
            return
        }
        guard let img = UIImage(data: imageData)else{
            return
        }
        backgroundImgView.image = img
        foregroundImgView.image = img
        
        self.songName.text = story.storySongName
        
        self.artistNameAndAlbumNameLabel.text = "\(story.stroySongArtistName)" + "/" + "\(story.storySongAlbumName)"
    }
    
}
