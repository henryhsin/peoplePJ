//
//  MusicStyleViewController.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/26.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class MusicStyleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, StyleMoreButtonDelegate {
    
    @IBOutlet weak var musicStyleSegmentedControl: ProfileSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalSongsLabel: UILabel!
    
    let grayBackgroundView = UIView()
    let loadingIndicator = UIActivityIndicatorView()
    
    let headerView = PlayHeaderView.instanceFromNib()
    var songsArray: [Song]!
    var storiesArray = [Story]()

    
    convenience init(songsArray: [Song]) {
        self.init(nibName: "MusicStyleViewController", bundle: nil)
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
        
        tableView.registerNib(UINib(nibName: "MusicStyleTableViewCell", bundle: nil), forCellReuseIdentifier: "MusicStyleTableViewCell")
        
        getMusicStyleSongs(0)
    }
    
    func addTableheaderViewAndBackgroundView(numberOfIndex: Int) {
        let headerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width,160))
        headerView.backgroundColor = UIColor.clearColor()
        
        if numberOfIndex == 0 {
            let image = UIImage(named: "style_icon_jazz")
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRectMake((headerView.bounds.size.width - 60)/2, (headerView.bounds.size.height - 60)/2, 60, 60)
            headerView.addSubview(imageView)
        } else if numberOfIndex == 1 {
            let image = UIImage(named: "style_icon_country")
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRectMake((headerView.bounds.size.width - 60)/2, (headerView.bounds.size.height - 80)/2, 60, 80)
            headerView.addSubview(imageView)
        } else if numberOfIndex == 2 {
            let image = UIImage(named: "style_icon_rock")
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRectMake((headerView.bounds.size.width - 60)/2, (headerView.bounds.size.height - 60)/2, 60, 60)
            headerView.addSubview(imageView)
        }
        
        let song = songsArray[0]
        let imageURLString = song.album?.imageURL
        let imageURL = NSURL(string: imageURLString!)
        let imageData = NSData(contentsOfURL: imageURL!)
        let image = UIImage(data: imageData!)
        
        let backgroundImageView = BackgroundImageView(frame: headerView.bounds)
        backgroundImageView.addImageView(image!, width: UIScreen.mainScreen().bounds.width, height: 400)
        
        self.tableView.backgroundView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 160))
        self.tableView.backgroundView?.backgroundColor = UIColor(red: 224/255, green: 226/255, blue: 230/255, alpha: 1)
        self.tableView.backgroundView?.addSubview(backgroundImageView)
        self.tableView.tableHeaderView = headerView
    }
    
    func initUI() {
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
        
        self.title = "喜愛曲風"
        musicStyleSegmentedControl.initUI()
        
        grayBackgroundView.frame = CGRect(x: 0, y: 64 + 44, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - 64 - 44 - 49)
        grayBackgroundView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.frame = CGRect(x: grayBackgroundView.bounds.width/2 - 15, y: 24, width: 30, height: 30)
        loadingIndicator.startAnimating()
        
        grayBackgroundView.addSubview(loadingIndicator)
        self.view.addSubview(grayBackgroundView)
    }
    
    func noticeButtonTapped(sender: UIButton) {
        
    }
    
    func backButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    //MARK: - HTTP Request
    func getMusicStyleSongs(numberOfTab: Int) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        switch numberOfTab {
        case 0:
            loadingIndicator.startAnimating()
            grayBackgroundView.hidden = false
            
            dispatch_async(queue, {
                ServerManager.getTrackByTagName(tagName: "爵士", completion: { (songs) in
                    dispatch_async(dispatch_get_main_queue(), {
                        self.songsArray = songs
                        self.addTableheaderViewAndBackgroundView(0)
                        self.tableView.reloadData()
                        
                        self.loadingIndicator.stopAnimating()
                        self.grayBackgroundView.hidden = true
                    })
                    }, failure: { (error) in
                        print("Tab0 getTrackByTagName error : \(error)")
                })
            })
            
        case 1:
            loadingIndicator.startAnimating()
            grayBackgroundView.hidden = false
            
            dispatch_async(queue, {
                ServerManager.getTrackByTagName(tagName: "鄉村", completion: { (songs) in
                    dispatch_async(dispatch_get_main_queue(), {
                        self.songsArray = songs
                        self.addTableheaderViewAndBackgroundView(1)
                        self.tableView.reloadData()
                        
                        self.loadingIndicator.stopAnimating()
                        self.grayBackgroundView.hidden = true
                    })
                    }, failure: { (error) in
                        print("Tab1 getTrackByTagName error: \(error)")
                })
            })
            
        case 2:
            loadingIndicator.startAnimating()
            grayBackgroundView.hidden = false
            
            dispatch_async(queue, {
                ServerManager.getTrackByTagName(tagName: "流行", completion: { (songs) in
                    dispatch_async(dispatch_get_main_queue(), {
                        self.songsArray = songs
                        self.addTableheaderViewAndBackgroundView(2)
                        self.tableView.reloadData()
                        
                        self.loadingIndicator.stopAnimating()
                        self.grayBackgroundView.hidden = true
                    })
                    }, failure: { (error) in
                        print("Tab2 getTrackByTagName error :\(error)")
                })
            })
        default:
            break
        }
    }
    
    
    
    //MARK: - Action
    @IBAction func segmentedControlTapped(sender: AnyObject) {
        getMusicStyleSongs(sender.selectedSegmentIndex)
    }
    
    
    
    //MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        if songsArray != nil {
            count = songsArray.count
        } else {
            count = 0
        }
        return count!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let appDelegateSharedInstance = appDelegate()
