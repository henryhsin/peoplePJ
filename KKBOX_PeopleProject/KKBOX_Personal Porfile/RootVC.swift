//
//  RootVC.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/12.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

class RootVC: UIViewController {
    var feedVC: FeedVC!
    
    var user: User!
    var playlist: Playlist!
    var myStories: [Story]!

    
    @IBOutlet weak var myView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.blackColor()
        
        // 導覽列標題
        self.title = "RootVC"
        
        // 導覽列底色
        self.navigationController?.navigationBar.barTintColor =
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        
        // 導覽列是否半透明
        self.navigationController?.navigationBar.translucent = true
        
        // 建立一個按鈕
        let myButton = UIButton(frame: CGRect(
            x: 100, y: 100, width: 120, height: 40))
        myButton.setTitle("Article", forState: .Normal)
        myButton.backgroundColor = UIColor.blueColor()
        myButton.addTarget(
            self, 
            action: #selector(RootVC.article),
            forControlEvents: .TouchUpInside)
 
        self.view.addSubview(myButton)
        
        
        
        
        
        
        
        var commentScrollView = CommentScrollView.instanceFromNib()
//        self.myView.addSubview(commentScrollView)
//        myView.contentSize = CGSizeMake(240, 700)
//        myView.contentOffset = CGPoint(x: 0, y: 70)
//        
        
        
        
        
        
        
        
        ServerManager.login(userInfo: "kkbox:kkbox", completion: {
            
            
//           ServerManager.getFullInfo(username: "kkbox", completion: { (user) in
//            print(user.userPostedStrory)
//            }, failure: { (error) in
//                
//           })
            
            
//            ServerManager.getMyStory({ (stories) in
//                for story in stories{
//                    
//                        print(story.storyId)
//                        print(story.storyComments)
//          
//                }
//                }, failure: { (error) in
//                    
//            })
            
            
            
//            ServerManager.getFullInfo(username: "kkbox", completion: { (user) in
//                for follow in user.followers{
//                    print(follow.name)
//                }
//                
//                for follow in user.followings{
//                    print(follow.name)
//                }
//                
//               
//
//                
//                }, failure: { (error) in
//                    
//            })
//            

            
            
            
            
           
        }) { (error) in
            print(error)
        }
    }

    func article() {
        feedVC = FeedVC.init(nibName: "FeedVC", bundle: nil)
    
        self.navigationController?.pushViewController(feedVC, animated: true)
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
