//
//  MusicRatingCollectionViewCell.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/23.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Haneke

class MusicRatingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configCell(song: Song) {
        let imageURL = NSURL(string: (song.album?.imageURL)!)
        
        self.imageView.hnk_setImageFromURL(imageURL!)
        self.songLabel.text = song.songName
        self.artistLabel.text = song.album?.artist?.artistName
    }
}
