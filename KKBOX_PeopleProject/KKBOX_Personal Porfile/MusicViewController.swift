//
//  MusicViewController.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/22.
//  Copyright © 2016年 Chun Tai. All rights reserved.
// MusicViewController: dispatch_group

import UIKit

class MusicViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, RatingMoreButtonDelegate, AlbumPlayButtonDelegate, PlaylistPlayButtonDelegate {
    
    @IBOutlet weak var musicRatingTableView: UITableView!
    @IBOutlet weak var followingArtistCollectionView: UICollectionView!
    @IBOutlet weak var collectedAlbumCollectionView: UICollectionView!
    @IBOutlet weak var playlistCollectionView: UICollectionView!
    
    var userId: String?
    var songs = [Song]()
    var personalSongs = [Song]()
    var artists = [Artist]()
    var playlists = [Playlist]()
    var albums = [Album]()
    var storiesArray: [Story]?

    lazy var musicRatingVC: MusicRatingViewController = MusicRatingViewController(nibName: "MusicRatingViewController", bundle: nil)
    lazy var musicRatingV2VC: MusicRatingV2ViewController = MusicRatingV2ViewController(nibName: "MusicRatingV2ViewController", bundle: nil)
    lazy var playlistVC: PlaylistViewController = PlaylistViewController(nibName: "PlaylistViewController", bundle: nil)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.musicRatingTableView.registerNib(UINib(nibName: "MusicRatingTableViewCell", bundle: nil), forCellReuseIdentifier: "MusicRatingTableViewCell")
        self.collectedAlbumCollectionView.registerNib(UINib(nibName: "CollectedAlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectedAlbumCollectionViewCell")
        self.playlistCollectionView.registerNib(UINib(nibName: "PlaylistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlaylistCollectionViewCell")
        self.followingArtistCollectionView.registerNib(UINib(nibName: "FollowingArtistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FollowingArtistCollectionViewCell")
        
        self.collectedAlbumCollectionView.showsHorizontalScrollIndicator = false
        self.playlistCollectionView.showsHorizontalScrollIndicator = false
        self.followingArtistCollectionView.showsHorizontalScrollIndicator = false
    }
    
    
    
    //MARK: - HTTP Request
    func getInfo(kkboxId: String,completion:() -> Void) {
        let group = dispatch_group_create()
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_group_enter(group)
        dispatch_group_async(group, queue, {
            ServerManager.getTrackByTagName(tagName: "個人排行榜", completion: { (songs) in
                dispatch_async(dispatch_get_main_queue(), {
                    print("個人排行榜")
                    
                    self.songs = songs
                    self.musicRatingTableView.reloadData()
                    dispatch_group_leave(group)
                })
                }, failure: { (error) in
                    print("getTrackByTagName error : \(error)")
                    dispatch_group_leave(group)
            })
        })
        
        dispatch_group_enter(group)
        dispatch_group_async(group, queue, {
            ServerManager.getArtistCollection(userId: kkboxId, completion: { (artists) in
                dispatch_async(dispatch_get_main_queue(), {
                    print("追蹤藝人")
                    
                    self.artists = artists
                    self.followingArtistCollectionView.reloadData()
                    dispatch_group_leave(group)
                })
                }, failure: { (error) in
                    print("getArtistCollection error : \(error) ")
                    dispatch_group_leave(group)
            })
        })
        
        dispatch_group_enter(group)
        dispatch_group_async(group, queue, {
            ServerManager.getPlaylist(userId: kkboxId, completion: { (playlists) in
                dispatch_async(dispatch_get_main_queue(), {
                    print("分享歌單")
                    
                    self.playlists = playlists
                    self.playlistCollectionView.reloadData()
                    dispatch_group_leave(group)
                })
                }, failure: { (error) in
                    print("getPlaylists error : \(error)")
                    dispatch_group_leave(group)
            })
        })
        
        dispatch_group_enter(group)
        dispatch_group_async(group, queue, {
            ServerManager.getAlbumCollection(userId: kkboxId, completion: { (albums) in
                dispatch_async(dispatch_get_main_queue(), {
                    print("收藏專輯")
                    
                    self.albums = albums
                    self.collectedAlbumCollectionView.reloadData()
                    dispatch_group_leave(group)
                })
                }, failure: { (error) in
                    print("getAlbumCollection error : \(error)")
                    dispatch_group_leave(group)
            })
        })
        
        dispatch_group_notify(group, queue, {
            completion()
        })
    }
    
    
    
    //MARK: - Action
    @IBAction func musicRatingMoreButtonTapped(sender: AnyObject) {
        let musicRatingV2ChildVC = MusicRatingV2ViewController.init(songsArray: self.songs)
        self.navigationController?.pushViewController(musicRatingV2ChildVC, animated: true)
    }
    
    @IBAction func playlistMoreButtonTapped(sender: AnyObject) {
        let playlistChildVC = PlaylistViewController.init(playlistsArray: self.playlists)
        self.navigationController?.pushViewController(playlistChildVC, animated: true)
    }
    
    
    
    //MARK: - CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int?
        
        if collectionView == collectedAlbumCollectionView {
            count = self.albums.count
        }
        if collectionView == playlistCollectionView {
            count = self.playlists.count
        }
        if collectionView == followingArtistCollectionView {
            count = self.artists.count
        }
        return count!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size: CGSize?
        if collectionView == collectedAlbumCollectionView {
            size = CGSizeMake(100, 147)
        }
        if collectionView == playlistCollectionView {
            size = CGSizeMake(100, 147)
        }
        if collectionView == followingArtistCollectionView {
            size = CGSizeMake(74, 109)
        }
        return size!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == collectedAlbumCollectionView {
            let album = self.albums[indexPath.item]
            
            let songListsVC = SongListViewController(nibName: "SongListViewController", bundle: nil)
            songListsVC.selectedAlbum = album
            songListsVC.titleName = album.albumName
            
            self.navigationController?.pushViewController(songListsVC, animated: true)
        }
        if collectionView == playlistCollectionView {
            let playlist = self.playlists[indexPath.item]
            
            let songListsVC = SongListViewController(nibName: "SongListViewController", bundle: nil)
            songListsVC.songsArray = playlist.songs!
            songListsVC.titleName = playlist.playlistName
            
            self.navigationController?.pushViewController(songListsVC, animated: true)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        
        if collectionView == collectedAlbumCollectionView {
            let album = self.albums[indexPath.item]
            let albumCell = self.collectedAlbumCollectionView.dequeueReusableCellWithReuseIdentifier("CollectedAlbumCollectionViewCell", forIndexPath: indexPath) as! CollectedAlbumCollectionViewCell
            
            if albumCell.buttonDelegate == nil {
                albumCell.buttonDelegate = self
            }
            
            albumCell.configCell(album)
            cell = albumCell
        }
        if collectionView == playlistCollectionView {
            let playlist = self.playlists[indexPath.item]
            let playlistCell = self.playlistCollectionView.dequeueReusableCellWithReuseIdentifier("PlaylistCollectionViewCell", forIndexPath: indexPath) as! PlaylistCollectionViewCell
            
            if playlistCell.buttonDelegate == nil {
                playlistCell.buttonDelegate = self
            }
            
            playlistCell.configCell(playlist)
            cell = playlistCell
        }
        if collectionView == followingArtistCollectionView {
            let artist = self.artists[indexPath.item]
            let artistCell = self.followingArtistCollectionView.dequeueReusableCellWithReuseIdentifier("FollowingArtistCollectionViewCell", forIndexPath: indexPath) as! FollowingArtistCollectionViewCell
            artistCell.configCell(artist)
            cell = artistCell
        }
        return cell!
    }
    
    
    
    //MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let appDelegateSharedInstance = appDelegate()
//        appDelegateSharedInstance.songsArray = self.songs
//        appDelegateSharedInstance.currentIndex = indexPath.row
//        appDelegateSharedInstance.playSongIndex(indexPath.row)
//        
////        let playerVC = PlayerViewController.init(songsArray: self.songs, selectedIndex: indexPath.row)
//        let playerVC = PlayerViewController.init(songsArray: self.songs, selectedIndex: indexPath.row, storiesArray: nil)
////        self.presentViewController(playerVC, animated: true, completion: nil)
//        self.navigationController?.pushViewController(playerVC, animated: true)
        
        self.getSongStories((self.songs[indexPath.row].trackId)){
            if self.storiesArray != nil{
                let playerVC = PlayerViewController.init(songsArray: (self.songs), selectedIndex: indexPath.row, storiesArray: self.storiesArray!)
                let appDelegateSharedInstance = appDelegate()
                appDelegateSharedInstance.songsArray = self.songs
                appDelegateSharedInstance.currentIndex = indexPath.row
                appDelegateSharedInstance.playSongIndex(indexPath.row)
                self.navigationController?.pushViewController(playerVC, animated: false)
                appDelegateSharedInstance.playSongIndex(indexPath.row)
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.musicRatingTableView.dequeueReusableCellWithIdentifier("MusicRatingTableViewCell", forIndexPath: indexPath) as! MusicRatingTableViewCell
        
        if songs.count != 0 {
            let song = self.songs[indexPath.row]
            
            if cell.buttonDelegate == nil {
                cell.buttonDelegate = self
            }
            
            cell.ratingNumberLabel.backgroundColor = UIColor.whiteColor()
            cell.ratingNumberLabel.text = "\(indexPath.row+1)"
            cell.configCell(song)
        }
        return cell
    }
    
    
    
    //MARK: - MoreButtonDelegate
    func cellMoreButtonTapped(cell: MusicRatingTableViewCell) {
        let indexPath = musicRatingTableView.indexPathForCell(cell)
        let song = self.songs[(indexPath?.row)!]
        let myLibraryMoreVC = MyLibraryMoreViewController(nibName: "MyLibraryMoreViewController", bundle: nil)
        
        myLibraryMoreVC.modalPresentationStyle = .OverCurrentContext
        myLibraryMoreVC.song = song
        
        self.presentViewController(myLibraryMoreVC, animated: true, completion: nil)
    }
    
    
    
    //MARK: - AlbumPlayButtonDelegate
    func albumPlayButton(cell: UICollectionViewCell) {
        let indexPath = collectedAlbumCollectionView.indexPathForCell(cell)
        let album = self.albums[indexPath!.item]
        
        let songListsVC = SongListViewController(nibName: "SongListViewController", bundle: nil)
        songListsVC.selectedAlbum = album
        songListsVC.titleName = album.albumName
        
        self.navigationController?.pushViewController(songListsVC, animated: true)
    }
    
    
    
    //MARK: - PlaylistPlayButtonDelegate
    func playlistPlayButton(cell: UICollectionViewCell) {
        let indexPath = playlistCollectionView.indexPathForCell(cell)
        let playlist = self.playlists[indexPath!.item]
        
        let songListsVC = SongListViewController(nibName: "SongListViewController", bundle: nil)
        songListsVC.songsArray = playlist.songs!
        songListsVC.titleName = playlist.playlistName
        
        self.navigationController?.pushViewController(songListsVC, animated: true)
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
