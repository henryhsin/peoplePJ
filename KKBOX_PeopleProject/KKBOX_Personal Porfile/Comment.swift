//
//  Comment.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tie Lin on 2016/8/27.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import Foundation

class Comment: NSObject {
    
    private var _commentId: String!
    private var _kkboxId: String!
    private var _commentContent: String!
    private var _postCommentTime: String!
    private var _commentLikeNum: String!
    private var _whoPostComment: String!
    private var _commentPostManPhototUrl: String!
    private var _storyId: String!
    
    var storyId: String {
        set{
            _storyId = newValue
        }
        get{
            if _storyId == nil {
                _storyId = ""
            }
            return _storyId
        }
        
    }
    var commentId: String {
        set{
            _commentId = newValue
        }
        get{
            if _commentId == nil {
                _commentId = ""
            }
            return _commentId
        }
        
    }
    
    var kkboxId: String {
        set{
            _kkboxId = newValue
        }
        get{
            if _kkboxId == nil {
                _kkboxId = ""
            }
            return _kkboxId
        }
        
    }
    var commentContent: String {
        set{
            _commentContent = newValue
        }
        get{
            if _commentContent == nil {
                _commentContent = ""
            }
            return _commentContent
        }
        
    }
    var postCommentTime: String {
        get{
            if _postCommentTime == nil {
                _postCommentTime = ""
            }
            return _postCommentTime
            
        }
    }
    var whoPostComment: String {
        get{
            if _whoPostComment == nil {
                _whoPostComment = ""
            }
            return _whoPostComment
            
        }
    }
    var commentPostManPhototUrl: String {
        get{
            if _commentPostManPhototUrl == nil {
                _commentPostManPhototUrl = ""
            }
            return _commentPostManPhototUrl
            
        }
    }
    
    var commentLikeNum: String {
        get{
            if _commentLikeNum == nil {
                _commentLikeNum = "0"
            }
            return _commentLikeNum
            
        }
    }
    
    init(comment: Dictionary<String, AnyObject>) {
        super.init()
        if let commentId = comment["comment_id"] as? String{
            self._commentId = commentId
        }
        
        if let kkboxId = comment["kkbox_id"] as? String{
            self._kkboxId = kkboxId
        }
        
        
        if let whoPostComment = comment["user_name"] as? String{
            self._whoPostComment = whoPostComment
        }
        
        if let commentPostManPhototUrl = comment["user_image"] as? String{
            self._commentPostManPhototUrl = commentPostManPhototUrl
        }
        
        
        if let commentContent = comment["content"] as? String{
            self._commentContent = commentContent
        }
        
        if let postCommentTime = comment["time"] as? Int{
            if postCommentTime <= 60 {
                self._postCommentTime = "  剛剛"
                
            }else if postCommentTime <= 60*60{
                let time = postCommentTime / 60 + 1
                self._postCommentTime = "  \(time) 分鐘前"
            }else if postCommentTime <= 24*60*60{
                let time = postCommentTime / 3600 + 1
                self._postCommentTime = "  \(time) 小時前"
            }else{
                let time = postCommentTime / 86400 + 1
                if time >= 30{
                    self._postCommentTime = "  \(time/30) 個月前"
                    return
                }else if time >= 7{
                    self._postCommentTime = " \(time/7) 個禮拜前"
                    return
                }else{
                    self._postCommentTime = "  \(time) 天前"
                    return
                }
                
            }
        }
        
        if let commentLikeNum = comment["likes_num"] as? Int{
            self._commentLikeNum = String(commentLikeNum)
        }
    }
    
    init(story: Story) {
        self._storyId = story.storyId
    }
}