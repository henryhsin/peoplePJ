//
//  CommentVCViewController.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/12.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var segmentedControlOutlet: ProfileSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var hideView: UIView!
    var myPostCell = [DynamicPostWallCell]()
    var strangerPostCell = [StrangerDynamicPostWallCell]()
    var followingsStories = [Story]()
    var strangerStories = [StrangerStories]()
    var topTwoStories = [StrangerStories]()
    var commentsStories = [StrangerStories]()
    var tracksStories = [StrangerStories]()
    
    var collectedStories = [String]()
    var myStories = [Story]()
    var myStories2 = [Story]()
    var myStories3 = [Story]()
    var selectedStory: Story!
    let nib = UINib(nibName: "DynamicPostWallSaySomethingCell", bundle: nil)
    let nib1 = UINib(nibName: "DynamicPostWallCell", bundle: nil)
    let nib2 = UINib(nibName: "StrangerDynamicPostWallCell", bundle: nil)
    
    var commentVC: CommentVC!
    
    var selfUser: User?
    var songs = [Song]()
    var everLoadMyDynamicWall: Bool!
    var kkboxId: String!
    var isFromAddPostVC = false
    lazy var addPostVC = AddPostVC(nibName: "AddPostVC", bundle: nil)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(isFromAddPostVC: Bool){
        self.init(nibName: "FeedVC", bundle: nil)
        self.isFromAddPostVC = isFromAddPostVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(nib, forCellReuseIdentifier: "DynamicPostWallSaySomethingCell")
        tableView.registerNib(nib1, forCellReuseIdentifier: "DynamicPostWallCell")
        tableView.registerNib(nib2, forCellReuseIdentifier: "StrangerDynamicPostWallCell")
        // 導覽列標題
        self.title = "動態"
        let backButton = BackButton()
        backButton.InitUI()
        backButton.addTarget(self, action: #selector(self.backToPreviousView), forControlEvents: .TouchUpInside)
        
        // 導覽列底色
        self.navigationController?.navigationBar.barTintColor =
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        
        // 導覽列左邊按鈕
        let rightButton = UIBarButtonItem(
            image: UIImage(named: "icon_notice"),
            style:.Plain ,
            target:self ,
            action: nil)
        self.navigationItem.rightBarButtonItem = rightButton
        
        
        
        let noticeButton = NoticeButton()
        noticeButton.InitUI()
        noticeButton.addTarget(self, action: #selector(noticeButtonTapped), forControlEvents: .TouchUpInside)
        let rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.customView = noticeButton
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func noticeButtonTapped(sender: UIButton) {
        
    }
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.segmentedControlOutlet.initUI()
        let leftBarButton = CancleBarButton()
        leftBarButton.feedVCInitUI()
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = leftBarButton
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.segmentedControlOutlet.selectedSegmentIndex = 1

        
        if self.isFromAddPostVC{
            self.segmentedControlOutlet.selectedSegmentIndex = 0
            self.isFromAddPostVC = false
        }else{
            self.segmentedControlOutlet.selectedSegmentIndex = 1
        }
        
        self.hideView.hidden = false
        self.spinner.hidden = false
        self.spinner?.startAnimating()
        if !self.strangerStories.isEmpty{
            self.strangerStories.removeAll()
        }
        if !self.topTwoStories.isEmpty{
            self.topTwoStories.removeAll()
        }
        if !self.commentsStories.isEmpty{
            self.commentsStories.removeAll()
        }
        if !self.tracksStories.isEmpty{
            self.tracksStories.removeAll()
        }
        if !self.followingsStories.isEmpty{
            self.followingsStories.removeAll()
        }
        if !self.myStories.isEmpty{
            self.myStories.removeAll()
        }
        if !self.myStories2.isEmpty{
            self.myStories2.removeAll()
        }
        self.everLoadMyDynamicWall = false
        
        
        self.getMyDynamicWall()
        self.getStrangerPostInfo()
        
        //        self.getDynamicWallInformation(){[weak self] in
        //                self?.myStories = (self?.myStories.reverse())!
        //                for story in self!.myStories{
        //                    self!.followingsStories.append(story)
        //                }
        //                self?.myStories2 = (self?.myStories2.reverse())!
        //                for story in self!.myStories2{
        //                    self!.followingsStories.append(story)
        //                }
        //                self?.tableView.reloadData()
        //                self?.spinner?.stopAnimating()
        //                self?.hideView.hidden = true
        //        }
        
        
        //        self.getStrangersDynamicWallInformation {
        //            dispatch_async(dispatch_get_main_queue()){[weak self] in
        //                self?.segmentedControlOutlet.initUI()
        //                self?.tableView.reloadData()
        //                self?.spinner?.stopAnimating()
        //                self?.hideView.hidden = true
        //            }
        //        }
        
        
        
    }
    
    
    
    //MARK: -HTTP Request
    func getDynamicWallInformation(completion: ()->Void){
        let group = dispatch_group_create()
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let mainQueue = dispatch_get_main_queue()
        getMyPostInfo(group, queue: queue)
        getStrangerPostInfo()
        dispatch_group_notify(group, mainQueue){
            dispatch_async(dispatch_get_main_queue(), {
                completion()
            })
        }
    }
    
    func getStrangersDynamicWallInformation(completion: ()->Void){
        let group = dispatch_group_create()
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        getStrangerPostInfo()
        dispatch_group_notify(group, queue){
            dispatch_async(dispatch_get_main_queue(), {
                completion()
            })
        }
    }
    
    func getMyDynamicWallInformation(completion: ()->Void){
        let group = dispatch_group_create()
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        getMyPostInfo(group, queue: queue)
        dispatch_group_notify(group, queue){
            dispatch_async(dispatch_get_main_queue(), {
                completion()
            })
        }
    }
    func getMyDynamicWall(){
        let meId = NSUserDefaults.standardUserDefaults().valueForKey("meId") as? String
        spinner?.startAnimating()
        self.hideView.hidden = false
        self.spinner.hidden = false
        let group = dispatch_group_create()
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
        dispatch_group_enter(group)
        dispatch_group_async(group, queue, {
            ServerManager.getFullInfo( userId: meId!, completion: { [weak self](user) in
                print("我的名字",user.userName)
                print("我的ID",user.kkboxId)
                print("我的照片",user.userProfileImageUrl)
                self?.myStories = user.userPostedStrory
                self?.collectedStories = user.storyCollection
                self?.selfUser = user
                self?.getFollowingsPostInfo(user, group: group, queue: queue)
                self?.myStories = (self?.myStories.reverse())!
                dispatch_group_leave(group)
                }, failure: {(error) in
                    dispatch_group_leave(group)
            })
        })
        
        dispatch_group_notify(group, dispatch_get_main_queue()){
            self.tableView.reloadData()
            self.spinner?.stopAnimating()
            self.hideView.hidden = true
        }
        
        
        
    }
    
    func getMyPostInfo(group: dispatch_group_t, queue: dispatch_queue_t) {
        let meId = NSUserDefaults.standardUserDefaults().valueForKey("meId") as? String
        spinner?.startAnimating()
        self.hideView.hidden = false
        self.spinner.hidden = false
        dispatch_group_enter(group)
        dispatch_group_async(group, queue, {
            ServerManager.getFullInfo( userId: meId!, completion: { [weak self](user) in
                self?.myStories = user.userPostedStrory
                self?.collectedStories = user.storyCollection
                self?.selfUser = user
                self?.getFollowingsPostInfo(user, group: group, queue: queue)
                dispatch_group_leave(group)
                
                }, failure: {(error) in
                    dispatch_group_leave(group)
            })
        })
    }
    
    func getFollowingsPostInfo(user: User, group: dispatch_group_t, queue: dispatch_queue_t){
        dispatch_group_enter(group)
        dispatch_group_async(group, queue){
            ServerManager.getStoriesByFollowings({ (stories) in
                self.myStories2 = stories
                for story in self.myStories2{
                    print("myStories2",story.storyName)
                }
                self.myStories3 = self.myStories3.reverse()
                dispatch_group_leave(group)
                
                }, failure: { (error) in
                    dispatch_group_leave(group)
                    
            })
            
            
            //            for following in user.followings
            //            {
            //                ServerManager.getFullInfo(userId: following["kkbox_id"]!, completion:
            //                    { [weak self] (user) in
            //                        for story in user.userPostedStrory{
            //                            self?.myStories2.append(story)
            //                        }
            //                    }, failure:
            //                    { (error) in
            //                })
            //
            //            }
            
            //            self.myStories2 = self.myStories2.reverse()
            //            dispatch_group_leave(group)
        }
        
    }
    
    
    //    func getFollowingsPostInfo(user: User, group: dispatch_group_t, queue: dispatch_queue_t){
    //        dispatch_group_enter(group)
    //        dispatch_group_async(group, queue, {
    //            for following in user.followings
    //            {
    //                ServerManager.getFullInfo(userId: following["kkbox_id"]!, completion:
    //                    { [weak self] (user) in
    //                        for story in user.userPostedStrory{
    //                            self?.myStories2.append(story)
    //                        }
    //                    }, failure:
    //                    { (error) in
    //                })
    //
    //            }
    //            self.myStories2 = self.myStories2.reverse()
    //            dispatch_group_leave(group)
    //        })
    //    }
    
    
    func getStrangerPostInfo() {
        spinner?.startAnimating()
        self.hideView.hidden = false
        self.spinner.hidden = false
        let group = dispatch_group_create()
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_group_enter(group)
        dispatch_group_async(group, queue, {
            ServerManager.getStoriesTopTwo({ [weak self] (stories) in
                for story in stories{
                    //                    if !self!.checkIfStrangerStoryIsRepeat(strangerStories: self!.strangerStories, inputStory: story){
                    //                        self!.topTwoStories.append(story)
                    //                    }
                    self!.topTwoStories.append(story)
                }
                //                let indexSection = NSIndexSet(index: 0)
                //                self?.tableView.reloadSections(indexSection, withRowAnimation: .None)
                dispatch_group_leave(group)
            }) { (error) in
                dispatch_group_leave(group)
            }
        })
        
        dispatch_group_enter(group)
        dispatch_group_async(group, queue, {
            ServerManager.getStoriesByComments({ [weak self] (stories) in
                
                for story in stories{
                    //                    if !self!.checkIfStrangerStoryIsRepeat(strangerStories: self!.strangerStories, inputStory: story){
                    //                        self!.commentsStories.append(story)
                    //                    }
                    self!.commentsStories.append(story)
                }
                //                let indexSection = NSIndexSet(index: 1)
                //                self?.tableView.reloadSections(indexSection, withRowAnimation: .None)
                dispatch_group_leave(group)
            }) { (error) in
                dispatch_group_leave(group)
            }
        })
        
        dispatch_group_enter(group)
        dispatch_group_async(group, queue, {
            ServerManager.getStoriesByMyStories({ [weak self] (stories) in
                for story in stories{
                    //                    if !self!.checkIfStrangerStoryIsRepeat(strangerStories: self!.strangerStories, inputStory: story){
                    //                        self!.tracksStories.append(story)
                    //                    }
                    self!.tracksStories.append(story)
                }
                //                let indexSection = NSIndexSet(index: 2)
                //                self?.tableView.reloadSections(indexSection, withRowAnimation: .None)
                dispatch_group_leave(group)
            }) { (error) in
                dispatch_group_leave(group)
            }
        })
        dispatch_group_notify(group, dispatch_get_main_queue()){
            self.tableView.reloadData()
            self.spinner?.stopAnimating()
            self.hideView.hidden = true
        }
        
        
    }
    
    func checkIfStrangerStoryIsRepeat(strangerStories stories: [Story],inputStory story: Story) -> Bool{
        var isRepeat = false
        for strangerStory in strangerStories{
            if story.storyId == strangerStory.storyId{
                isRepeat = true
                return isRepeat
            }
        }
        return isRepeat
    }
    
    func backToPreviousView(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func getTrackByStoryId(storyId: String,completion:()->()){
        let group = dispatch_group_create()
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_group_enter(group)
        dispatch_group_async(group, queue, {
            ServerManager.getTrackByStoryId(storyId: storyId, completion: { (songs) in
                let aSong = songs[0]
                if !self.songs.isEmpty{
                    self.songs.removeAll()
                }
                print("aSongaSong:",aSong.songName)
                for int in 1...10 {
                    self.songs.append(aSong)
                }
                print("songssongssongssongs:",songs[0].songName)
                dispatch_group_leave(group)
                
            }) { (error) in
                dispatch_group_leave(group)
                
            }
        })
        dispatch_group_notify(group, queue, {
            dispatch_async(dispatch_get_main_queue(), {
                completion()
            })
            
        })
        
    }
    
    
    //MARK: -TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch segmentedControlOutlet.selectedSegmentIndex
        {
        case 0:
            return 4
        default:
            break
        }
        return 4
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControlOutlet.selectedSegmentIndex{
        case 0:
            if section == 0 {
                return 1
            }else if section == 1{
                //                return self.followingsStories.count
                return self.myStories.count
            }else if section == 2{
                return self.myStories2.count
            }
            return 0
        case 1:
            if section == 0 {
                print("self.topTwoStories.count",self.topTwoStories.count)
                return self.topTwoStories.count
            }else if section == 1{
                print("self.commentsStories.count",self.commentsStories.count)
                return self.commentsStories.count
            }else if section == 2{
                print("self.tracksStories.count",self.tracksStories.count)
                return self.tracksStories.count
            }
            return 0
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch segmentedControlOutlet.selectedSegmentIndex {
        case 0:
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("DynamicPostWallSaySomethingCell") as! DynamicPostWallSaySomethingCell
                cell.selectionStyle = .None
//                cell.textfield?.delegate = self
                if selfUser != nil{
                    if let userImageUrl = NSURL(string: self.selfUser!.userProfileImageUrl){
                        if let imageData = NSData(contentsOfURL: userImageUrl){
                            let userCoverImg = UIImage(data: imageData)
//                            cell.userImg.image = userCoverImg
                        }
                    }
                }
                
                return cell
            }else if indexPath.section == 1 {
                let storyCell = tableView.dequeueReusableCellWithIdentifier("DynamicPostWallCell") as! DynamicPostWallCell
                storyCell.selectionStyle = .None
                if self.myStories.count > 0{
                    let myStories = self.myStories[indexPath.row]
                    for collectedStory in self.collectedStories{
                        if myStories.storyId == collectedStory{
                            storyCell.likeImg.image = UIImage(named: "icon_like_actived")
                            storyCell.likeNumLabel.textColor = UIColor(red: 0, green: 174/255, blue: 216/255, alpha: 1)
                            break
                        }else{
                            storyCell.likeImg.image = UIImage(named: "icon_like_normal")
                            storyCell.likeNumLabel.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
                        }
                    }
                    if storyCell.buttonDelegate == nil {
                        storyCell.buttonDelegate = self
                    }
                    storyCell.configureCell(myStories)
                    storyCell.dynamicPostCellWallDelegate = self
                    if selfUser != nil{
                        if let userImageUrl = NSURL(string: selfUser!.userProfileImageUrl){
                            if let imageData = NSData(contentsOfURL: userImageUrl){
                                if let userCoverImg = UIImage(data: imageData){
                                    storyCell.profileImg.image = userCoverImg
                                }
                            }
                        }
                    }
                    
                    
                }
                return storyCell
            }else{
                let storyCell = tableView.dequeueReusableCellWithIdentifier("DynamicPostWallCell") as! DynamicPostWallCell
                storyCell.selectionStyle = .None
                if self.myStories2.count > 0{
                    let myStories2 = self.myStories2[indexPath.row]
                    for collectedStory in self.collectedStories{
                        if myStories2.storyId == collectedStory{
                            storyCell.likeImg.image = UIImage(named: "icon_like_actived")
                            storyCell.likeNumLabel.textColor = UIColor(red: 0, green: 174/255, blue: 216/255, alpha: 1)
                            break
                        }else{
                            storyCell.likeImg.image = UIImage(named: "icon_like_normal")
                            storyCell.likeNumLabel.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
                        }
                    }
                    if storyCell.buttonDelegate == nil {
                        storyCell.buttonDelegate = self
                    }
                    storyCell.configureCell(myStories2)
                    storyCell.dynamicPostCellWallDelegate = self
                    //                    if selfUser != nil{
                    //                        if let userImageUrl = NSURL(string: selfUser!.userProfileImageUrl){
                    //                            if let imageData = NSData(contentsOfURL: userImageUrl){
                    //                                let userCoverImg = UIImage(data: imageData)
                    //                                storyCell.profileImg.image = userCoverImg
                    //                            }
                    //
                    //
                    //                        }
                    //                    }
                    
                }
                return storyCell
            }
        default:
            if indexPath.section == 0{
                let strangerStoryCell = tableView.dequeueReusableCellWithIdentifier("StrangerDynamicPostWallCell") as! StrangerDynamicPostWallCell
                strangerStoryCell.selectionStyle = .None
                if self.topTwoStories.count > 0{
                    let story = self.topTwoStories[indexPath.row]
                    if strangerStoryCell.buttonDelegate == nil {
                        strangerStoryCell.buttonDelegate = self
                    }
                    strangerStoryCell.configureCell(story)
                    strangerStoryCell.strangerDynamicPostWallCellDelegate = self
                    for collectedStory in self.collectedStories{
                        if story.storyId == collectedStory{
                            strangerStoryCell.likeImg.image = UIImage(named: "icon_like_actived")
                            strangerStoryCell.likeNumLabel.textColor = UIColor(red: 0, green: 174/255, blue: 216/255, alpha: 1)
                            break
                        }else{
                            strangerStoryCell.likeImg.image = UIImage(named: "icon_like_normal")
                            strangerStoryCell.likeNumLabel.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
                        }
                    }
                    
                }
                return strangerStoryCell
                
            }else if indexPath.section == 1{
                let strangerStoryCell = tableView.dequeueReusableCellWithIdentifier("StrangerDynamicPostWallCell") as! StrangerDynamicPostWallCell
                strangerStoryCell.selectionStyle = .None
                if self.commentsStories.count > 0{
                    let story = self.commentsStories[indexPath.row]
                    if strangerStoryCell.buttonDelegate == nil {
                        strangerStoryCell.buttonDelegate = self
                    }
                    strangerStoryCell.configureCell(story)
                    strangerStoryCell.strangerDynamicPostWallCellDelegate = self
                    for collectedStory in self.collectedStories{
                        if story.storyId == collectedStory{
                            strangerStoryCell.likeImg.image = UIImage(named: "icon_like_actived")
                            strangerStoryCell.likeNumLabel.textColor = UIColor(red: 0, green: 174/255, blue: 216/255, alpha: 1)
                            break
                        }else{
                            strangerStoryCell.likeImg.image = UIImage(named: "icon_like_normal")
                            strangerStoryCell.likeNumLabel.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
                        }
                    }
                    
                }
                return strangerStoryCell
            }else{
                let strangerStoryCell = tableView.dequeueReusableCellWithIdentifier("StrangerDynamicPostWallCell") as! StrangerDynamicPostWallCell
                strangerStoryCell.selectionStyle = .None
                if self.tracksStories.count > 0{
                    let story = self.tracksStories[indexPath.row]
                    if strangerStoryCell.buttonDelegate == nil {
                        strangerStoryCell.buttonDelegate = self
                    }
                    strangerStoryCell.configureCell(story)
                    strangerStoryCell.strangerDynamicPostWallCellDelegate = self
                    for collectedStory in self.collectedStories{
                        if story.storyId == collectedStory{
                            strangerStoryCell.likeImg.image = UIImage(named: "icon_like_actived")
                            strangerStoryCell.likeNumLabel.textColor = UIColor(red: 0, green: 174/255, blue: 216/255, alpha: 1)
                            break
                        }else{
                            strangerStoryCell.likeImg.image = UIImage(named: "icon_like_normal")
                            strangerStoryCell.likeNumLabel.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
                        }
                    }
                    
                }
                return strangerStoryCell
            }
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch segmentedControlOutlet.selectedSegmentIndex{
        case 0:
            if indexPath.section == 0{
                let addPostVC = AddStoryVC.init(nibName: "AddStoryVC", bundle: nil)
                self.navigationController?.pushViewController(addPostVC, animated: true)

            }else if indexPath.section == 1{
                
                var comments = [Comment]()
                comments = myStories[indexPath.row].storyComments
                var topTwoComments = [Comment]()
                topTwoComments = myStories[indexPath.row].storyTopTwoComments
                commentVC = CommentVC.init(topTwoComments: topTwoComments,comments: comments, story: myStories[indexPath.row], user: self.selfUser)
                self.navigationController?.pushViewController(commentVC, animated: true)
            }else if indexPath.section == 2{
                var comments = [Comment]()
                comments = myStories2[indexPath.row].storyComments
                var topTwoComments = [Comment]()
                topTwoComments = myStories2[indexPath.row].storyTopTwoComments
                commentVC = CommentVC.init(topTwoComments: topTwoComments,comments: comments, story: myStories2[indexPath.row], user: self.selfUser)
                self.navigationController?.pushViewController(commentVC, animated: true)
            }
        case 1:
            if indexPath.section == 0{
                var comments = [Comment]()
                comments = topTwoStories[indexPath.row].storyComments
                var topTwoComments = [Comment]()
                topTwoComments = topTwoStories[indexPath.row].storyTopTwoComments
                commentVC = CommentVC.init(topTwoComments: topTwoComments,comments: comments, story: topTwoStories[indexPath.row], user: self.selfUser)
                self.navigationController?.pushViewController(commentVC, animated: true)
            }else if indexPath.section == 1{
                var comments = [Comment]()
                comments = commentsStories[indexPath.row].storyComments
                var topTwoComments = [Comment]()
                topTwoComments = commentsStories[indexPath.row].storyTopTwoComments
                commentVC = CommentVC.init(topTwoComments: topTwoComments,comments: comments, story: commentsStories[indexPath.row], user: self.selfUser)
                self.navigationController?.pushViewController(commentVC, animated: true)
            }else if indexPath.section == 2{
                var comments = [Comment]()
                comments = tracksStories[indexPath.row].storyComments
                var topTwoComments = [Comment]()
                topTwoComments = tracksStories[indexPath.row].storyTopTwoComments
                commentVC = CommentVC.init(topTwoComments: topTwoComments,comments: comments, story: tracksStories[indexPath.row], user: self.selfUser)
                self.navigationController?.pushViewController(commentVC, animated: true)
            }
            
        default:
            return
            
        }
        
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CELL_SPACING_HEIGHT
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch segmentedControlOutlet.selectedSegmentIndex{
        case 0:
            if section == 3{
                return 150
            }
        case 1:
            if section == 3{
                return 150
            }
        default:
            break
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch segmentedControlOutlet.selectedSegmentIndex{
        case 0:
            if section == 3{
                let postCellFooterView = PostCellFooterView.instanceFromNib()
                postCellFooterView.buttonAction = { [weak self] in
                    self?.scrollToFirstRow()
                }
                return postCellFooterView
            }
        case 1:
            if section == 3{
                let postCellFooterView = PostCellFooterView.instanceFromNib()
                postCellFooterView.buttonAction = { [weak self] in
                    self?.scrollToFirstRow()
                }
                return postCellFooterView
            }
        default:
            break
        }
        
        return nil
        
    }
    
    // Make the background color show through
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    
    @IBAction func segmentedControlIndexChanged(sender: UISegmentedControl) {
        
        switch segmentedControlOutlet.selectedSegmentIndex
        {
        case 0:
            //            if !everLoadMyDynamicWall{
            //                everLoadMyDynamicWall = true
            //                self.hideView.hidden = false
            //                if !self.followingsStories.isEmpty{
            //                    self.followingsStories.removeAll()
            //                }
            //                if !self.myStories.isEmpty{
            //                    self.myStories.removeAll()
            //                }
            //                if !self.myStories2.isEmpty{
            //                    self.myStories2.removeAll()
            //                }
            //
            //                self.getMyDynamicWallInformation{
            //                    dispatch_async(dispatch_get_main_queue()){[weak self] in
            //                        self?.myStories = (self?.myStories.reverse())!
            //                        for story in self!.myStories{
            //                            self!.followingsStories.append(story)
            //                        }
            //                        self?.myStories2 = (self?.myStories2.reverse())!
            //                        for story in self!.myStories2{
            //                            self!.followingsStories.append(story)
            //                        }
            //                        self?.segmentedControlOutlet.initUI()
            //                        self?.tableView.reloadData()
            //                        self?.spinner?.stopAnimating()
            //                        self?.hideView.hidden = true
            //                    }
            //                }
            //
            //            }else{
            //                self.tableView.reloadData()
            //            }
            self.tableView.reloadData()
        case 1:
            tableView.reloadData()
        default:
            break;
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch segmentedControlOutlet.selectedSegmentIndex{
        case 0:
            if indexPath.section == 0 {
                return 56.0
            }
            return UITableViewAutomaticDimension //213
        case 1:
            return UITableViewAutomaticDimension //252
            
        default:
            return 0
            
        }
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch segmentedControlOutlet.selectedSegmentIndex{
        case 0:
            if indexPath.section == 0 {
                return 56.0
            }
            return  213
        case 1:
            return  252
            
        default:
            return 0
            
        }
        
    }
    
    
    
    
    //https://grokswift.com/programmatic-uitableview-scrolling/
    //scroll to top of tableView
    func scrollToFirstRow() {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }
    
    
    func profileTapped(sender: UIGestureRecognizer){
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        //profileVC.profileUserName = self.whoPostNameLabel.text
        //問小膀胱原本的profileUserName改成什麼了
        profileVC.kkboxId = kkboxId
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
    
}

extension FeedVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        let addPostVC = AddStoryVC.init(nibName: "AddStoryVC", bundle: nil)
        self.navigationController?.pushViewController(addPostVC, animated: true)
        textField.resignFirstResponder()
    }
}

extension FeedVC: GoToPlayerVCButtonDelegate{
    func goToPlayerVCButtonTapped(cell: DynamicPostWallCell){
        self.hideView.hidden = false
        self.spinner.hidden = false
        self.getTrackByStoryId(cell.selectedStoryId!) {
            let appDelegateSharedInstance = appDelegate()
            appDelegateSharedInstance.songsArray = self.songs
            print("self.songs",self.songs.count)
            //目前的寫法超過一首歌會crash掉
            appDelegateSharedInstance.currentIndex = 0
            appDelegateSharedInstance.playSongIndex(0)
            
            var storiesArray = [Story]()
            for int in 1...10 {
                storiesArray.append(cell.selectedStory!)
            }
            let playerVC = PlayerViewController.init(songsArray: self.songs, selectedIndex: 0, storiesArray: storiesArray)
            self.navigationController?.pushViewController(playerVC, animated: true)
            //            {
            //                self.hideView.hidden = true
            //                self.spinner.hidden = true
            //                self.spinner.stopAnimating()
            //            }
            
        }
        
    }
}

extension FeedVC: StrangerGoToPlayerVCButtonDelegate{
    
    
    func strangerGoToPlayerVCButtonTapped(cell: StrangerDynamicPostWallCell,selectStory: StrangerStories){
        self.getTrackByStoryId(selectStory.storyId) {
            let appDelegateSharedInstance = appDelegate()
            appDelegateSharedInstance.songsArray = self.songs
            print("selectStory.storyIdselectStory.storyId",selectStory.storyId)
            //目前的寫法超過一首歌會crash掉
            appDelegateSharedInstance.currentIndex = 0
            appDelegateSharedInstance.playSongIndex(0)
            var storiesArray = [Story]()
            for int in 1 ... 10{
                //                storiesArray.append(cell.selectedStory!)
                storiesArray.append(selectStory)
                
            }
            let playerVC = PlayerViewController.init(songsArray: self.songs, selectedIndex: 0, storiesArray: storiesArray)
            self.navigationController?.pushViewController(playerVC, animated: true)
        }
        
    }
}

extension FeedVC: DynamicPostCellWallDelegate{
    func passCell(cell: DynamicPostWallCell?) {
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profileVC.kkboxId = cell!.kkboxId
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}

extension FeedVC: StrangerDynamicPostWallCellDelegate{
    func passTheCell(cell: StrangerDynamicPostWallCell?) {
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profileVC.kkboxId = cell!.kkboxId
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}



