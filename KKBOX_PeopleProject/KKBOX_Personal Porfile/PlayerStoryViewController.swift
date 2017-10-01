//
//  PlayerStoryViewController.swift
//  KKBOX_Personal Porfile
//
//  Created by 辛忠翰 on 2016/11/18.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class PlayerStoryViewController: UIViewController {
    
    @IBOutlet weak var scrollViewContentHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var userProfileImg: UIImageView!
    
    @IBOutlet weak var userNameLabel: MaterialLabel!
    
    @IBOutlet weak var likeNumLabel: UILabel!
    
    @IBOutlet weak var postDateLabel: UILabel!
    
    @IBOutlet weak var storyContentLabel: UILabel!
    @IBOutlet weak var respondsNumLabel: UILabel!

    @IBOutlet weak var addStoryBtnOutlet: UIButton!
    
    var selectedStioryId: String!
    var storyLikeNum: Int!
    
    var story: Story!
    var selfUser: User?
    var songCoverImgUrl: String!
    var songName: String!
    var songArtistName: String!
    var songAlbumName: String!
    var collectedStories = [String]()
    var isLikedStory = false
    var song: Song?
    var storyContentHeight: CGFloat?
    lazy var plaverVC = PlayerViewController(nibName: "PlayerViewController", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func shareBtnTapped(sender: UIButton) {
    }
    
    @IBAction func likeBtnTapped(sender: UIButton) {
    }
    
    
    @IBAction func backToLastView(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func goToAddStoryVC(sender: UIButton) {
//        let addStoryVC = AddStoryVC(nibName: "AddStoryVC", bundle: nil)
//        self.navigationController?.pushViewController(addStoryVC, animated: true)
        let addPostVC = AddPostVC(song: self.song!)
        self.navigationController?.pushViewController(addPostVC, animated: true)
    }
    @IBAction func likeBigBtnTapped(sender: UIButton) {
        self.likeTapped()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let group = dispatch_group_create()
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        self.getMyPostInfo()
    }
    
    func likeTapped(){
        if !isLikedStory{
//            self.playerStroryVCBigLikeButtonTapped(plaverVC)
            isLikedStory = true
            self.storyLikeNum = self.storyLikeNum + 1
            self.likeNumLabel.text = "\(self.storyLikeNum)  人共鳴"
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            dispatch_async(queue) {
                ServerManager.collectStory(storyId: self.selectedStioryId, completion: {
                    }, failure: { (error) in
                })
            }
            
        }else{
//            self.playerStroryVCBigLikeButtonTapped(plaverVC)
            isLikedStory = false
            self.storyLikeNum = self.storyLikeNum - 1
            self.likeNumLabel.text = "\(self.storyLikeNum)  人共鳴"
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            dispatch_async(queue) {
                ServerManager.decollectStory(storyId: self.selectedStioryId, completion: {
                    }, failure: { (error) in
                })
            }
            
        }
        
    }
    
    
    func getMyPostInfo() {
        let meId = NSUserDefaults.standardUserDefaults().valueForKey("meId") as? String
        
            ServerManager.getFullInfo( userId: meId!, completion: { [weak self](user) in
                self?.selfUser = user
                self?.collectedStories = user.storyCollection
                if self?.collectedStories != nil{
                    for collectedStory in self!.collectedStories{
                        if self!.story.storyId == collectedStory{
                            self?.isLikedStory = true
                            //                        self?.playerStroryVCBigLikeButtonTapped((self?.plaverVC)!)
                            break
                        }else{
                            self?.isLikedStory = false
                            //                        self?.playerStroryVCBigLikeButtonTapped((self?.plaverVC)!)
                        }
                    }
                }
                
                
                }, failure: {(error) in
            })
       
    }
    
    
    
    @IBAction func goToCommentVCBtnTapped(sender: UIButton) {
        var comments = [Comment]()
        comments = story.storyComments
        var topTwoComments = [Comment]()
        topTwoComments = story.storyTopTwoComments
        if let user = selfUser{
            let commentVC = CommentVC.init(topTwoComments: topTwoComments,comments: comments, story: story, user: user)
            self.navigationController?.pushViewController(commentVC, animated: true)
        }
        
        
    }
    
    func configureCell(story: Story) {        
        story._storySongCoverUrl = self.songCoverImgUrl
        story._storySongName = self.songName
        story._stroySongArtistName = self.songArtistName
        story._storySongAlbumName = self.songAlbumName
        self.storyLikeNum = story.storyLikeNum
        self.selectedStioryId = story.storyId
        self.postDateLabel.text = story.storyPostTime
        self.userNameLabel.text = story.whoPostStory
//        self.userNameLabel.sizeToFit()
        
        self.storyContentLabel.text = story.storyContent
        self.storyContentLabel.lineBreakMode = .ByCharWrapping
        self.storyContentLabel.sizeToFit()
        //storyContentLabel並沒有改變
        self.storyContentHeight = self.storyContentLabel.bounds.height
        print("storyContentHeightstoryContentHeight",storyContentHeight)
        self.scrollViewContentHeight.constant = self.storyContentHeight! + 550
        
        if let imageUrl = NSURL(string: story.whoPostStoryImgUrl){
            if let imageData = NSData(contentsOfURL: imageUrl){
                if let img = UIImage(data: imageData){
                    self.userProfileImg.image = img
                }
            }
        }
//        addStoryBtnOutlet.layer.cornerRadius = 6.0
//        addStoryBtnOutlet.layer.shadowColor = UIColor.blackColor().CGColor
//        addStoryBtnOutlet.layer.backgroundColor = UIColor.clearColor().CGColor
//        addStoryBtnOutlet.layer.borderWidth = 2.0
//        addStoryBtnOutlet.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.3).CGColor
//        addStoryBtnOutlet.layer.shouldRasterize = true

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 13 // Whatever line spacing you want in points
        let text = storyContentLabel.attributedText
        let attributedString = NSMutableAttributedString(attributedString:text!)
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1), range:NSMakeRange(0, attributedString.length))
        storyContentLabel.attributedText = attributedString
        self.likeNumLabel.text = "\(self.storyLikeNum) 人共鳴"
        self.likeNumLabel.sizeToFit()
        self.respondsNumLabel.text = "\(story.storyComments.count) 則回應"
        self.respondsNumLabel.sizeToFit()

        }
    
    func backButtonTapped() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}

//extension PlayerStoryViewController: PlayerViewControllerProtocol{
//    func playerStroryVCBigLikeButtonTapped(playerVC: PlayerViewController) {
//        playerVC.likeTapped()
//    }
//    func setImgOnLikeButton(playerVC: PlayerViewController){
//        playerVC.likeTapped()
//    }
//}


