//
//  CollectedAlbumCollectionViewCell.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/23.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Haneke

protocol AlbumPlayButtonDelegate {
    func albumPlayButton(cell: UICollectionViewCell)
}

class CollectedAlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    var buttonDelegate: AlbumPlayButtonDelegate?
    
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
    
    func configCell(album: Album) {
        let imageURL = NSURL(string: album.imageURL)
        
        self.imageView.hnk_setImageFromURL(imageURL!)
        self.albumLabel.text = album.albumName
        self.artistLabel.text = album.songs![0].album?.artist?.artistName
    }
    
    @IBAction func playButtonTapped(sender: AnyObject) {
        if let delegate = buttonDelegate {
            delegate.albumPlayButton(self)
        }
    }
}
