//
//  PlayerViewController.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tie Lin on 2016/10/6.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

//protocol PlayerViewControllerProtocol {
//    func playerStroryVCBigLikeButtonTapped (playerVC:PlayerViewController)
//    func setImgOnLikeButton(playerVC: PlayerViewController)
//}



class PlayerViewController: UIViewController {
    
    @IBOutlet weak var addStoryBtnOutlet: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songTimeLabel: UILabel!
    @IBOutlet weak var songTimeSlider: UISlider!
    @IBOutlet weak var songDurationLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var storyContentLabel: UILabel!
    @IBOutlet weak var addNewStoryBtnOutlet: UIButton!
    @IBOutlet weak var noStoryLabel1: UILabel!
    @IBOutlet weak var noStoryLabel2: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var storyBtnOutlet: UIButton!
    
    var currentViewController: UIViewController?
    var songsArray = [Song]()
    var storiesArray = [Story]()
    var isStoryContenLabelAppear = false
    var isnoStoryLabel1Appear = false
    var isnoStoryLabel2Appear = false
    var isaddNewStoryBtnOutletAppear = false
    var isCollected = false
    var currentIndex = NSNotFound
    var dragging: Bool = false
    let storyTime = "20160827"
    let shareButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    let likeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    var selectedStioryId: String!
    var isStoryBtnTapped = false
    
    lazy var vc = PlayerStoryViewController(nibName: "PlayerStoryViewController", bundle: nil)
//    var delegate: PlayerViewControllerProtocol?
//    var dataSorce: PlayerViewControllerProtocol?
    
    convenience init(songsArray: [Song], selectedIndex: Int, storiesArray:[Story]?) {
        self.init(nibName: "PlayerViewController", bundle: nil)
        self.songsArray = songsArray
        self.currentIndex = selectedIndex
        
        if storiesArray != nil{
            self.storiesArray = storiesArray!
        }
        
    }
    
    //    convenience init(songsArray: [Song], selectedIndex: Int) {
    //        self.init(nibName: "PlayerViewController", bundle: nil)
    //        self.songsArray = songsArray
    //        self.currentIndex = selectedIndex
    //
    //    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate().playerVC = self
        
        initUI()
        self.storyContentLabel.hidden = true
        self.storyContentLabel.sizeToFit()
        self.noStoryLabel2.hidden = true
        self.noStoryLabel1.hidden = true
        self.addNewStoryBtnOutlet.hidden = true
        self.contentView.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        //        self.navigationController?.navigationBar.shadowImage = UIImage()
//                self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.tabBarController?.tabBar.hidden = true
    }
    
