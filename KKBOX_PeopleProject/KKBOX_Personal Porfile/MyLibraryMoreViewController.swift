//
//  MyLibrarayMoreViewController.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/10/24.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Haneke

class MyLibraryMoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var song: Song!
    var dataArray = [("icon_writestory", "為此首歌新增貼文"), ("icon_collection", "收藏這首歌曲"), ("icon_add-1", "加到我的音樂庫"), ("icon_offlinesong", "下載"), ("icon_share", "分享")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true

        tableView.registerNib(UINib(nibName: "ActionSheetAlbumTableViewCell", bundle: nil), forCellReuseIdentifier: "ActionSheetAlbumTableViewCell")
        tableView.registerNib(UINib(nibName: "ActionSheetArtistTableViewCell", bundle: nil), forCellReuseIdentifier: "ActionSheetArtistTableViewCell")
        tableView.registerNib(UINib(nibName: "ActionSheetTableViewCell", bundle: nil), forCellReuseIdentifier: "ActionSheetTableViewCell")
    }
    
    
    
    //MARK: - Action
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    //MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat!
        
        if indexPath.row <= 1 {
            height = 65
        }
        if indexPath.row >= 2 {
            height = 55
        }
        
        return height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //專輯
        if indexPath.row == 1 {
        
        }
        //藝人
        if indexPath.row == 2 {
            let addPostVC = AddPostVC(nibName: "AddPostVC", bundle: nil)
            addPostVC.selectedSong = song
            self.showViewController(addPostVC, sender: self)
//            self.navigationController?.pushViewController(addPostVC, animated: true)
            

            self.dismissViewControllerAnimated(true){
//                self.navigationController?.pushViewController(addPostVC, animated: true)
//                self.showViewController(addPostVC, sender: self)
                
            }
        }
        //為此首歌新增貼文
        if indexPath.row == 3 {
        
        }
        //收藏這首歌曲
        if indexPath.row == 4 {
        
        }
        //加到我的音樂庫
        if indexPath.row == 5 {
        
        }
        //下載
        if indexPath.row == 6 {
        
        }
        //分享
        if indexPath.row == 7 {
        
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.row == 0 {
            let albumCell = tableView.dequeueReusableCellWithIdentifier("ActionSheetAlbumTableViewCell", forIndexPath: indexPath) as! ActionSheetAlbumTableViewCell
            albumCell.configCell(song)
            cell = albumCell
        }
        
        if indexPath.row == 1 {
            let artistCell = tableView.dequeueReusableCellWithIdentifier("ActionSheetArtistTableViewCell", forIndexPath: indexPath) as! ActionSheetArtistTableViewCell
            artistCell.configCell(song)
            cell = artistCell
        }
        if indexPath.row >= 2 {
            let commonCell = tableView.dequeueReusableCellWithIdentifier("ActionSheetTableViewCell", forIndexPath: indexPath) as! ActionSheetTableViewCell
            let data = self.dataArray[indexPath.row - 2]
            commonCell.configCell(data)
            cell = commonCell
        }
        
        return cell
    }
}
