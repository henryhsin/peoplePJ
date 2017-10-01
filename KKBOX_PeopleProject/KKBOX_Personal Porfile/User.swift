//
//  User.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/22.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import Foundation

class User: NSObject {
    
    private var _meUserId: String!
    private var _meUserName: String!
    private var _userId: String!
    private var _kkboxId: String!
    private var _userName: String!
    private var _userProfileImageUrl: String!
    private var _description: String!
    private var _tags: String!
    private var _followers: [[String:String]]!
    private var _followings: [[String:String]]!
    private var _userPostedStrory = [Story]()
    private var _userLikedStory = [Story]()
    private var _userPostedComment: [Comment]!
    internal var _storyCollection = [String]()
    
    var storyCollection: [String] {
        return _storyCollection
    }
    var meUserId: String {
        if _meUserId == nil {
            _meUserId = ""
        }
        return _meUserId
    }
    var meUserName: String {
        if _meUserName == nil {
            _meUserName = ""
        }
        return _meUserName
    }
    var kkboxId: String {
        if _kkboxId == nil {
            _kkboxId = ""
        }
        return _kkboxId
    }
    var userId: String {
        if _userId == nil {
            _userId = ""
        }
        return _userId
    }
    var userName: String {
        if _userName == nil {
            _userName = ""
        }
        return _userName
    }
    var userProfileImageUrl: String {
        if _userProfileImageUrl == nil {
            _userProfileImageUrl = ""
        }
        return _userProfileImageUrl
    }
    var descrip: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    var tags: String {
        if _tags == nil {
            _tags = ""
        }
        return _tags
    }
    var followers: [[String:String]] {
        if _followers == nil {
            _followers = []
        }
        return _followers
    }
    var followings: [[String:String]] {
        set {
            self._followings = newValue
        }
        get{
            if _followings == nil {
                _followings = []
            }
            return _followings
        }
    }
    var userPostedStrory: [Story]! {
        return _userPostedStrory
    }
    
    var userLikedStory: [Story]! {
        return _userLikedStory
    }
    
    
    init(response: [String:AnyObject]) {
        super.init()
        
        if let meUserId = response["id"] as? String {
            self._meUserId = meUserId
        }
        
        if let meUserName = response["name"] as? String {
            self._meUserName = meUserName
        }
        
        if let kkboxId = response["kkbox_id"] as? String {
            self._kkboxId = kkboxId
        }
        
        if let userId = response["user_id"] as? String{
            self._userId = userId
        }
        
        if let userName = response["name"] as? String{
            self._userName = userName
        }
        
//        if let userProfileImageUrl = response["image"] as? String{
//            self._userProfileImageUrl = userProfileImageUrl
//        }
        
        if let userProfileImageUrl = response["user_image"] as? String{
            self._userProfileImageUrl = userProfileImageUrl
        }
        
        if let userPostedStrory = response["MyStory"] as? [Dictionary<String, AnyObject>]{
            for postedStory in userPostedStrory{
                let story = Story(story: postedStory)
                self._userPostedStrory.append(story)
                
            }
        }
        
        if let description = response["description"] as? String{
            self._description = description
        }
        
        if let followersResponseArray = response["followers"] as? [AnyObject] {
            var followersArray = [[String:String]]()
            
            followersResponseArray.forEach({ (follower) in
                if follower is NSNull {
                    
                } else {
//                    let name = follower["name"] as! String
                    print("follower",follower)
                    let name = follower["user_name"] as! String
                    let kkboxId = follower["kkbox_id"] as! String
                    let imageURL = follower["user_image"] as! String
                    
                    let followerDictionary = ["name":name, "kkbox_id":kkboxId, "imageURL":imageURL]
//                    let followerDictionary = ["name":name, "kkbox_id":kkboxId]
                    followersArray.append(followerDictionary)
                }
            })
            self._followers = followersArray
        }
        
        if let followingsResponseArray = response["followings"] as? [AnyObject] {
            var followingsArray = [[String:String]]()
            
            followingsResponseArray.forEach({ (following) in
                if following is NSNull {
                    
                } else {
//                    let name = following["name"] as! String
                    let name = following["user_name"] as! String
                    let kkboxId = following["kkbox_id"] as! String
                    let imageURL = following["user_image"] as! String
                    
//                    let followingDictionary = ["name":name, "kkbox_id":kkboxId, "imageURL":imageURL]
                    let followingDictionary = ["name":name, "kkbox_id":kkboxId, "user_image":imageURL]

                    followingsArray.append(followingDictionary)
                }
            })
            self._followings = followingsArray
        }
        
        if let userCollectedStory = response["StoryCollection"] as? [Dictionary<String, AnyObject>]{
            if userCollectedStory.count > 0{
                if !self._storyCollection.isEmpty{
                    self._storyCollection.removeAll()
                }
                for collectedStory in userCollectedStory{
                    let story = Story(story: collectedStory)
                    self._userLikedStory.append(story)
                    if let id = collectedStory["story_id"] as? String{
                        self._storyCollection.append(id)
                    }
                }
            }
        }
        
        
    }
    
    func setUserProperty(userId: String, name: String, description: String, followers: [[String:String]], followings: [[String:String]]) {
        self._userId = userId
        self._userName = name
        self._description = description
        self._followers = followers
        self._followings = followings
    }
}