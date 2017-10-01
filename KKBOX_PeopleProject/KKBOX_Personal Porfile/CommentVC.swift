//
//  CommentVC.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/14.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit
import Haneke

class CommentVC: UIViewController {
    
    @IBOutlet weak var postCommentTextfield: UITextField!
    @IBOutlet weak var playBtnOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var favoriteCommentPlayContainerView: UIView!
    
    @IBOutlet weak var trackContainerView: UIView!
    
    @IBOutlet weak var likeNumLabel: UILabel!
    
    @IBOutlet weak var commentsNumLabel: UILabel!
    
    @IBOutlet weak var likeImg: UIImageView!
    
    var trackContainerViewPoint: CGRect!
    var commentsArray = [Comment]()
    var story: Story!
    var songs = [Song]()
    var topTwoComments = [Comment]()
    var commentHeaderView = CommentHeaderView.instanceFromNib()
    var postComment: Comment!
    var commentSecondHeaderViewCell = CommentSecondHeaderViewCell()
    var commentThirdHeaderViewCell = CommentThirdHeaderViewCell()
    var commentStroryTitleViewCell = CommentStoryTitleViewCell()
    var commentTrackPlayViewCell = CommentTrackPlayViewCell()
    var likeNum: Int!
    var selectedStioryId: String!
    var collectedStories = [String]()
    var isCommentsCellExpend = false
    
    var postKkboxId: String!
    var userKkboxId: String!
    var commentKkboxId: String!
    var isPlayBtnPressed = false
    var feedVC = FeedVC()
    let fullScreenSize = UIScreen.mainScreen().bounds.size
    let time = "20160827"
    var likedCommentArray = [String]()
    var selfUser: User?
    convenience init(topTwoComments: [Comment],comments: [Comment], story: Story, user: User? ){
        self.init(nibName: "CommentVC", bundle: nil)
        self.story = story
        self.commentsArray = comments
        self.commentsArray = self.commentsArray.reverse()
        self.topTwoComments = topTwoComments
        if self.topTwoComments.count == 0 && self.commentsArray.count >= 2{
            self.topTwoComments.append(commentsArray[0])
            self.topTwoComments.append(commentsArray[1])
            commentsArray.removeRange(0...1)
        }else if self.topTwoComments.count == 1 && self.commentsArray.count >= 1{
            self.topTwoComments.append(commentsArray[0])
            commentsArray.removeFirst()
        }
        for comment in topTwoComments{
            print("topTwoComment:",comment.commentContent)
        }
        for comment in commentsArray{
            print("allComment:",comment.commentContent)
        }
        if user != nil{
            
        }
        self.selfUser = user
        if user != nil{
            self.collectedStories = user!.storyCollection
        }
        
        self.postComment = Comment(story: story)
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib1 = UINib(nibName: "CommentStoryTitleViewCell", bundle: nil)
        tableView.registerNib(nib1, forCellReuseIdentifier: "CommentStoryTitleViewCell")
        let nib2 = UINib(nibName: "CommentRespondCell", bundle: nil)
        tableView.registerNib(nib2, forCellReuseIdentifier: "CommentRespondCell")
        
        let nib3 = UINib(nibName: "CommentTrackPlayViewCell", bundle: nil)
        tableView.registerNib(nib3, forCellReuseIdentifier: "CommentTrackPlayViewCell")
        let nib4 = UINib(nibName: "CommentSecondHeaderViewCell", bundle: nil)
        tableView.registerNib(nib4, forCellReuseIdentifier: "CommentSecondHeaderViewCell")
        
        let nib5 = UINib(nibName: "CommentThirdHeaderViewCell", bundle: nil)
        tableView.registerNib(nib5, forCellReuseIdentifier: "CommentThirdHeaderViewCell")
        
        self.trackContainerViewPoint = trackContainerView.frame
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.separatorColor = UIColor.clearColor()
        //        self.tableView.backgroundView = UIView(frame: CGRectMake(0,0, UIScreen.mainScreen().bounds.width, self.tableView.frame.height))
        //        let headerview = UIView(frame: CGRectMake(0,0, UIScreen.mainScreen().bounds.width, 182 ))
        //        self.tableView.tableHeaderView = headerview
        //        let trackView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        //        trackView.contentMode = .ScaleAspectFit
        //        let frontTrackView = UIImageView(frame: CGRect(x: (UIScreen.mainScreen().bounds.width - 145)/2, y: 18, width: 145, height: 145))
        
        self.likeNumLabel.text = "\(self.story.storyLikeNum)" + " 人共鳴"
        self.commentsNumLabel.text = "\(self.story.storyComments.count + self.story.storyTopTwoComments.count)" + " 則留言"
        //        guard let albumImageURL = NSURL(string: story.storySongCoverUrl)else{
        //            return
        //        }
        //        guard let imageData = NSData(contentsOfURL: albumImageURL)else{
        //            return
        //        }
        //        trackView.image = UIImage(data: imageData)
        //        frontTrackView.image = UIImage(data: imageData)
        
        
        
        //        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        //        effectView.frame = trackView.bounds
        //        effectView.addSubview(frontTrackView)
        //        trackView.addSubview(effectView)
        //        self.tableView.backgroundView?.addSubview(trackView)
        //        self.tableView.backgroundView?.backgroundColor = UIColor.whiteColor()
        
        
        self.title = self.story.storyName
        self.selectedStioryId = story.storyId
        
        let backButton = BackButton()
        backButton.InitUI()
        backButton.addTarget(self, action: #selector(self.backToPreviousView), forControlEvents: .TouchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = backButton
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let shareButton = ShareBarBtn()
        shareButton.InitUI()
        shareButton.addTarget(self, action: nil, forControlEvents: .TouchUpInside)
        
        let rightBarButtonItem2 = UIBarButtonItem()
        rightBarButtonItem2.customView = shareButton
        
        
        let likeBarButton = LikeBarButton()
        likeBarButton.InitUI()
        likeBarButton.addTarget(self, action: nil, forControlEvents: .TouchUpInside)
        
        let rightBarButtonItem1 = UIBarButtonItem()
        rightBarButtonItem1.customView = likeBarButton
        
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem2, rightBarButtonItem1 ]
        
        
        
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(DynamicPostWallCell.likeTapped(_:)))
        likeTap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(likeTap)
        likeImg.userInteractionEnabled = true
        
        
        let commentTableFooterView = CommentTableFooterView.instanceFromNib()
        let tableFooterview = UIView(frame: CGRectMake(0,0, UIScreen.mainScreen().bounds.width, 24 ))
        tableFooterview.addSubview(commentTableFooterView)
//        tableFooterview.backgroundColor = UIColor(red: 243, green: 243, blue: 243, alpha: 1)
        
