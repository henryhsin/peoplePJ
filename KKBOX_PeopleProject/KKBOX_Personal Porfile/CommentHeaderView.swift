//
//  CommentHeaderView.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/16.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

class CommentHeaderView: UIView {
    class func instanceFromNib() -> CommentHeaderView {
        return UINib(nibName: "CommentHeaderView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! CommentHeaderView
    }
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var songName: MaterialLabel!
    
    @IBOutlet weak var artistNameAndAlbumNameLabel: MaterialLabel!
    
    func configureView(story: Story){
      

        self.songName.text = story.storySongName
        self.artistNameAndAlbumNameLabel.text = "\(story.stroySongArtistName)" + "/" + "\(story.storySongAlbumName)"
    }
    
    
    
}
