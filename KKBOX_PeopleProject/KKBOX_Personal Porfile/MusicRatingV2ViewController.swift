//
//  MusicRatingV2ViewController.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/25.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Haneke

class MusicRatingV2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RatingMoreButtonDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalSongsLabel: UILabel!
    
    let grayBackgroundView = UIView()
    let loadingIndicator = UIActivityIndicatorView()
    
    var songsArray: [Song]!
    let originalHeaderView = OriginalPlayHeaderView.instanceFromNib()
    let headerView = PlayHeaderView.instanceFromNib()
    var storiesArray: [Story]?
    
    convenience init(songsArray: [Song]) {
        self.init(nibName: "MusicRatingV2ViewController", bundle: nil)
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
        addTableheaderViewAndBackgroundView()
        
        tableView.registerNib(UINib(nibName: "MusicRatingTableViewCell", bundle: nil), forCellReuseIdentifier: "MusicRatingTableViewCell")
    }
    
    func addTableheaderViewAndBackgroundView() {
        let headerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width,160))
        headerView.backgroundColor = UIColor.clearColor()
        
        let iconImage = UIImage(named: "style_icon_topsong")
        let iconImageView = UIImageView(image: iconImage!)
        iconImageView.frame = CGRectMake((headerView.bounds.size.width - 148)/2, (headerView.bounds.size.height - 64)/2, 148, 64)
        
        let moreButton = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 30 - 16, 16, 30, 30))
        moreButton.setImage(UIImage(named: "btn_more_white-1"), forState: .Normal)
        moreButton.addTarget(self, action: #selector(MusicRatingV2ViewController.moreButtonTapped(_:)), forControlEvents: .TouchUpInside)
        
        headerView.addSubview(moreButton)
        headerView.addSubview(iconImageView)
        
        let song = songsArray[0]
        let imageURLString = song.album?.imageURL
        let imageURL = NSURL(string: imageURLString!)
        let imageData = NSData(contentsOfURL: imageURL!)
        let image = UIImage(data: imageData!)
        
        let backgroundImageView = BackgroundImageView(frame: headerView.bounds)
        backgroundImageView.addImageView(image!, width: UIScreen.mainScreen().bounds.size.width, height: 400)
        
        self.tableView.backgroundView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 160))
        self.tableView.backgroundView?.backgroundColor = UIColor(red: 224/255, green: 226/255, blue: 230/255, alpha: 1)
        self.tableView.backgroundView?.addSubview(backgroundImageView)
        self.tableView.tableHeaderView = headerView
    }
    
    func initUI() {
        self.title = "聽歌排行榜"
        
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
    
    func noticeButtonTapped(sender: UIButton) {
        
    }
    
    func backButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func moreButtonTapped(sender: UIButton) {
    }
    
    
    
    
    //MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number: Int?
        number = songsArray.count
        return number!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat?
        height = 65
        return height!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.getSongStories((self.songsArray[indexPath.row].trackId)){
            if self.storiesArray != nil{
                let playerVC = PlayerViewController.init(songsArray: (self.songsArray)!, selectedIndex: indexPath.row, storiesArray: self.storiesArray!)
                let appDelegateSharedInstance = appDelegate()
                appDelegateSharedInstance.songsArray = self.songsArray
                appDelegateSharedInstance.currentIndex = indexPath.row
                appDelegateSharedInstance.playSongIndex(indexPath.row)
                self.navigationController?.pushViewController(playerVC, animated: false)
                appDelegateSharedInstance.playSongIndex(indexPath.row)
            }
        }
        
        
        
    }
    
    func getDispatchTimeByDate(date: NSDate) -> dispatch_time_t {
        let interval = date.timeIntervalSince1970
        var second = 0.0
        let subsecond = modf(interval, &second)
        var time = timespec(tv_sec: __darwin_time_t(second), tv_nsec: (Int)(subsecond * (Double)(NSEC_PER_SEC)))
        return dispatch_walltime(&time, 0)
    }
    
    func getSongStories(trackId: String, completion:()->()){
        let group = dispatch_group_create()
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_group_enter(group)
        dispatch_group_async(group, queue, {
            ServerManager.stories(trackId: trackId, completion: { [weak self](stories) in
                self?.storiesArray = stories
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        //dropFirst會讓第0個index為nil，不會往前遞補
        //            let dropSongs = songsArray.dropFirst()
        self.totalSongsLabel.text = "\(songsArray.count) Songs"
        
        let song = songsArray[indexPath.row]
        let songCell = tableView.dequeueReusableCellWithIdentifier("MusicRatingTableViewCell", forIndexPath: indexPath) as! MusicRatingTableViewCell
        
        if songCell.buttonDelegate == nil {
            songCell.buttonDelegate = self
        }
        
        songCell.ratingNumberLabel.text = "\(indexPath.row+1)"
        songCell.configCell(song)
        cell = songCell
        
        return cell!
    }
    
    
    
    //MARK: - MoreButtonDelegate
    func cellMoreButtonTapped(cell: MusicRatingTableViewCell) {
        let indexPath = tableView.indexPathForCell(cell)
        let song = self.songsArray[(indexPath?.row)!]
        let myLibraryMoreVC = MyLibraryMoreViewController(nibName: "MyLibraryMoreViewController", bundle: nil)
        
        myLibraryMoreVC.modalPresentationStyle = .OverCurrentContext
        myLibraryMoreVC.song = song
        
        self.presentViewController(myLibraryMoreVC, animated: true, completion: nil)
    }
}