        tableView.tableFooterView = tableFooterview
        
        
        
        
        
        
        let goToLastRow = UITapGestureRecognizer(target: self, action: #selector(self.scrollToLastRow))
        goToLastRow.numberOfTapsRequired = 1
        self.commentsNumLabel.addGestureRecognizer(goToLastRow)
        self.commentsNumLabel.userInteractionEnabled = true
    }
    
    override func viewWillAppear(animated: Bool) {
        let group = dispatch_group_create()
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        self.getAllLikeComment(group, queue: queue){ [weak self] in
            self!.tableView.reloadData()
            self?.spinner?.stopAnimating()
            self?.hideView.hidden = true
            for collectedStory in self!.collectedStories{
                if self!.story.storyId == collectedStory{
                    self!.likeImg.image = UIImage(named: "like_press")
                    break
                }else{
                    self!.likeImg.image = UIImage(named: "like_normal")
                }
            }
            self!.likeNum = self!.story.storyLikeNum
        }
        
        
    }
    func backToPreviousView(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func postBtn(sender: UIButton) {
//        self.postComment.commentContent = commentStroryTitleViewCell.postCommentTextField.text!
        self.postComment.commentContent = commentStroryTitleViewCell.postCommentTextview.text!
//        self.postComment.commentContent = self.postCommentTextfield.text!
        let group = dispatch_group_create()
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//        commentStroryTitleViewCell.postCommentTextField.text! = ""
        commentStroryTitleViewCell.postCommentTextview.text! = ""

//        self.postCommentTextfield.text = ""
        self.resignFirstResponder()
        self.postCommentToServer(self.postComment, group: group, queue: queue){[weak self] in
//            self?.backToLastView()
            self!.getCommentByStoryId(self!.story, group: group, queue: queue, completion: {
                print("storyIdStoryIdStoryId",self!.story.storyId)
                let indexSection = NSIndexSet(index: 0)
                self?.tableView.reloadData()
                self?.commentsNumLabel.text = "\(self!.story.storyComments.count + self!.story.storyTopTwoComments.count)" + " 則留言"
                self?.hideView.hidden = true
            })
            
        }
        //        self.postCommentToServer(postComment) {
        //        }
        
        
    }
    
    @IBAction func goToPlayerVC(sender: UIButton) {
        if isPlayBtnPressed{
            isPlayBtnPressed = false
            playBtnOutlet.setImage(UIImage(named: "musicrating_play"), forState: .Normal)
            appDelegate().tooglePlayBack()
        }else{
            isPlayBtnPressed = true
            playBtnOutlet.setImage(UIImage(named: "icon_stopplaying"), forState: .Normal)
            self.getTrackByStoryId(story.storyId) {
                let appDelegateSharedInstance = appDelegate()
                appDelegateSharedInstance.songsArray = self.songs
                //目前的寫法超過一首歌會crash掉
                var storiesArray = [Story]()
                for int in 1 ... 10{
                    storiesArray.append(self.story)
                }
                let playerVC = PlayerViewController.init(songsArray: self.songs, selectedIndex: 0, storiesArray: storiesArray)
                playerVC.loadView()
                appDelegateSharedInstance.playerVC = playerVC
                appDelegateSharedInstance.currentIndex = 0
                appDelegateSharedInstance.playSongIndex(0)
            }
        }
        
    }
    
    //MARK: -http Request
    func postCommentToServer(comment: Comment, group: dispatch_group_t, queue: dispatch_queue_t, completion:()->Void){
        dispatch_group_enter(group)
        dispatch_group_async(group, queue, {[weak self] in
            ServerManager.addComment(commentContent: comment.commentContent, storyId: self!.story.storyId, postTime: self!.time, completion: {
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
    
    //    func postCommentToServer(comment: Comment,completion:()->Void){
    //        ServerManager.addComment(commentContent: comment.commentContent, storyId: self.story.storyId, postTime: self.time, completion: {
    //
    //        }) { (error) in
    //        }
    //    }
    
 
    func getCommentByStoryId(story: Story, group: dispatch_group_t, queue: dispatch_queue_t, completion:()->Void){
        self.hideView.hidden = false
        dispatch_group_enter(group)
        dispatch_group_async(group, queue, {[weak self] in
            ServerManager.getCommentsByStoryId(storyId: story.storyId, completion: {[weak self] (comments) in
                if !self!.commentsArray.isEmpty{
                    self!.commentsArray.removeAll()
                }
                for comment in comments{
                    if !self!.checkIfCommentIsRepeat(self!.topTwoComments, comment: comment){
                        self?.commentsArray.append(comment)
                    }
                }
                self?.commentsArray = self!.commentsArray.reverse()
                dispatch_group_leave(group)
                }, failure: { (error) in
                    dispatch_group_leave(group)
            })
            })
        dispatch_group_notify(group, queue, {
            dispatch_async(dispatch_get_main_queue(), {
                completion()
            })
        })
    }
    
    func checkIfCommentIsRepeat( comments: [Comment], comment: Comment) -> Bool{
        var isRepeat = false
        for topTwoComment in comments{
            if topTwoComment.commentId == comment.commentId{
                isRepeat = true
                return isRepeat
            }
        }
        return isRepeat
    }
    
    
    func getAllLikeComment(group: dispatch_group_t, queue: dispatch_queue_t, completion:()->Void){
        let mainQueue = dispatch_get_main_queue()
        spinner?.startAnimating()
        dispatch_group_enter(group)
        dispatch_group_async(group, queue, {
            ServerManager.getLikedComment({ (likedCommentArray) in
                self.likedCommentArray = likedCommentArray
                dispatch_group_leave(group)
            }) { (error) in
                dispatch_group_leave(group)
            }
        })
        dispatch_group_notify(group, mainQueue, {
            dispatch_async(dispatch_get_main_queue(), {
                completion()
            })
        })
    }
    
    func getTrackByStoryId(storyId: String,completion:()->()){
        let group = dispatch_group_create()
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let mainQueue = dispatch_get_main_queue()
        dispatch_group_enter(group)
        dispatch_group_async(group, queue, {
            ServerManager.getTrackByStoryId(storyId: storyId, completion: { (songs) in
                let aSong = songs[0]
                for int in 1...10 {
                    self.songs.append(aSong)
                }
                dispatch_group_leave(group)
                
            }) { (error) in
                dispatch_group_leave(group)
                
            }
        })
        dispatch_group_notify(group, mainQueue, {
            dispatch_async(dispatch_get_main_queue(), {
                completion()
            })
        })
        
    }
    
    func backToLastView(){
        self.navigationController?.popViewControllerAnimated(true)
        //        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func likeTapped(sender: UIGestureRecognizer){
        if self.likeImg.image == UIImage(named: "like_normal"){
            self.likeImg.image = UIImage(named: "like_press")
            self.likeNum = self.likeNum + 1
            self.likeNumLabel.text = "\(self.likeNum) 人共鳴"
            ServerManager.collectStory(storyId: self.selectedStioryId, completion: {
                }, failure: { (error) in
                    
            })
        }else{
            self.likeImg.image = UIImage(named: "like_normal")
            self.likeNum = self.likeNum - 1
            self.likeNumLabel.text = "\(self.likeNum) 人共鳴"
            ServerManager.decollectStory(storyId: story.storyId, completion: {
                
                }, failure: { (error) in
                    
            })
        }
    }
    
    
    
}


extension CommentVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
            
        case 2:
            return 1
        case 3:
            //這邊等李洵新增topTwoComments欄位後要改掉
            if self.topTwoComments.count > 0{
                return self.topTwoComments.count
            }else{
                return 0
            }
//            if self.topTwoComments.count == 2{
//                return topTwoComments.count
//            }else if self.topTwoComments.count == 1 && self.commentsArray.count > 0 {
//                return 2
//            }else if self.topTwoComments.count == 1 && self.commentsArray.count == 0{
//                return 1
//            }else if self.topTwoComments.count == 0 && self.commentsArray.count == 1{
//                return 1
//            }else{
//                return 2
//            }
        case 4:
//            if self.commentsArray.count > 2{
//                return 1
//            }else if self.topTwoComments.count == 2 && self.commentsArray.count > 0{
//                return 1
//            }else if self.topTwoComments.count == 1 && self.commentsArray.count > 1{
//                return 1
//            }else{
//                return 0
//            }
//            if self.commentsArray.count > 0 && !self.isCommentsCellExpend{
//                return 1
//            }else{
//                return 0
//            }
            
            if self.isCommentsCellExpend{
                return 0
            }else{
                return 1
            }
        case 5:
//            if self.isCommentsCellExpend{
//                if self.topTwoComments.count == 2 && self.commentsArray.count > 0{
//                    return self.commentsArray.count
//                }else if self.topTwoComments.count == 1 && self.commentsArray.count < 2{
//                    return 0
//                }else if self.topTwoComments.count == 1 && self.commentsArray.count >= 2{
//                    return self.commentsArray.count - 1
//                }else if self.topTwoComments.count == 0 && self.commentsArray.count <= 2{
//                    return 0
//                }else if self.topTwoComments.count == 0 && self.commentsArray.count > 2 {
//                    return self.commentsArray.count - 2
//                }else{
//                    return 0
//                }
//            }
            if self.isCommentsCellExpend{
                return self.commentsArray.count
            }
            return 0
        default:
            return 0
            
            
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentTrackPlayViewCell") as! CommentTrackPlayViewCell
            self.commentTrackPlayViewCell = cell
            cell.configureCell(self.story)
            cell.selectionStyle = .None
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentStoryTitleViewCell") as! CommentStoryTitleViewCell
            cell.selectionStyle = .None
            self.commentStroryTitleViewCell = cell
            if story != nil && selfUser != nil {
                cell.configureCell(story, user: selfUser!)
                let goToProfileTap = UITapGestureRecognizer(target: self, action: #selector(userProfileTapped))
                goToProfileTap.numberOfTapsRequired = 1
                cell.userProfileImg.addGestureRecognizer(goToProfileTap)
                cell.userProfileImg.userInteractionEnabled = true
                self.userKkboxId = cell.userKkboxId
                
                let goToCommentProfileTap = UITapGestureRecognizer(target: self, action: #selector(postProfileTapped))
                goToCommentProfileTap.numberOfTapsRequired = 1
                cell.whoPostStoryProfileImg.addGestureRecognizer(goToCommentProfileTap)
                cell.whoPostStoryProfileImg.userInteractionEnabled = true
                self.postKkboxId = cell.postKkboxId
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentSecondHeaderViewCell") as! CommentSecondHeaderViewCell
            cell.anotherComments.text = "其他回應 ( \(commentsArray.count+topTwoComments.count) )"
            cell.selectionStyle = .None
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentRespondCell") as! CommentRespondCell
            cell.commentRespondCelldelegate = self

            cell.selectionStyle = .None
            if self.topTwoComments.count > 0{
                let comment = self.topTwoComments[indexPath.row]
                cell.configureCell(comment)
                for likedComment in likedCommentArray {
                    if comment.commentId == likedComment{
                        cell.likeImg.image = UIImage(named: "icon_like_actived")
                        break
                    }else{
                        cell.likeImg.image = UIImage(named: "icon_like_normal")
                    }
                }
            }
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentThirdHeaderViewCell") as! CommentThirdHeaderViewCell
            cell.selectionStyle = .None
            return cell
        case 5:
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentRespondCell") as! CommentRespondCell
            cell.commentRespondCelldelegate = self
            cell.selectionStyle = .None
            if self.commentsArray.count > 0{
                print("if self.commentsArray.count > 0",commentsArray.count)
                let comment = self.commentsArray[indexPath.row]
                cell.configureCell(comment)
                
                for likedComment in likedCommentArray {
                    if comment.commentId == likedComment{
                        cell.likeImg.image = UIImage(named: "icon_like_actived")
                        break
                    }else{
                        cell.likeImg.image = UIImage(named: "icon_like_normal")
                    }
                }
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentRespondCell") as! CommentRespondCell
            cell.selectionStyle = .None
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 263
        case 1:
            return UITableViewAutomaticDimension
        case 2:
            return 50
        case 3:
            return UITableViewAutomaticDimension
        case 4:
            return 50
        case 5:
            return UITableViewAutomaticDimension
        default:
            return 0
        }
    }
    
    //    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        if section == 2{
    //            return 50
    //        }
    //        return 0
    //    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 263
        case 1:
            return 210
        case 3:
            return 155
        case 4:
            return 155
        default:
            return 50
        }
    }
    
    
    
    
    
    @IBAction func clickExpendedBtn(sender: UIButton) {
        if !self.isCommentsCellExpend {
            isCommentsCellExpend = true
            tableView.reloadData()

//            tableView.reloadSections(NSIndexSet(index: 5), withRowAnimation: .Fade)
        } else {
            isCommentsCellExpend = false
            tableView.reloadSections(NSIndexSet(index: 5), withRowAnimation: .Fade)
            
        }
    }

    func scrollToLastRow() {
        let indexPath = NSIndexPath(forRow: 0, inSection: 3)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    }

    
    func postProfileTapped(sender: UIGestureRecognizer){
        
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profileVC.kkboxId = self.postKkboxId
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func userProfileTapped(sender: UIGestureRecognizer){
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        print("clickId:",self.userKkboxId)
        profileVC.kkboxId = self.userKkboxId
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func goToProfileViewController(sender: UIGestureRecognizer) {
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(profileVC, animated: true)
    }

    @IBAction func goToPlayMoreVC(sender: UIButton) {
        self.getTrackByStoryId(story.storyId) {
            let song = self.songs[0]
            let myLibraryMoreVC = MyLibraryMoreViewController(nibName: "MyLibraryMoreViewController", bundle: nil)
            myLibraryMoreVC.song = song
            
//            myLibraryMoreVC.navigationController!.modalPresentationStyle = .OverCurrentContext
            
                
//            self.presentViewController(myLibraryMoreVC, animated: true, completion: nil)
            self.navigationController?.presentViewController(myLibraryMoreVC, animated: true, completion: nil)
        }
        
    }
    
    
    func animateViewMoving(up:Bool, moveValue :CGFloat){
        
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.tableView.frame = CGRectOffset(self.tableView.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
}


extension CommentVC: CommentRespondCellDelegate{
    func passCell(cell: CommentRespondCell?) {
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profileVC.kkboxId = (cell?.kkboxId)!
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
}







