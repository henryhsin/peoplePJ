//
//  MusicRatingViewController.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/24.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class MusicRatingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalSongsLabel: UILabel!
    
    var songsArray: [Song]!
    
    
    convenience init(songsArray: [Song]) {
        self.init(nibName: "MusicRatingViewController", bundle: nil)
        self.songsArray = songsArray
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
        
        tableView.registerNib(UINib(nibName: "FirstMusicRatingTableViewCell", bundle: nil), forCellReuseIdentifier: "FirstMusicRatingTableViewCell")
        tableView.registerNib(UINib(nibName: "MusicRatingTableViewCell", bundle: nil), forCellReuseIdentifier: "MusicRatingTableViewCell")
    }
    
    func initUI() {
        self.title = "聽歌排行榜"
        self.totalSongsLabel.text = "\(songsArray.count) Songs"
        let backButton = BackButton()
        backButton.InitUI()
        backButton.addTarget(self, action: #selector(backButtonTapped), forControlEvents: .TouchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = backButton
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
    }
    
    func backButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    //MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number: Int?
        
        if section == 0 {
            number = 1
        }
        if section == 1 {
            number = songsArray.count - 1
        }
        return number!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat?
        
        if indexPath.section == 0 {
            height = 179
        }
        if indexPath.section == 1 {
            height = 65
        }
        return height!
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            songsArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if indexPath.section == 0 {
            let song = songsArray[0]
            let songCell = tableView.dequeueReusableCellWithIdentifier("FirstMusicRatingTableViewCell", forIndexPath: indexPath) as! FirstMusicRatingTableViewCell
            songCell.configCell(song)
            cell = songCell
        }
        if indexPath.section == 1 {
            //dropFirst會讓第0個index為nil，不會往前遞補
//            let dropSongs = songsArray.dropFirst()
            
            var newSongsArray = [Song]()
            for i in 1...songsArray.count-1 {
                let song = songsArray[i]
                newSongsArray.append(song)
            }
            let song = newSongsArray[indexPath.row]
            let songCell = tableView.dequeueReusableCellWithIdentifier("MusicRatingTableViewCell", forIndexPath: indexPath) as! MusicRatingTableViewCell
            
            songCell.ratingNumberLabel.text = "\(indexPath.row+2)"
            songCell.configCell(song)
            cell = songCell
        }
        return cell!
    }
}