//    func afterPlayerStoryBigLikeButtonTapped(){
//        delegate?.playerStroryVCBigLikeButtonTapped(self)
//    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    func initUI() {
    
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        backButton.setImage(UIImage(named: "Back Arrow"), forState: .Normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), forControlEvents: .TouchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = backButton
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let moreButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        moreButton.setImage(UIImage(named: "btn_more_white-1"), forState: .Normal)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), forControlEvents: .TouchUpInside)
        
        let rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.customView = moreButton
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
        songTimeSlider.addTarget(self, action: #selector(PlayerViewController.seek), forControlEvents: .ValueChanged)
        songTimeSlider.addTarget(self, action: #selector(PlayerViewController.startDrag), forControlEvents: .TouchDown)
        songTimeSlider.addTarget(self, action: #selector(PlayerViewController.endDrag), forControlEvents: [.TouchUpInside, .TouchUpOutside])
        
        let song = self.songsArray[currentIndex]
        
        let albumImageURLString = song.album?.imageURL
        let albumImageURL = NSURL(string: albumImageURLString!)
        let albumImageData = NSData(contentsOfURL: albumImageURL!)
        let albumImage = UIImage(data: albumImageData!)
        
        let artistImageURLString = song.album?.artist?.imageURL
        let artistImageURL = NSURL(string: artistImageURLString!)
        let artistImageData = NSData(contentsOfURL: artistImageURL!)
        let artistImage = UIImage(data: artistImageData!)
        
        self.artistImageView.layer.cornerRadius = self.artistImageView.bounds.width/2
        self.artistImageView.clipsToBounds = true
        
        self.artistImageView.image = artistImage
        self.backgroundImageView.image = albumImage
        self.albumImageView.image = albumImage
        self.artistNameLabel.text = song.album?.artist?.artistName
        self.songNameLabel.text = song.songName
        self.title = song.album?.albumName
    }
    
    func backButtonTapped() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func moreButtonTapped() {
        let song = self.songsArray[currentIndex]
        let playerMoreVC = PlayerMoreViewController(nibName: "PlayerMoreViewController", bundle: nil)
        playerMoreVC.song = song
        playerMoreVC.modalPresentationStyle = .OverCurrentContext
        
        self.presentViewController(playerMoreVC, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Slider Function
    func seek() {
        appDelegate().audioEngine.currentTime = NSTimeInterval(self.songTimeSlider.value)
    }
    
    func startDrag() {
        self.dragging = true
    }
    
    func endDrag() {
        self.dragging = false
    }
    
    
    
    //MARK: - Action
    
    @IBAction func addButtonTouched(sender: AnyObject) {
    }
    
    @IBOutlet weak var collectedButton: UIButton!
    
    
    @IBAction func collectedButtonTouched(sender: AnyObject) {
        if !isCollected{
            isCollected = true
            sender.setImage(UIImage(named: "icon_fav_on"), forState: UIControlState.Normal)
        }else{
            isCollected = false
            sender.setImage(UIImage(named: "icon_fav_off"), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func lyricsButtonTouched(sender: AnyObject) {
        self.artistImageView.hidden = false
        self.artistNameLabel.hidden = false
        self.albumImageView.hidden = false
        self.songNameLabel.hidden = false
        self.storyContentLabel.hidden = true
        self.noStoryLabel2.hidden = true
        self.noStoryLabel1.hidden = true
        self.addNewStoryBtnOutlet.hidden = true
        
        self.currentViewController?.view.removeFromSuperview()
        self.currentViewController?.removeFromParentViewController()
        self.contentView.hidden = true
        
       
        
        
    }
    
    @IBAction func storyButtonTOuched(sender: AnyObject) {
        //        let song = self.songsArray[currentIndex]
        //        let playerMoreVC = PlayerMoreViewController(nibName: "PlayerMoreViewController", bundle: nil)
        //        playerMoreVC.song = song
        //        playerMoreVC.modalPresentationStyle = .OverCurrentContext
        //
        //        self.presentViewController(playerMoreVC, animated: true, completion: nil)
        if !isStoryBtnTapped{
            isStoryBtnTapped = true
            self.storyBtnOutlet.setImage(UIImage(named: "icon_story_blue"), forState: .Normal)
            if self.storiesArray.count > 0{
                let theShowedStoryIndex = arc4random_uniform(UInt32(storiesArray.count))
                print("storiesArray.count",storiesArray.count)
                print("theShowedStoryIndex:",theShowedStoryIndex)
                self.storyContentLabel.text = self.storiesArray[Int(theShowedStoryIndex)].storyContent
                //            self.storyContentLabel.hidden = false
                self.storyContentLabel.hidden = true
                self.artistImageView.hidden = true
                self.artistNameLabel.hidden = true
                self.albumImageView.hidden = true
                self.songNameLabel.hidden = true
                
                self.addChildViewController(vc)
                vc.didMoveToParentViewController(self)
                let song = self.songsArray[currentIndex]
                vc.story = self.storiesArray[Int(theShowedStoryIndex)]
                vc.songArtistName = song.songArtistName
                vc.songName = song.songName
                print("QQQAAAQQQ",song.songAlbumImgUrl)
                vc.songCoverImgUrl = song.songAlbumImgUrl
                vc.songAlbumName = song.album?.albumName
                vc.song = song
                print("vc.story",vc.story)
                print("vc.story.storyPostTime",vc.story.storyPostTime)
                print("vc.story.storySongCoverUrl",vc.story.storySongCoverUrl)
                print("vc.story.whoPostStoryImgUrl",vc.story.whoPostStoryImgUrl)
                print("vc.song.storySongCoverUrl",song.songAlbumImgUrl)
                print("vc.song.songArtistName",song.songArtistName)
                print("vc.song.songName",song.songName)
                vc.view.frame = self.contentView.bounds
                self.contentView.addSubview(vc.view)
                self.currentViewController = vc
                vc.configureCell(vc.story)
                self.contentView.hidden = false
                shareButton.setImage(UIImage(named: "np_sheetsicon_share_normal"), forState: .Normal)
                shareButton.addTarget(self, action: nil, forControlEvents: .TouchUpInside)
                
                let rightestBarButtonItem = UIBarButtonItem()
                rightestBarButtonItem.customView = shareButton
                //            if vc.isLikedStory{
                //                likeButton.setImage(UIImage(named: "btn_nowplay_like"), forState: .Normal)
                //            }else{
                //                likeButton.setImage(UIImage(named: "btn_nowplay_like_press"), forState: .Normal)
                //            }
                likeButton.setImage(UIImage(named: "btn_nowplay_like"), forState: .Normal)
                
                likeButton.addTarget(self, action: #selector(likeTapped), forControlEvents: .TouchUpInside)
                
                let rightBarButtonItem = UIBarButtonItem()
                rightBarButtonItem.customView = likeButton
                self.navigationItem.setRightBarButtonItems([rightestBarButtonItem,rightBarButtonItem], animated: true)
                self.title = vc.story.storyName
                self.selectedStioryId = vc.selectedStioryId
                self.storyBtnOutlet.setImage(UIImage(named: "icon_story_blue"), forState: .Normal)
            }else{
                self.isnoStoryLabel2Appear = true
                self.noStoryLabel2.hidden = false
                self.isnoStoryLabel1Appear = true
                self.noStoryLabel1.hidden = false
                self.songNameLabel.hidden = true
                
                self.isaddNewStoryBtnOutletAppear = true
                self.addNewStoryBtnOutlet.hidden = false
                self.artistImageView.hidden = true
                self.artistNameLabel.hidden = true
                self.albumImageView.hidden = true
                self.contentView.hidden = true
//                addStoryBtnOutlet.layer.cornerRadius = 6.0
//                addStoryBtnOutlet.layer.shadowColor = UIColor.blackColor().CGColor
//                addStoryBtnOutlet.layer.backgroundColor = UIColor.clearColor().CGColor
//                addStoryBtnOutlet.layer.borderWidth = 2.0
//                addStoryBtnOutlet.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.3).CGColor
//                addStoryBtnOutlet.layer.shouldRasterize = true
            }
        }else{
            isStoryBtnTapped = false
            self.storyBtnOutlet.setImage(UIImage(named: "icon_story-1"), forState: .Normal)
            self.artistImageView.hidden = false
            self.artistNameLabel.hidden = false
            self.albumImageView.hidden = false
            self.songNameLabel.hidden = false
            self.storyContentLabel.hidden = true
            self.noStoryLabel2.hidden = true
            self.noStoryLabel1.hidden = true
            self.addNewStoryBtnOutlet.hidden = true
            
            self.currentViewController?.view.removeFromSuperview()
            self.currentViewController?.removeFromParentViewController()
            self.contentView.hidden = true
            
        }
        
    }
    
    @IBAction func previousButtonTouched(sender: AnyObject) {
        appDelegate().previousSong()
    }
    
    @IBAction func playButtonTouched(sender: AnyObject) {
        appDelegate().tooglePlayBack()
    }
    
    @IBAction func nextButtonTouched(sender: AnyObject) {
        appDelegate().nextSong()
    }
    
    @IBAction func addNewStoryBtnTapped(sender: UIButton) {
        let addStoryVC = AddPostVC(nibName: "AddPostVC", bundle: nil)
        let song = self.songsArray[currentIndex]
        addStoryVC.selectedSong = song
        self.navigationController?.pushViewController(addStoryVC, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
//        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        
        self.tabBarController?.tabBar.hidden = false
    }
    
    
    func addStoryToServer(storyTitle: String, storyContent: String, song: Song){
        let group = dispatch_group_create()
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_group_enter(group)
        dispatch_group_async(group, queue, {
            ServerManager.addStory(storyTitle: storyTitle, storyContent: storyContent, createTime: self.storyTime, songId: song.trackId, completion: {
                self.backToLastView()
                dispatch_group_leave(group)
            }) { (error) in
                dispatch_group_leave(group)
            }
        })
        
    }
    
    func backToLastView(){
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func likeTapped(){
        if !vc.isLikedStory{
            vc.isLikedStory = true
            self.likeButton.setImage(UIImage(named: "btn_nowplay_like_press"), forState: .Normal)
            vc.storyLikeNum! += 1
            vc.likeNumLabel.text = "\(vc.storyLikeNum!)  人共鳴"
            ServerManager.collectStory(storyId: self.selectedStioryId, completion: {
                }, failure: { (error) in
                    
            })
        }else{
            vc.isLikedStory = false
            self.likeButton.setImage(UIImage(named: "btn_nowplay_like"), forState: .Normal)
            vc.storyLikeNum! -= 1
            vc.likeNumLabel.text = "\(vc.storyLikeNum!)  人共鳴"
            ServerManager.decollectStory(storyId: self.selectedStioryId, completion: {
                }, failure: { (error) in
                    
            })
        }
    }
    
    
}