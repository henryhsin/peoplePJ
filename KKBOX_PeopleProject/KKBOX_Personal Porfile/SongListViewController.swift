//
//  SongListViewController.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/11/7.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Haneke

class SongListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ListSongMoreButtonDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberOfSongsLabel: UILabel!
    
    var songsArray = [Song]()
    var selectedAlbum: Album?
    var titleName: String!
    var collectedAlbumImageURL: String!
    var storiesArray: [Story]?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
        tableView.registerNib(UINib(nibName: "ListSongTableViewCell", bundle: nil), forCellReuseIdentifier: "ListSongTableViewCell")
    }
    
    func initUI() {
        self.title = titleName
        
        if songsArray.count != 0 {
            self.numberOfSongsLabel.text = "\(songsArray.count) Songs"
        } else if selectedAlbum != nil {
            self.numberOfSongsLabel.text = "\(selectedAlbum?.songs!.count) Songs"
        }
        
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
    
    // MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int!
        
        if songsArray.count != 0 {
            count = songsArray.count
        }
        if selectedAlbum != nil {
            let songs = self.selectedAlbum?.songs
            count = songs!.count
        }
        
        return count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if songsArray.count != 0 {
            self.getSongStories((self.songsArray[indexPath.row].trackId)){
                if self.storiesArray != nil{
                    let playerVC = PlayerViewController.init(songsArray: (self.songsArray), selectedIndex: indexPath.row, storiesArray: self.storiesArray!)
                    let appDelegateSharedInstance = appDelegate()
                    appDelegateSharedInstance.songsArray = self.songsArray
                    appDelegateSharedInstance.currentIndex = indexPath.row
                    appDelegateSharedInstance.playSongIndex(indexPath.row)
                    self.navigationController?.pushViewController(playerVC, animated: false)
                    appDelegateSharedInstance.playSongIndex(indexPath.row)
                }
            }
        }
        if selectedAlbum != nil {
            self.getSongStories((self.songsArray[indexPath.row].trackId)){
                if self.storiesArray != nil{
                    let playerVC = PlayerViewController.init(songsArray: (self.songsArray), selectedIndex: indexPath.row, storiesArray: self.storiesArray!)
                    let appDelegateSharedInstance = appDelegate()
                    appDelegateSharedInstance.songsArray = self.songsArray
                    appDelegateSharedInstance.currentIndex = indexPath.row
                    appDelegateSharedInstance.playSongIndex(indexPath.row)
                    self.navigationController?.pushViewController(playerVC, animated: false)
                    appDelegateSharedInstance.playSongIndex(indexPath.row)
                }
            }
        }
        
        

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if self.songsArray.count != 0 {
            let song = self.songsArray[indexPath.row]
            
            let playlistCell = tableView.dequeueReusableCellWithIdentifier("ListSongTableViewCell", forIndexPath: indexPath) as! ListSongTableViewCell
            
            if playlistCell.buttonDelegate == nil {
                playlistCell.buttonDelegate = self
                playlistCell.configPlaylistCell(song)
            }
            cell = playlistCell
        }
        
        if selectedAlbum != nil {
            let song = self.selectedAlbum?.songs![indexPath.row]
            
            let albumCell = tableView.dequeueReusableCellWithIdentifier("ListSongTableViewCell", forIndexPath: indexPath) as! ListSongTableViewCell
            
            if albumCell.buttonDelegate == nil {
                albumCell.buttonDelegate = self
                albumCell.configAlbumCell(selectedAlbum!, song: song!)
            }
            cell = albumCell
        }
        
        return cell
    }
    
    
    
    //MARK: - MoreButtonDelegate
    func cellMoreButtonTapped(cell: ListSongTableViewCell) {
        
        if self.songsArray.count != 0 {
            let indexPath = tableView.indexPathForCell(cell)
            let song = self.songsArray[(indexPath?.row)!]
            let myLibraryMoreVC = MyLibraryMoreViewController(nibName: "MyLibraryMoreViewController", bundle: nil)
            
            myLibraryMoreVC.modalPresentationStyle = .OverCurrentContext
            myLibraryMoreVC.song = song
            
            self.presentViewController(myLibraryMoreVC, animated: true, completion: nil)
        }
        
        if selectedAlbum != nil {
            let indexPath = tableView.indexPathForCell(cell)
            let song = self.selectedAlbum?.songs![(indexPath?.row)!]
            let myLibraryMoreVC = MyLibraryMoreViewController(nibName: "MyLibraryMoreViewController", bundle: nil)
            
            myLibraryMoreVC.modalPresentationStyle = .OverCurrentContext
            myLibraryMoreVC.song = song
            
            self.presentViewController(myLibraryMoreVC, animated: true, completion: nil)

        }
    }
}
