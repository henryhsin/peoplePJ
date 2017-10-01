//
//  ServerManager.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/22.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import Foundation
import Alamofire

class ServerManager: NSObject {
    
    //MARK: - FUll
    class func getFullInfo(userId id: String, completion:(user: User) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.User(UserAPI.GetFullInfo(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseDictionary = value as? Dictionary<String, AnyObject> else {
                    print("ServerManager cannot cast getFullInfo response value to dictionary type")
                    failure(error: nil)
                    return
                }
                let user = User(response: responseDictionary)
                completion(user: user)
            case .Failure(let error):
                print("getFullInfoError",error)
                dispatch_async(dispatch_get_main_queue(), {
                    failure(error: error)
                    })
            }
        }
    }
    
    
    // MARK: - Auth
    class func login(userInfo info: String, completion:() -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Auth(AuthAPI.Login(info))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success( _):
                completion()
            case .Failure(let error):
                failure(error: error)
            }
        }
    }
    
    class func logout(completion:() -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Auth(AuthAPI.Logout)
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success( _):
                completion()
            case .Failure(let error):
                failure(error: error)
            }
        }
    }
    
    class func loginToKKBOX(completion:() -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Auth(AuthAPI.LoginToKKBOX)
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                print(value)
                completion()
            case .Failure(let error):
                failure(error: error)
            }
        }
    }
    
    
    //MARK: - User
    class func getSimpleInfo(userId id: String, completion:(user: User) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.User(UserAPI.GetSimpleInfo(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseDictionary = value as? [String:AnyObject] else {
                    print("ServerManager cannot cast getSimpleInfo response value to dictionary type")
                    failure(error: nil)
                    return
                }
                
                let userInfo = User(response: responseDictionary)
                completion(user: userInfo)
                
            case .Failure(let error):
                print("Get error when call ServerManager.getInfo, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    class func getMe(completion:(user: User) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.User(UserAPI.GetMe)
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                print("ServerManager getMe Name", value)
                
                guard let responseDictionary = value as? [String:AnyObject] else {
                    print("ServerManager cannot cast getme response value to dictionary type")
                    failure(error: nil)
                    return
                }
                
                let userInfo = User(response: responseDictionary)
                completion(user: userInfo)
                
            case .Failure(let error):
                print("Get error when call ServerManager.getMe, error: \(error)")
                failure(error: error)
            }
        }
    }
    
    class func updateInfo(userDescription description: String, musicTags tags: String, completion:() -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.User(UserAPI.UpdateInfo(description, tags))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success( _):
                completion()
            case .Failure(let error):
                print("Get error when call ServerManager.updateInfo, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    class func getTrackByTagName(tagName name: String, completion:(songs: [Song]) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.User(UserAPI.GetTrackByTagName(name))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseArray = value as? [AnyObject] else {
                    print("ServerManager cannot case getTrackByTagName response value to array type")
                    failure(error: nil)
                    return
                }
                
                var songsArray = [Song]()
                
                responseArray.forEach({ (obj) in
                    if let songObj = obj as? [String:AnyObject] {
                        let song = Song(obj: songObj)
                        songsArray.append(song)
                    }
                })
                completion(songs: songsArray)
            case .Failure(let error):
                print("Get error when call ServerManager.getTrackByTagName, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    //MARK: - Follow
    class func getFollowers(userId id: String, completion:(followers: [[String:String]]) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Follow(FollowAPI.GetFollowers(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseArray = value as? [AnyObject] else {
                    print("ServerManager cannot case getFollowers response value to array type")
                    failure(error: nil)
                    return
                }
                
                var followersArray = [[String:String]]()
                
                responseArray.forEach({ (obj) in
                    var followersDictionary = [String:String]()
                    let name = obj["name"] as! String
                    let imageURL = obj["image"] as! String
                    followersDictionary = ["name":name, "imageURL":imageURL]
                    followersArray.append(followersDictionary)
                })
                
                completion(followers: followersArray)
            case .Failure(let error):
                print("Get error when call ServerManager.getFollowers, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    class func getFollowings(userId id: String,completion:(followings: [AnyObject]) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Follow(FollowAPI.GetFollowings(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseArray = value as? [AnyObject] else {
                    print("ServerManager cannot case getFollowings response value to array type")
                    failure(error: nil)
                    return
                }
                
                var followingsArray = [[String:String]]()
                
                responseArray.forEach({ (obj) in
                    var followingsDictionary = [String:String]()
                    let name = obj["name"] as! String
                    let imageURL = obj["image"] as! String
                    followingsDictionary = ["name":name, "imageURL":imageURL]
                    followingsArray.append(followingsDictionary)
                })
                
                completion(followings: followingsArray)
            case .Failure(let error):
                print("Get error when call ServerManager.getFollowings, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    class func addFollowing(userId id: String, completion:() -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Follow(FollowAPI.AddFollowing(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success( _):
                completion()
            case .Failure(let error):
                print("Get error when call ServerManager.addFollowing, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    class func dropFollowing(userId id: String, completion:() -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Follow(FollowAPI.DropFollowing(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success( _):
                completion()
            case .Failure(let error):
                print("Get error when call ServerManager.dropFollowing, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    class func isFollowing(userId id: String, completion:(result: AnyObject) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Follow(FollowAPI.isFollowing(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                completion(result: value)
            case .Failure(let error):
                print("Get error when call ServerManager.isFollowing, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    
    //MARK: - Playlist
    class func getPlaylist(userId id: String, completion:(playlists: [Playlist]) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Playlist(PlaylistAPI.GetPlaylist(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseArray = value as? [AnyObject] else {
                    print("ServerManager cannot cast getPlaylist response value to array type")
                    failure(error: nil)
                    return
                }
                
                var playlistArray = [Playlist]()
                responseArray.forEach({ (obj) in
                    let playlist = Playlist(obj: obj)
                    playlistArray.append(playlist)
                })
                completion(playlists: playlistArray)
            case .Failure(let error):
                print("Get error when call ServerManager.getPlaylist, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    class func addPlaylist(playlistName name: String, completion:() -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Playlist(PlaylistAPI.AddPlaylist(name))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success( _):
                completion()
            case .Failure(let error):
                print("Get error when call ServerManager.addPlaylist, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    
    //MARK: - History
    //        class func getHistory(completion:() -> Void, failure:(error: NSError) -> Void) {
    //            let api = Router.History(HistoryAPI.GetHistory)
    //
    //            Alamofire.request(api).responseJSON { (response) in
    //                switch response.result {
    //                case .Success(let value):
    //                    print("getHistory response: \(value)")
    //                    completion()
    //                case .Failure(let error):
    //                    failure(error: error)
    //                }
    //            }
    //        }
    
    class func addHistory(songId id: String, completion:() -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.History(HistoryAPI.AddHistory(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success( _):
                completion()
            case .Failure(let error):
                print("Get error when call ServerManager.addHistory, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    
    //MARK: - Album
    class func getAlbumCollection(userId id: String, completion:(albums: [Album]) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Album(AlbumAPI.GetAlbumCollection(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseArray = value as? [AnyObject] else {
                    print("ServerManager cannot cast getAlbumCollection response value to array type")
                    failure(error: nil)
                    return
                }
                
                var albumsArray = [Album]()
                
                responseArray.forEach({ (obj) in
                    let album = Album(obj: obj)
                    albumsArray.append(album)
                })
                
                completion(albums: albumsArray)
            case .Failure(let error):
                print("Get error when call ServerManager.getAlbumCollection, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    class func collectAlbum(albumId id: String, completion:() -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Album(AlbumAPI.CollectAlbum(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success( _):
                completion()
            case .Failure(let error):
                print("Get error when call ServerManager.collectAlbum, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    
    //MARK: - Story
    class func getMyStory(completion:(stories: [Story]) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Story(StoryAPI.GetMyStory)
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseArray = value as? [AnyObject] else {
                    print("ServerManager cannot cast getMyStory response value to array type")
                    failure(error: nil)
                    return
                }
                
                var storyArray = [Story]()
                
                responseArray.forEach({ (obj) in
                    let story = Story(story: obj as! Dictionary<String, AnyObject>)
                    storyArray.append(story)
                })
                
                completion(stories: storyArray)
            case .Failure(let error):
                print("Get error when call ServerManager.getMyStory, error: \(error)")
                failure(error: error)
            }
        }
    }
    
    class func getStoryCollection(userId id: String, completion:(stories: [Story]) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Story(StoryAPI.GetStoryColection(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseArray = value as? [AnyObject] else {
                    print("ServerManager cannot case getStoryCollection response value to array type")
                    failure(error: nil)
                    return
                }
                
                var storyArray = [Story]()
                
                responseArray.forEach({ (obj) in
                    let story = Story(story: obj as! Dictionary<String, AnyObject>)
                    storyArray.append(story)
                })
                
                completion(stories: storyArray)
            case .Failure(let error):
                print("Get error when call ServerManager.getStoryCollection, error: \(error)")
                failure(error: error)
            }
        }
    }
    
    class func getStoriesTopTwo(completion: (stories: [StrangerStories]) -> Void, failure: (error: NSError?) -> Void){
        let api = Router.Story(StoryAPI.GetStoriesTopTwo)
        Alamofire.request(api).responseJSON { (response) in
            switch response.result{
            case .Success(let value):
                guard let responseArray = value as? [Dictionary<String, AnyObject>] else{
                    print("ServerManager cannot case getStoriesTopTwo response value to array type")
                    failure(error: nil)
                    return
                }
                var stories = [StrangerStories]()
                for respond in responseArray{
                    let story = StrangerStories(story: respond)
                    stories.append(story)
                }
                completion(stories: stories)
            case .Failure(let error):
                print("getStoriesTopTwo error",error)
                failure(error: error)
            }
            
        }
        
    }
    
    class func getStoriesByMyStories(completion: (stories: [StrangerStories]) -> Void, failure: (error: NSError?) -> Void){
        let api = Router.Story(StoryAPI.GetStoriesByMyStories)
        Alamofire.request(api).responseJSON { (response) in
            switch response.result{
            case .Success(let value):
                guard let responseArray = value as? [Dictionary<String, AnyObject>] else{
                    print("ServerManager cannot case getStoriesTopTwo response value to array type")
                    failure(error: nil)
                    return
                }
                var stories = [StrangerStories]()
                for respond in responseArray{
                    let story = StrangerStories(story: respond)
                    stories.append(story)
                }
                completion(stories: stories)
            case .Failure(let error):
                failure(error: error)
            }
            
        }
        
    }
    
    
    
    
    
    
    
    class func getStoriesByComments(completion: (stories: [StrangerStories]) -> Void, failure: (error: NSError?) -> Void){
        let api = Router.Story(StoryAPI.GetStoriesByComments)
        Alamofire.request(api).responseJSON { (response) in
            switch response.result{
            case .Success(let value):
                guard let responseArray = value as? [Dictionary<String, AnyObject>] else{
                    print("ServerManager cannot case getStoriesByComments response value to array type")
                    failure(error: nil)
                    return
                    
                }
                var stories = [StrangerStories]()
                for respond in responseArray{
                    print("respond:QAQ",respond)
                    let story = StrangerStories(story: (respond as? Dictionary<String, AnyObject>)!)
                    
                    stories.append(story)
                    
                }
                
                completion(stories: stories)
            case .Failure(let error):
                failure(error: error)
            }
            
        }
        
    }
    
    class func getStoriesByFollowings(completion: (stories: [Story]) -> Void, failure: (error: NSError?) -> Void){
        let api = Router.Story(StoryAPI.GetStoriesByFollowings)
        Alamofire.request(api).responseJSON { (response) in
            switch response.result{
            case .Success(let value):
                guard let responseArray = value as? [Dictionary<String, AnyObject>] else{
                    print("ServerManager cannot case getStoriesByFollowings response value to array type")
                    failure(error: nil)
                    return
                    
                }
                var stories = [Story]()
                for respond in responseArray{
                    let story = Story(story: respond)
                    stories.append(story)
                    
                }
                
                completion(stories: stories)
            case .Failure(let error):
                failure(error: error)
            }
            
        }
        
    }
    
    class func collectStory(storyId id: String, completion:() -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Story(StoryAPI.CollectStory(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success( _):
                completion()
            case .Failure(let error):
                print("Get error when call ServerManager.collectStory, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    class func addStory(storyTitle title: String, storyContent content: String, createTime time: String, songId id: String, completion:() -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Story(StoryAPI.AddStory(title, content, time, id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success( _):
                completion()
            case .Failure(let error):
                print("Get error when call ServerManager.addStory, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    class func stories(trackId trackId : String, completion: (stories: [Story]) -> Void, failure: (error: NSError?) -> Void){
        let api = Router.Story(StoryAPI.Stories(trackId))
        Alamofire.request(api).responseJSON { (response) in
            switch response.result{
                
            case .Success(let value):
                guard let responseArray = value as? [Dictionary<String, AnyObject>] else{
                    print("ServerManager cannot case stories response value to array type")
                    failure(error: nil)
                    return
                }
                var stories = [Story]()
                for response in responseArray{
                    let story = Story(story: response)
                    stories.append(story)
                }
                completion(stories: stories)
            case .Failure(let error):
                failure(error: error)
            }
            
        }
        
    }
    
    class func getCommentsByStoryId(storyId storyId : String, completion: (comments: [Comment]) -> Void, failure: (error: NSError?) -> Void){
        let api = Router.Story(StoryAPI.GetCommentsByStoryId(storyId))
        Alamofire.request(api).responseJSON { (response) in
            switch response.result{
            
            case .Success(let value):
                guard let responseArray = value as? [Dictionary<String, AnyObject>] else{
                    print("ServerManager cannot case stories response value to array type")
                    failure(error: nil)
                    return
                }
                var commentsArray = [Comment]()
                for response in responseArray{
                    

                    let comment = Comment(comment: response)
                    commentsArray.append(comment)
                }
                print("getCommentsByStoryIdgetCommentsByStoryId:",storyId)
                print("responseArrayresponseArrayresponseArray",responseArray)
                completion(comments: commentsArray)
//                for comment in commentsArray{
//                    print("getCommentsByStoryIdgetCommentsByStoryId:",comment.commentContent)
//                }
            case .Failure(let error):
                print("Get error when call getCommentByStoryId, error : \(error)")
                failure(error: error)
            }
            
        }
        
    }
    
    class func getTrackByStoryId(storyId storyId : String, completion: (songs: [Song]) -> Void, failure: (error: NSError?) -> Void){
        let api = Router.Story(StoryAPI.GetTrackByStoryId(storyId))
        Alamofire.request(api).responseJSON { (response) in
            switch response.result{
            case .Success(let value):
                guard let response = value as? Dictionary<String, AnyObject> else{
                    print("ServerManager cannot case stories response value to array type")
                    failure(error: nil)
                    return
                }
                var songsArray = [Song]()
                let song = Song(obj: response)
                songsArray.append(song)
                
                print("getTrackByStoryId success")
                completion(songs: songsArray)
            case .Failure(let error):
                print("getTrackByStoryId error",error)
                failure(error: error)
            }
            
        }
        
    }
    
    
    class func addComment(commentContent comment: String, storyId id: String, postTime time: String, completion:() -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Story(StoryAPI.AddComment(comment, id, time))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success( _):
                print("success post comments")
                completion()
            case .Failure(let error):
                print("Get error when call ServerManager.addComment, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    
    //MARK: - Artist
    class func getArtistCollection(userId id: String, completion:(artists: [Artist]) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Artist(ArtistAPI.GetArtistCollection(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseArray = value as? [AnyObject] else {
                    print("ServerManager cannot case getArtistCollection response value to array type")
                    failure(error: nil)
                    return
                }
                
                var artistArray = [Artist]()
                
                responseArray.forEach({ (obj) in
                    let artist = Artist(obj: obj)
                    artistArray.append(artist)
                })
                
                completion(artists: artistArray)
            case .Failure(let error):
                print("Get error when call ServerManager.getArtistCollection, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    class func collectArtist(artistId id: String, completion:() -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Artist(ArtistAPI.CollectArtist(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success( _):
                completion()
            case .Failure(let error):
                print("Get error when call ServerManager.collectArtist, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    
    //MARK: - Song
    class func collectTrack(songId id: String, playlistId listId:String, completion:() -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Song(SongAPI.CollectTrack(id, listId))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success( _):
                completion()
            case .Failure(let error):
                print("Get error when call ServerManager.collectTrack, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    class func search(query query: String, completion:(tracks: [Song]) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Song(SongAPI.Search(query))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                
                guard let responseArray = value["tracks"] as? [Dictionary<String, AnyObject>] else {
                    print("ServerManager cannot case search response value to array type")
                    failure(error: nil)
                    return
                }
                var trackArray = [Song]()
                for response in responseArray{
                    let song = Song(obj: response)
                    trackArray.append(song)
                }
                completion(tracks: trackArray)
            case .Failure(let error):
                print("Get error when call ServerManager.search, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    //MARK: - Like
    class func likeStory(storyId id: String, completion:() -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Like(LikeAPI.LikeStory(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success( _):
                completion()
            case .Failure(let error):
                print("Get error when call ServerManager.likeStory, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    class func likeComment(commentId id: String, completion:() -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Like(LikeAPI.LikeComment(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success( _):
                print(response.result.value)
                print("success")
                completion()
            case .Failure(let error):
                print("Get error when call ServerManager.likeStory, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    class func decollectComment(commentId id: String, completion:() -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Like(LikeAPI.DecollectComment(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success( _):
                print("success")
                completion()
            case .Failure(let error):
                print("Get error when call ServerManager.likeStory, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    class func decollectStory(storyId id: String, completion:() -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Like(LikeAPI.DecollectStory(id))
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success( _):
                print("success")
                completion()
            case .Failure(let error):
                print("Get error when call ServerManager.likeStory, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    class func getLikedComment(completion:(likedCommentArray: [String]) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Like(LikeAPI.GetLikedComment())
        
        Alamofire.request(api).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                guard let responseArray = value as? [String] else{
                    print("ServerManager cannot case getStoriesTopTwo response value to array type")
                    failure(error: nil)
                    return
                    
                }
                var likedCommentArray = [String]()
                for respond in responseArray{
                    likedCommentArray.append(respond)
                }
                
                completion(likedCommentArray: likedCommentArray)
            case .Failure(let error):
                print("Get error when call ServerManager.likeStory, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    
    //MARK: - Image
    class func getUserImage(userId id: String, completion:(imageData: NSData) -> Void, failure:(error: NSError?) -> Void) {
        let api = Router.Image(ImageAPI.GetUserImage(id))
        
        Alamofire.request(api).response { (request, response, data, error) in
            if let imageData = data {
                completion(imageData: imageData)
            } else {
                print("Get error when call ServerManager.getUserImage, error : \(error)")
                failure(error: error)
            }
        }
    }
    
    class func uploadImage(imageData data: NSData, completion:() -> Void, failure:(error: NSError?) -> Void) {
        Alamofire.upload(.POST, "http://192.168.24.211:8080/user/uploadImage", multipartFormData: { (MultipartFormData) in
            MultipartFormData.appendBodyPart(data: data, name: "img",fileName: "kk.jpg" ,mimeType: "multipart/form-data")
            }, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    //                    upload.responseJSON(completionHandler: { (response) in
                    //                        completion()
                    //                    })
                    upload.responseString(completionHandler: { (response) in
                        completion()
                    })
                case .Failure(let encodingError):
                    print("Get error when call ServerManager.uploadImage, error : \(encodingError)")
                }
        })
    }
    
    
    //MARK: - Song
    class func getTicketURL(trackId id: String, completion:(ticketURL: String) -> Void, failure:(error: NSError?) -> Void) {
        Alamofire.request(.GET, "http://192.168.24.211:8080/api/ticket/get/\(id)").responseJSON { (response) in
            switch response.result {
            case .Success(let value):                
                guard let ticketURL = value["url"] as? String else {
                    print("ServerManager cannot case getTicketURL response value to string type")
                    return
                }
                completion(ticketURL: ticketURL)
            case .Failure(let error):
                print("Get error when call ServerManager.getTicketURL, error : \(error)")
                failure(error: error)
            }
        }
    }
}
