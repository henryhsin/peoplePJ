//
//  TopTwoStorues.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/25.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import Foundation

internal class StrangerStories: Story {
    override init(story: Dictionary<String, AnyObject>) {
        super.init(story: story)
        
        
        if let storyComment = story["comments"] as? [Dictionary<String, AnyObject>]{
            for obj in storyComment{
                let commentObj = obj
                let comment = Comment(comment: commentObj)
                self._storyComments.append(comment)
            }
        }
        
        if let name = story["user_name"] as? String{
            self._whoPostStory = name
            print(self._whoPostStory)
        }
        
        if let img = story["user_image"] as? String{
            self._whoPostStoryImgUrl = img
        }
        
        if let track = story["track"] as? Dictionary<String, AnyObject>{
            if let trackName = track["name"] as? String{
                self._storySongName = trackName
                print(self._storySongName)
                print("")
            }
            if let album = track["album"] as? Dictionary<String, AnyObject>{
                if let albumName = album["name"] as? String{
                    self._storySongAlbumName = albumName
                }
                
                if let images = track["images"] as? [Dictionary<String, AnyObject>]{
                    if let albumImgUrl = images[0]["url"] as? String{
                        self._storySongCoverUrl = albumImgUrl
                    }
                }
                
                if let artist = track["artist"] as? Dictionary<String, AnyObject>{
                    if let artistName = artist["name"] as? String{
                        self._stroySongArtistName = artistName
                    }
                }
                
            }
        }
        
        
        
        
        if let type = story["type"] as? String{
            switch type  {
            case "0":
                self._reasonToRecommend = "熱門文章"
            case "1":
                self._reasonToRecommend = "因為你對 " + "\(self._whoPostStory)" + " 的文章產生過共鳴"
            case "2":
                self._reasonToRecommend = "following"
            case "3":
                self._reasonToRecommend = "因為你對這首歌也寫過故事"
            default:
                break
            }
            
        }
        
        
        if let whoPostStoryImgUrl = story["user_image"] as? String{
            self._whoPostStoryImgUrl = whoPostStoryImgUrl
            print("whoPostStoryImgUrl:",whoPostStoryImgUrl)
        }
        
        if let storyLikeNum = story["collect_num"] as? Int{
            self._storyLikeNum = storyLikeNum
        }
        
    }
    
}