//        appDelegateSharedInstance.songsArray = self.songsArray
//        appDelegateSharedInstance.currentIndex = indexPath.row
//        appDelegateSharedInstance.playSongIndex(indexPath.row)
//        
//        //        let playerVC = PlayerViewController.init(songsArray: self.songsArray, selectedIndex: indexPath.row)
//        let playerVC = PlayerViewController.init(songsArray: self.songsArray, selectedIndex: indexPath.row, storiesArray: self.storiesArray)
////        self.presentViewController(playerVC, animated: true, completion: nil)
//        self.navigationController?.pushViewController(playerVC, animated: true)
        self.getSongStories((self.songsArray[indexPath.row].trackId)){
                let playerVC = PlayerViewController.init(songsArray: (self.songsArray), selectedIndex: indexPath.row, storiesArray: self.storiesArray)
                let appDelegateSharedInstance = appDelegate()
                appDelegateSharedInstance.songsArray = self.songsArray
                appDelegateSharedInstance.currentIndex = indexPath.row
                appDelegateSharedInstance.playSongIndex(indexPath.row)
                self.navigationController?.pushViewController(playerVC, animated: false)
                appDelegateSharedInstance.playSongIndex(indexPath.row)
            
        }
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
        
        if songsArray.count != 0 {
            self.totalSongsLabel.text = "\(songsArray.count) Songs"
            let song = songsArray[indexPath.row]
            let songCell = self.tableView.dequeueReusableCellWithIdentifier("MusicStyleTableViewCell", forIndexPath: indexPath) as! MusicStyleTableViewCell
            
            if songCell.buttonDelegate == nil {
                songCell.buttonDelegate = self
            }
            
            songCell.configCell(song)
            songCell.ratingNumberLabel.text = "\(indexPath.row+1)"
            cell = songCell
        }
        
        return cell!
    }
    
    
    
    //MARK: - MoreButtonDelegate
    func cellMoreButtonTapped(cell: MusicStyleTableViewCell) {
        let indexPath = tableView.indexPathForCell(cell)
        let song = self.songsArray[(indexPath?.row)!]
        let myLibraryMoreVC = MyLibraryMoreViewController(nibName: "MyLibraryMoreViewController", bundle: nil)
        
        myLibraryMoreVC.modalPresentationStyle = .OverCurrentContext
        myLibraryMoreVC.song = song
        
        self.presentViewController(myLibraryMoreVC, animated: true, completion: nil)
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
}
