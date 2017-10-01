//
//  StoryViewController.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/22.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let grayBackgroundView = UIView()
    let loadingIndicator = UIActivityIndicatorView()
    
    var userId: String?
    var myStories = [Story]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "DynamicPostWallCell", bundle: nil), forCellReuseIdentifier: "DynamicPostWallCell")
        
        initUI()
    }
    
    func initUI() {
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = UIColor.clearColor()
    
        grayBackgroundView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 200)
        grayBackgroundView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.frame = CGRect(x: grayBackgroundView.bounds.width/2 - 15, y: 24, width: 30, height: 30)
        loadingIndicator.startAnimating()
        
        grayBackgroundView.addSubview(loadingIndicator)
        self.view.addSubview(grayBackgroundView)
    }
    
    
    
    
    //MARK: - HTTP Request
    func getMyPostInfo(kkboxId: String, completion:() -> Void) {
        if !self.myStories.isEmpty{
            self.myStories.removeAll()
        }
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            ServerManager.getFullInfo(userId: kkboxId, completion: { (user) in
                dispatch_async(dispatch_get_main_queue(), {
                    for postedStory in user.userPostedStrory{
                        self.myStories.append(postedStory)
                    }
                    self.tableView.reloadData()
                    completion()
                })
                }
                ,failure: { (error) in
                    print("error")
            })
        }
    }

    
    
    
    //MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myStories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let storyCell = tableView.dequeueReusableCellWithIdentifier("DynamicPostWallCell") as! DynamicPostWallCell
        print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG")
        print("storyCell::",storyCell.profileImg)
        print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG")
        if self.myStories.count > 0{
            let story = self.myStories[indexPath.row]
            storyCell.configureCell(story)
            storyCell.layer.shadowOffset = CGSizeMake(1, 0);
            storyCell.layer.shadowColor = UIColor.blueColor().CGColor
            storyCell.layer.shadowRadius = 5;
            storyCell.layer.shadowOpacity = 0.25
        }
        return storyCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var comments = [Comment]()
        var topTwoComments = [Comment]()
        var commentVC: CommentVC!
        
        comments = myStories[indexPath.row].storyComments
        topTwoComments = myStories[indexPath.row].storyTopTwoComments
        commentVC = CommentVC.init(topTwoComments: topTwoComments,comments: comments, story: myStories[indexPath.row], user: nil)
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 207
    }
}

