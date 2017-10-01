//
//  FollowingArtistCollectionViewCell.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/23.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Haneke

class FollowingArtistCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.backgroundColor = UIColor.clearColor().CGColor
        
//        imageView.layer.shadowColor = UIColor.blueColor().CGColor
//        imageView.layer.shadowOpacity = 1
//        imageView.layer.shadowOffset = CGSizeZero
//        imageView.layer.shadowRadius = 10
//        imageView.layer.masksToBounds = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        imageView.layer.cornerRadius = imageView.bounds.size.width/2
        imageView.clipsToBounds = true
    }
    
    func configCell(artist: Artist) {        
        let imageURLString = artist.imageURL
        let imageURL = NSURL(string: imageURLString)
        
        self.imageView.hnk_setImageFromURL(imageURL!)
        self.artistLabel.text = artist.artistName
    }
}
