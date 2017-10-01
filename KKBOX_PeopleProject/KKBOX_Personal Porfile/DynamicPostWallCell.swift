//
//  DynamicPostWallCell.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tie Lin on 2016/8/27.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Haneke

class DynamicPostWallCell: UITableViewCell {
    
    @IBOutlet weak var CDContainerView: MaterialTrackContainerView!
    @IBOutlet weak var storyContent: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var trackImg: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var ArtistNameAlbumNameLabel: UILabel!
    @IBOutlet weak var storyTitleLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var likeNumLabel: UILabel!
    @IBOutlet weak var commentImg: UIImageView!
    @IBOutlet weak var commentNumLabel: UILabel!
    
    var selectedStioryId: String!
    var existSelectedCommentId = [String]()
    var likeNum: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(DynamicPostWallCell.likeTapped(_:)))
        //只需點擊一次，即可觸發likeTapped
        likeTap.numberOfTapsRequired = 1
        //在likeImg上，添加tap這個gesture
        likeImg.addGestureRecognizer(likeTap)
        //controll by default,do not have the user interaction enabel, so we need to enable the user interaction mannual
        likeImg.userInteractionEnabled = true
    }
    
    func likeTapped(sender: UIGestureRecognizer){
        if self.likeImg.image == UIImage(named: "icon_like_normal"){
            self.likeImg.image = UIImage(named: "icon_like_actived")
            self.likeNum = self.likeNum + 1
            self.likeNumLabel.text = "\(self.likeNum)"
        }else{
            self.likeImg.image = UIImage(named: "icon_like_normal")
            self.likeNum = self.likeNum - 1
            self.likeNumLabel.text = "\(self.likeNum)"
        }
        let meId = NSUserDefaults.standardUserDefaults().valueForKey("meId") as? String
        ServerManager.getStoryCollection(userId: meId!, completion: { (stories) in
            if stories.count > 0{
                for story in stories{
                    if story.storyId == self.selectedStioryId{
                        ServerManager.decollectStory(storyId: story.storyId, completion: {
                            }, failure: { (error) in
                                
                        })
                    }else{
                        ServerManager.collectStory(storyId: self.selectedStioryId, completion: {
                            }, failure: { (error) in
                                
                        })
                    }
                }
            }else{
                ServerManager.collectStory(storyId: self.selectedStioryId, completion: {
                    self.likeImg.image = UIImage(named: "icon_like_actived")
                    self.likeNumLabel.text = "\(self.likeNum + 1)"
                    }, failure: { (error) in
                        
                })
            }
        }) { (error) in
            
        }
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func drawRect(rect: CGRect) {
        trackImg.contentMode = .ScaleAspectFill
        trackImg.layer.cornerRadius = 3.0
        trackImg.clipsToBounds = true
    }
    
    func configureCell(story: Story){
        
        if let profileImageURL = NSURL(string: story.whoPostStoryImgUrl){
            let profileImageData = NSData(contentsOfURL: profileImageURL)
            let profileImg = UIImage(data: profileImageData!)
            self.profileImg.image = profileImg
        }
        
        if let albumCoverImageUrl = NSURL(string: story.storySongCoverUrl){
            let albumCoverImageData = NSData(contentsOfURL: albumCoverImageUrl)
            let albumCoverImg = UIImage(data: albumCoverImageData!)
            self.trackImg.image = albumCoverImg
            let imageColor = self.trackImg.image?.getPixelColor(CGPointMake(self.trackImg.bounds.size.width/2 - 50, self.trackImg.bounds.size.height/2 - 50))
            let whiteColor = UIColor.whiteColor()
            let gradient = CAGradientLayer()
            
            gradient.colors = [(imageColor?.CGColor)!,whiteColor.CGColor]
            gradient.startPoint = CGPointMake(0, 0)
            gradient.endPoint = CGPointMake(1, 0)
            gradient.frame = self.CDContainerView.bounds
            CDContainerView.layer.insertSublayer(gradient, atIndex: 0)
        }
        
        self.selectedStioryId = story.storyId
        self.commentNumLabel.text = "\(story.storyComments.count)"
        self.likeNumLabel.text = "\(story.storyLikeNum)"
        likeNumLabel.sizeToFit()
        commentNumLabel.sizeToFit()
        
 
        self.likeNum = story.storyLikeNum
        self.profileNameLabel.text = story.whoPostStory
        self.storyTitleLabel.text = story.storyName
        postDateLabel.sizeToFit()
        self.postDateLabel.text = story.storyPostTime
        self.storyContent.text = story.storyContent
        self.trackNameLabel.text = story.storySongName
        self.ArtistNameAlbumNameLabel.text = "\(story.stroySongArtistName)"+"  \(story.storySongAlbumName)"
    }
}

extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
