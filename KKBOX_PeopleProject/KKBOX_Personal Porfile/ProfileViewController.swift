//
//  ProfileViewController.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/18.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Haneke

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundProfileImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var fansNumberLabel: UILabel!
    @IBOutlet weak var followingsNumberLabel: UILabel!
    @IBOutlet weak var musicStyleLabel1: UILabel!
    @IBOutlet weak var musicStyleLabel2: UILabel!
    @IBOutlet weak var musicStyleLabel3: UILabel!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var profileSegmentedControl: ProfileSegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var scrollContentViewHeight: NSLayoutConstraint!
    
    var kkboxId = NSUserDefaults.standardUserDefaults().valueForKey("meId") as! String
    var otherUserName: String?
    var followed: Bool!
    var followersArray = [[String:String]]()
    var followingsArray = [[String:String]]()
    
    var currentViewController: UIViewController?
    lazy var musicVC: MusicViewController = MusicViewController(nibName: "MusicViewController", bundle: nil)
    lazy var storyVC: StoryViewController = StoryViewController(nibName: "StoryViewController", bundle: nil)
    lazy var followerVC: FollowerViewController = FollowerViewController(nibName: "FollowerViewController", bundle: nil)
    lazy var followingVC: FollowingViewController = FollowingViewController(nibName: "FollowingViewController", bundle: nil)
    lazy var musicStyleVC: MusicStyleViewController = MusicStyleViewController(nibName: "MusicStyleViewController", bundle: nil)
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollContentView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 1349)
        
        initUI()
        displayCurrentTab(TabIndex.MusicTab.rawValue)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
                
        if kkboxId != NSUserDefaults.standardUserDefaults().valueForKey("meId") as? String {
            let otherPeopleId = kkboxId
            getUserInfo(crystal_login, id: otherPeopleId, completion: {
                
            })
        } else {
            getUserInfo(crystal_login, id: kkboxId, completion: {
                
            })
            
        }
    }
    
    
    
    //MARK: - InitUI
    func initUI() {
        
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.alwaysBounceVertical = true
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2
        profileImageView.clipsToBounds = true
        
        let backButton = BackButton()
        backButton.InitUI()
        backButton.addTarget(self, action: #selector(backButtonTapped), forControlEvents: .TouchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = backButton
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let noticeButton = NoticeButton()
        noticeButton.InitUI()
        noticeButton.addTarget(self, action: #selector(noticeButtonTapped), forControlEvents: .TouchUpInside)
        
        let rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.customView = noticeButton
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        profileSegmentedControl.initUI()
        
    }
    
    func noticeButtonTapped(sender: UIButton) {
        
    }
    
    func backButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    //MARK: - HTTP Request
    func getUserInfo(loginInfo: String, id: String, completion:() -> Void) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            ServerManager.login(userInfo: loginInfo, completion: {
                dispatch_async(queue, {
                    ServerManager.getSimpleInfo(userId: id, completion: { (user) in
                        dispatch_async(dispatch_get_main_queue(), {
                            let imageURLString = user.userProfileImageUrl
                            let imageURL = NSURL(string: imageURLString)
                            print("kkboxId:kkboxId:kkboxId:",self.kkboxId)
                            if self.kkboxId != NSUserDefaults.standardUserDefaults().valueForKey("meId") as? String {
//                                if self.otherUserName != nil {
//                                    self.title = self.otherUserName!
//                                    print("self.otherUserName!",self.otherUserName!)
//                                   
//                                    self.userNameLabel.text = self.otherUserName!
//                                }
                                self.title = user.userName
                                self.userNameLabel.text = user.userName
                            } else {
                                let userName = NSUserDefaults.standardUserDefaults().valueForKey("meName") as? String
                                self.title = userName
                                self.userNameLabel.text = userName
                            }
                            
                            self.backgroundProfileImageView.hnk_setImageFromURL(imageURL!)
                            self.profileImageView.hnk_setImageFromURL(imageURL!)
                            
                            if user.followings.count == 0 {
                                self.followingsNumberLabel.text = "0"
                            } else {
                                self.followingsArray = user.followings
                                self.followingsNumberLabel.text = "\(user.followings.count)"
                            }
                            
                            if user.followers.count == 0 {
                                self.fansNumberLabel.text = "0"
                            } else {
                                self.followersArray = user.followers
                                self.fansNumberLabel.text = "\(user.followers.count)"
                            }
                            
                            self.passValueToMusicWall(id, completion: {
                                self.displayCurrentTab(TabIndex.MusicTab.rawValue)
                            })
                        })
                        }, failure: { (error) in
                            print("getSimpleInfo error : \(error)")
                    })
                    
                })
                dispatch_async(queue, {
                    ServerManager.isFollowing(userId: id, completion: { (result) in
                        dispatch_async(dispatch_get_main_queue(), {
                            self.followed = result as! Bool
                            
                            if self.kkboxId != NSUserDefaults.standardUserDefaults().valueForKey("meId") as? String {
                                if self.followed != true {
                                    let image = UIImage(named: "btn_follow")
                                    self.followingButton.setImage(image, forState: .Normal)
                                } else {
                                    let image = UIImage(named: "btn_follow_actived")
                                    self.followingButton.setImage(image, forState: .Normal)
                                }
                            } else {
                                let image = UIImage(named: "btn_edit")
                                self.followingButton.setImage(image, forState: .Normal)
                            }
                        })
                        }, failure: { (error) in
                            print("isFollowing error : \(error)")
                    })
                })
            }) { (error) in
                print("login error : \(error)")
            }
        }
    }
    
    func passValueToMusicWall(id: String, completion:() -> Void) {
        self.musicVC.userId = id
        self.musicVC.getInfo(id) {
            
        }
        completion()
    }
    
    func passValueToStoryWall(id: String, completion:() -> Void) {
        self.storyVC.userId = id
        self.storyVC.getMyPostInfo(id) {
            completion()
        }
    }
    
    
    //MARK: - Action
    @IBAction func musicStyleGestureTapped(sender: AnyObject) {
        self.navigationController?.pushViewController(self.musicStyleVC, animated: true)
    }
    
    @IBAction func followerGestureTapped(sender: AnyObject) {
        followerVC = FollowerViewController.init(followersArray: self.followersArray)
        self.navigationController?.pushViewController(followerVC, animated: true)
    }
    
    @IBAction func followingGestureTapped(sender: AnyObject) {
        followingVC = FollowingViewController.init(followingsArray: self.followingsArray)
        self.navigationController?.pushViewController(followingVC, animated: true)
    }
    
    @IBAction func followingButtonTapped(sender: AnyObject) {
        if followed != true {
            let image = UIImage(named: "btn_follow_actived")
            self.followingButton.setImage(image, forState: .Normal)
            
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            dispatch_async(queue, {
                ServerManager.addFollowing(userId: self.kkboxId, completion: {
                    self.getUserInfo(crystal_login, id: self.kkboxId, completion: {})
                    }, failure: { (error) in })
            })
        } else {
            let image = UIImage(named: "btn_follow")
            self.followingButton.setImage(image, forState: .Normal)
            
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            dispatch_async(queue, {
                ServerManager.dropFollowing(userId: self.kkboxId, completion: {
                    self.getUserInfo(crystal_login, id: self.kkboxId, completion: {})
                    }, failure: { (error) in })
            })
        }
    }
    
    
    
    //MARK: - SegmentedControl
    func displayCurrentTab(tabIndex: Int) {
        if let vc = viewControllerForSelectedTab(tabIndex) {
            self.addChildViewController(vc)
            vc.didMoveToParentViewController(self)
            
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    func viewControllerForSelectedTab(index: Int) -> UIViewController? {
        var vc: UIViewController?
        
        switch index {
        case TabIndex.MusicTab.rawValue:
            vc = self.musicVC
        case TabIndex.StoryTab.rawValue:
            vc = self.storyVC
        default:
            return nil
        }
        return vc
    }
    
    
    @IBAction func profileSegmentedControlTapped(sender: AnyObject) {
        self.currentViewController?.view.removeFromSuperview()
        self.currentViewController?.removeFromParentViewController()
        
        switch sender.selectedSegmentIndex {
        case TabIndex.MusicTab.rawValue:
            self.passValueToMusicWall(kkboxId, completion: {
                self.scrollContentViewHeight.constant = 1100
            })
            displayCurrentTab(TabIndex.MusicTab.rawValue)
            
        case TabIndex.StoryTab.rawValue:
            self.passValueToStoryWall(kkboxId, completion: {
                self.storyVC.loadViewIfNeeded()
                self.storyVC.tableView.layoutIfNeeded()
                let tableViewHeight = self.storyVC.tableView.contentSize.height
                self.scrollContentViewHeight.constant = tableViewHeight + 262
                self.storyVC.tableView.scrollEnabled = false
                
                self.storyVC.loadingIndicator.stopAnimating()
                self.storyVC.grayBackgroundView.hidden = true
            })
            displayCurrentTab(TabIndex.StoryTab.rawValue)
        default:
            break
        }
    }
}
