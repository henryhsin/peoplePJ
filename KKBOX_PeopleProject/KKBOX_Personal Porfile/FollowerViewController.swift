//
//  FollowerViewController.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/24.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class FollowerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPeopleLabel: UILabel!
    
    var followersArray: [[String:String]]!
    
    lazy var profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
    
    convenience init(followersArray: [[String:String]]) {
        self.init(nibName: "FollowerViewController", bundle: nil)
        self.followersArray = followersArray
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        tableView.registerNib(UINib(nibName: "FollowerTableViewCell", bundle: nil), forCellReuseIdentifier: "FollowerTableViewCell")
    }
    
    func initUI() {
        self.title = "粉絲人數"
        self.totalPeopleLabel.text = "\(followersArray.count)位使用者"
        
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
    }
    
    func backButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func noticeButtonTapped(sender: UIButton) {
    
    }


   //MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followersArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedIndexPath = tableView.indexPathForSelectedRow
        let followerId = self.followersArray[(selectedIndexPath?.row)!]["kkbox_id"]
        let followerName = self.followersArray[(selectedIndexPath?.row)!]["name"]
        
        profileVC.kkboxId = followerId!
        profileVC.otherUserName = followerName
        self.showViewController(profileVC, sender: self)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let follower = followersArray[indexPath.row]
        let cell = self.tableView.dequeueReusableCellWithIdentifier("FollowerTableViewCell", forIndexPath: indexPath) as! FollowerTableViewCell
        cell.configCell(follower)
        return cell
    }
}
