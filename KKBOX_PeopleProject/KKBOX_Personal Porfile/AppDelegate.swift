//
//  AppDelegate.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/18.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import CoreData
import Haneke

func appDelegate() -> AppDelegate {
    return UIApplication.sharedApplication().delegate as! AppDelegate
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var tabBarController = UITabBarController()
    var playerVC = PlayerViewController()
    var currentIndex = NSNotFound
    var audioEngine = KKAudioEngine()
    var songsArray = [Song]()
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = UIColor.whiteColor()
        
        self.audioEngine.delegate = self
                
        let navigationController1 = UINavigationController()
        let navigationController2 = UINavigationController()
        let navigationController3 = UINavigationController()
        let navigationController4 = UINavigationController()
        let navigationController5 = UINavigationController()
        
        let myLibraryVC = MyLibraryViewController(nibName: "MyLibraryViewController", bundle: nil)
        let exploreVC = ExploreViewController(nibName: "ExploreViewController", bundle: nil)
        let feedVC = FeedVC(nibName: "FeedVC", bundle: nil)
        let searchVC = SearchViewController(nibName: "SearchViewController", bundle: nil)
        let listenWithVC = ListenWithViewController(nibName: "ListenWithViewController", bundle: nil)
        
        let myLibraryImage = UIImage(named: "icon_myLibrary")
        let myLibrarySelectedImage = UIImage(named: "icon_myLibrary_actived")
        let exploreImage = UIImage(named: "icon_new")
        let exploreSelectedImage = UIImage(named: "icon_new_actived")
        let feedImage = UIImage(named: "icon_story")
        let feedSelectedImage = UIImage(named: "icon_story_actived")
        let searchImage = UIImage(named: "icon_search")
        let searchSelectedImage = UIImage(named: "icon_search_actived")
        let listenWithImage = UIImage(named: "icon_listen")
        let listenWithSelectedImage = UIImage(named: "icon_listen_actived")
        
        navigationController1.viewControllers = [myLibraryVC]
        navigationController2.viewControllers = [exploreVC]
        navigationController3.viewControllers = [feedVC]
        navigationController4.viewControllers = [searchVC]
        navigationController5.viewControllers = [listenWithVC]
        
        let controllers = [navigationController1, navigationController2, navigationController3, navigationController4, navigationController5]
        tabBarController.viewControllers = controllers
        tabBarController.tabBar.tintColor = UIColor(red: 28/255, green: 174/255, blue: 216/255, alpha: 1)
        
        myLibraryVC.tabBarItem = UITabBarItem(title: "我的音樂庫", image: myLibraryImage, selectedImage: myLibrarySelectedImage)
        exploreVC.tabBarItem = UITabBarItem(title: "線上精選", image: exploreImage, selectedImage: exploreSelectedImage)
        feedVC.tabBarItem = UITabBarItem(title: "動態", image: feedImage, selectedImage: feedSelectedImage)
        searchVC.tabBarItem = UITabBarItem(title: "線上搜尋", image: searchImage, selectedImage: searchSelectedImage)
        listenWithVC.tabBarItem = UITabBarItem(title: "一起聽", image: listenWithImage, selectedImage: listenWithSelectedImage)
        
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        
        let token = NSUserDefaults.standardUserDefaults().valueForKey("token")

        if token != nil {
            window?.rootViewController = tabBarController
        } else {
            window?.rootViewController = loginVC
        }

        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        let URLString = url.absoluteString
        if URLString.hasPrefix(CallbackPrefix) {
            let token = (URLString as NSString).substringFromIndex(CallbackPrefix.characters.count)
            NSNotificationCenter.defaultCenter().postNotificationName(KKBOXAppDidLoginNotification, object: self, userInfo: [CallbackPrefix:token])
        }
        return true
    }
    
    
    
    
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func playSongWithURL(urlString: String) {
        let url = NSURL(string: urlString)
        self.audioEngine.loadAudioWithURL(url!, suggestedFileType: kAudioFileMP3Type, contextInfo: nil)
        
        let song = self.songsArray[currentIndex]
        
        let albumImageURLString = song.album?.imageURL
        let albumImageURL = NSURL(string: albumImageURLString!)
        let albumImageData = NSData(contentsOfURL: albumImageURL!)
        let albumImage = UIImage(data: albumImageData!)
        
        let artistImageURLString = song.album?.artist?.imageURL
        let artistImageURL = NSURL(string: artistImageURLString!)
        let artistImageData = NSData(contentsOfURL: artistImageURL!)
        let artistImage = UIImage(data: artistImageData!)
        
        let duration = stringFromTimeInterval(NSTimeInterval(song.songDuration / 1000))
        
//        playerVC.loadView()
        
        playerVC.songDurationLabel.text = duration
        playerVC.artistImageView.image = artistImage
        playerVC.backgroundImageView.image = albumImage
        playerVC.albumImageView.image = albumImage
        playerVC.artistNameLabel.text = song.album?.artist?.artistName
        playerVC.songNameLabel.text = song.songName
    }
    
    
    
    //MARK: - HTTP Request
    func getTrack(songId: String) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            ServerManager.getTicketURL(trackId: songId, completion: { (ticketURL) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.playSongWithURL(ticketURL)
                })
            }) { (error) in
                print("getTrack error : \(error)")
            }
        }
    }
}




