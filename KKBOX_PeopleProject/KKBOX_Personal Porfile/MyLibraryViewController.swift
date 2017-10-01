//
//  MyLibraryViewController.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/18.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Haneke

class MyLibraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var profileVC: ProfileViewController!
    
    let grayBackgroundView = UIView()
    let loadingIndicator = UIActivityIndicatorView()
    
    var playlistsArray = [Playlist]()
    var userImageURL: String?
    
    let personalDataArray = [("icon_allsong", "全部歌曲"), ("icon_offlinesong", "可離線播放歌曲"), ("icon_recentlyplaylist", "播放紀錄")]
    let collectedDataArray = [("icon_collection", "收藏歌曲"), ("icon_collection", "收藏專輯"), ("icon_collection", "收藏歌單")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        tableView.registerNib(UINib(nibName: "MyLibraryTableViewCell", bundle: nil), forCellReuseIdentifier: "MyLibraryTableViewCell")
        tableView.registerNib(UINib(nibName: "MyLibraryPersonalTableViewCell", bundle: nil), forCellReuseIdentifier: "MyLibraryPersonalTableViewCell")
        tableView.registerNib(UINib(nibName: "MyPlaylistTableViewCell", bundle: nil), forCellReuseIdentifier: "MyPlaylistTableViewCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        getServerAuth()
    }
    
    func initUI() {
        self.title = "我的音樂庫"
        
        tableView.showsVerticalScrollIndicator = false
        
        grayBackgroundView.frame = UIScreen.mainScreen().bounds
        grayBackgroundView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.center = grayBackgroundView.center
        loadingIndicator.startAnimating()
        
        grayBackgroundView.addSubview(loadingIndicator)
        self.view.addSubview(grayBackgroundView)
    }
    
    func getServerAuth(){
        if let meId = NSUserDefaults.standardUserDefaults().valueForKey("meId") as? String {
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            dispatch_async(queue, {
                ServerManager.getSimpleInfo(userId: meId, completion: { (user) in
                    self.userImageURL = user.userProfileImageUrl
                    self.tableView.reloadData()
                    }, failure: { (error) in
                        print("MyLibraryVC getSimpleInfo error: \(error)")
                })
            })
            
            ServerManager.getPlaylist(userId: meId, completion: { (playlists) in
                self.playlistsArray = playlists
                self.tableView.reloadData()
                
                self.loadingIndicator.stopAnimating()
                self.grayBackgroundView.hidden = true
                }, failure: { (error) in
                    print("getPlaylist error: \(error)")
            })
        }
        
    }
    
    
    
    //MARK: - TableView Delegate and DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int!
        
        if section == 0 {
            count = personalDataArray.count + 1
        }
        if section == 1 {
            count = collectedDataArray.count
        }
        if section == 2 {
            count = playlistsArray.count
        }
        return count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String!
        
        if section == 1 {
            title = "我的收藏"
        }
        
        if section == 2 {
            title = "我的歌單"
        }
        return title
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat!
        
        if section == 0 {
            height = 0
        }
        if section == 1 {
            height = 50
        }
        if section == 2 {
            height = 50
        }
        
        return height
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat!
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                height = 65
            }
            
            if indexPath.row != 0 {
                height = 44
            }
        }
        
        if indexPath.section == 1 {
            height = 44
        }
        
        if indexPath.section == 2 {
            height = 65
        }
        return height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
                self.navigationController?.showViewController(profileVC, sender: self)
            }
            
            if indexPath.row != 0 {
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                cell?.userInteractionEnabled = false
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
            }
        }
        
        if indexPath.section == 1 {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.userInteractionEnabled = false
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
        }
        
        if indexPath.section == 2 {
            let playlist = self.playlistsArray[indexPath.item]
            
            let songListsVC = SongListViewController(nibName: "SongListViewController", bundle: nil)
            songListsVC.songsArray = playlist.songs!
            songListsVC.titleName = playlist.playlistName
            
            self.navigationController?.pushViewController(songListsVC, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let personalCell = tableView.dequeueReusableCellWithIdentifier("MyLibraryPersonalTableViewCell", forIndexPath: indexPath) as! MyLibraryPersonalTableViewCell
                
                if let userName = NSUserDefaults.standardUserDefaults().valueForKey("meName") as? String {
                    personalCell.personalNameLabel.text = userName
                } else {
                    personalCell.personalNameLabel.text = ""
                }
                
                if let imageURLString = userImageURL {
                    let imageURL = NSURL(string: imageURLString)
                    
                    personalCell.personalImageView.hnk_setImageFromURL(imageURL!)
                    personalCell.personalBackgroundImageView.hnk_setImageFromURL(imageURL!)
                } else {
                    personalCell.personalImageView.image = nil
                    personalCell.personalBackgroundImageView.image = nil
                }
                
                cell = personalCell
            }
            
            if indexPath.row != 0 {
                let myLibraryCell = tableView.dequeueReusableCellWithIdentifier("MyLibraryTableViewCell", forIndexPath: indexPath) as! MyLibraryTableViewCell
                let (imageName, title) = personalDataArray[indexPath.row - 1]
                myLibraryCell.nameLabel.text = title
                myLibraryCell.iconImageView.image = UIImage(named: imageName)
                cell = myLibraryCell
            }
        }
        
        if indexPath.section == 1 {
            let myLibraryCell = tableView.dequeueReusableCellWithIdentifier("MyLibraryTableViewCell", forIndexPath: indexPath) as! MyLibraryTableViewCell
            let (imageName, title) = collectedDataArray[indexPath.row]
            myLibraryCell.nameLabel.text = title
            myLibraryCell.iconImageView.image = UIImage(named: imageName)
            cell = myLibraryCell
        }
        
        if indexPath.section == 2 {
            let playlist = self.playlistsArray[indexPath.row]
            let playlistCell = tableView.dequeueReusableCellWithIdentifier("MyPlaylistTableViewCell", forIndexPath: indexPath) as! MyPlaylistTableViewCell
            playlistCell.configCell(playlist)
            cell = playlistCell
        }
        
        return cell
    }
}
