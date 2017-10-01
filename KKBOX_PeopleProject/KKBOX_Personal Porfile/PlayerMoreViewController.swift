//
//  PlayerMoreViewController.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/10/24.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class PlayerMoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var song: Song!
    var dataArray = [("icon_writestory_normal", "為此首歌新增貼文"), ("np_sheetsicon_nplist_normal", "播放列表"), ("icon_dts_normal", "播放設定"), ("np_sheetsicon_share_normal", "分享"), ("np_sheetsicon_listen_together_off", "開台一起聽")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "ActionSheetAlbumTableViewCell", bundle: nil), forCellReuseIdentifier: "ActionSheetAlbumTableViewCell")
        tableView.registerNib(UINib(nibName: "ActionSheetArtistTableViewCell", bundle: nil), forCellReuseIdentifier: "ActionSheetArtistTableViewCell")
        tableView.registerNib(UINib(nibName: "ActionSheetTableViewCell", bundle: nil), forCellReuseIdentifier: "ActionSheetTableViewCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            self.navigationController?.pushViewController(addPostVC, animated: true)

        }
        //為此首歌新增貼文
        if indexPath.row == 3 {
                    }
        //播放列表
        if indexPath.row == 4 {
            
        }
        //播放設定
        if indexPath.row == 5 {
            
        }
        //分享
        if indexPath.row == 6 {
            
        }
        //開台一起聽
        if indexPath.row == 7 {
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.row == 0 {
            let albumCell = tableView.dequeueReusableCellWithIdentifier("ActionSheetAlbumTableViewCell", forIndexPath: indexPath) as! ActionSheetAlbumTableViewCell
            albumCell.configCell(song)
            albumCell.setPlayerMoreCellUI()
            cell = albumCell
        }
        
        if indexPath.row == 1 {
            let artistCell = tableView.dequeueReusableCellWithIdentifier("ActionSheetArtistTableViewCell", forIndexPath: indexPath) as! ActionSheetArtistTableViewCell
            artistCell.configCell(song)
            artistCell.setPlayerMoreCellUI()
            cell = artistCell
        }
        
        if indexPath.row >= 2 {
            let commonCell = tableView.dequeueReusableCellWithIdentifier("ActionSheetTableViewCell", forIndexPath: indexPath) as! ActionSheetTableViewCell
            let data = self.dataArray[indexPath.row - 2]
            commonCell.configCell(data)
            commonCell.setPlayerMoreCellUI()
            cell = commonCell
        }
        return cell
    }

}