extension AppDelegate {
    func tooglePlayBack() {
        self.audioEngine.playing ? self.audioEngine.pause(): self.audioEngine.play()
    }
    
    func nextSong() {
        if currentIndex == NSNotFound {
            return
        }
        
        if currentIndex < self.songsArray.count - 1 {
            let song = self.songsArray[currentIndex + 1]
            let songId = song.trackId
            currentIndex += 1
            self.getTrack(songId)
        }
    }
    
    func previousSong() {
        if currentIndex == NSNotFound {
            return
        }
        
        if currentIndex > 0 {
            let song = self.songsArray[currentIndex - 1]
            let songId = song.trackId
            currentIndex -= 1
            self.getTrack(songId)
        }
    }
    
    func playSongIndex(index: Int) {
        let song = self.songsArray[index]
        let songId = song.trackId
        
        self.getTrack(songId)
    }
    
    func updatePlayControl() {
        playerVC.playButton.setImage(self.audioEngine.playing ? UIImage(named: "icon_pause_normal"): UIImage(named: "icon_play_normal"), forState: .Normal)
    }
}


//MARK: - KKAudioEngineDelegate
extension AppDelegate: KKAudioEngineDelegate {
    
    func audioEngineWillStartPlaying(audioEngine: KKAudioEngine) {
        
    }
    
    func audioEngineDidStartPlaying(audioEngine: KKAudioEngine) {
        self.updatePlayControl()
    }
    
    func audioEngineDidPausePlaying(audioEngine: KKAudioEngine) {
        self.updatePlayControl()
    }
    
    func audioEngineDidStall(audioEngine: KKAudioEngine) {
        self.updatePlayControl()
    }

    func audioEngineDidEndCurrentPlayback(audioEngine: KKAudioEngine) {
        self.updatePlayControl()
        
        if self.currentIndex < self.songsArray.count - 1 {
            self.currentIndex += 1
            let song = self.songsArray[currentIndex]
            let songId = song.trackId
            self.getTrack(songId)
        } else {
            self.currentIndex = NSNotFound
            return
        }
    }
    
    func audioEngineDidEndPlaying(audioEngine: KKAudioEngine) {
        self.updatePlayControl()
    }
    
    func audioEngineDidHaveEnoughDataToStartPlaying(audioEngine: KKAudioEngine) {
        
    }
    
    func audioEngineDidHaveEnoughDataToResumePlaying(audioEngine: KKAudioEngine) {
        
    }
    
    func audioEngineDidComplateLoading(audioEngine: KKAudioEngine) {
        
    }
    
    func audioEngine(audioEngine: KKAudioEngine, didFailLoadingWithError error: NSError) {
        let alertVC = UIAlertController(title: error.localizedDescription ?? "Failed to load the song!", message: "", preferredStyle: .Alert)
        let cancelAtion = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
        alertVC.addAction(cancelAtion)
        playerVC.showViewController(alertVC, sender: self)
        
        self.currentIndex = NSNotFound
        self.updatePlayControl()
    }
    
    func audioEngine(audioEngine: KKAudioEngine, updateCurrentPlaybackTime currentTime: NSTimeInterval, loadedDuration: NSTimeInterval) {
        let song = self.songsArray[currentIndex]
        let songTime = stringFromTimeInterval(currentTime)
        let songDuration = stringFromTimeInterval(NSTimeInterval(song.songDuration / 1000))
        playerVC.songTimeLabel.text = songTime
        playerVC.songDurationLabel.text = songDuration
        
        if !playerVC.dragging {
            playerVC.songTimeSlider.maximumValue = Float(self.songsArray[currentIndex].songDuration / 1000)
            playerVC.songTimeSlider.value = Float(currentTime)
        }
        
        if !audioEngine.currentSongTrackFullyLoaded {
            return
        }
        if audioEngine.hasNextOperation {
            return
        }
        if self.currentIndex >= self.songsArray.count - 1 {
            return
        }
        if audioEngine.expectedDuration - currentTime > 30 {
            return
        }
    }
    
    func audioEngine(audioEngine: KKAudioEngine, didFailLoadingNextAudioWithError error: NSError, contextInfo: AnyObject?) {
        
    }
}

