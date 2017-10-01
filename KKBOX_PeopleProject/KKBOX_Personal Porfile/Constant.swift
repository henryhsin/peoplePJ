//
//  Constant.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/22.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import Foundation
import UIKit

//LoginPageURL
let LoginPageURL = "http://192.168.24.211:8080/api/account/login"
//let LoginPageURL = "http://45.118.133.210:8080/api/account/login"
let CallbackPrefix = "people://?token="
let CallbackKey = "code"
let KKBOXAppDidLoginNotification = "KKBOXAppDidLoginNotification"

//Album image with 500x500 pixel
let ALBUM_IMAGE_URL_INDEX = 1

//Artist image with 160x160 pixel
let ARTIST_IMAGE_URL_INDEX = 0

//ProfileSegmentedControl
enum TabIndex: Int {
    case MusicTab = 0
    case StoryTab = 1
}

// Login Info 我膀胱小
let kkbox_login = "kkbox:kkbox"
let jay_login = "Jay:kkbox"
let crystal_login = "Crystal:kkbox"


// used by thr layer shadow
let SHADOW_COLOR: CGFloat = 157.0/255.0

//Key
let KEY_UID = "uid"

//Segue
let SEGUE_LOGGED_IN = "loggedIn"

//Alert Title
let ALERT_TITLE_OKAY = "okay"
let ALERT_TITLE_OOPS = "OOps!!"

//FeedVC
let NUMBER_OF_SECTIONS = 1
let NUMBER_OF_ROWS = 3
let CELL_SPACING_HEIGHT: CGFloat = 10.0


//CommentVC
let SCROLLVIEWCONTAINER_Y_SCREEN_RATIO: CGFloat = 340 / 568

let SCROLLVIEWCONTAINER_HEIGHT_SCREEN_RATIO: CGFloat = 178 / 568


//師大主機
let URL_BASE = "http://140.122.185.184:8080/"
//李洵電腦
//let URL_BASE = "http://192.168.13.198/"
//MARK: API
let URL_AUTH_LOGIN = "login"
let URL_AUTH_LOGOUT = "logout"


let URL_USER_GETSIMPLEINFO = "user/getSimpleInfo"
let URL_USER_GETFULLINFO = "user/getFullInfo"
let URL_USER_UPDATEINFO = "user/updateInfo"






let URL_FOLLOW_GETFOLLOWERS = "user/getFollowers"
let URL_FOLLOW_GETFOLLOWINGS = "user/getFollowings"
let URL_FOLLOW_ADDFOLLOWING = "user/addFollowing"

let URL_PLAYLIST_GETPLAYLIST = "user/getPlaylists"
let URL_PLAYLIST_ADDPLAYLIST = "user/addPlaylist"

let URL_HISTORY_GETHISTORY = "user/getHistory"
let URL_PLAYLIST_ADDHISTORY = "user/addHistory"

let URL_ALBUM_GETALBUMCOLLECTION = "user/getAlbumCollection"
let URL_ALBUM_COLLECTALBUM = "user/collectAlbum"

let URL_STORY_GETMYSTORY = "user/getMyStory"
let URL_STORY_GETSTORYCOLLECTION = "user/getStoryCollection"
let URL_STORY_GETSTORIESBYFOLLOWINGS = "user/getStoriesByFollowings"
let URL_STORY_GETSTORIESBYCOMMENTS = "user/getStoriesByComments"
let URL_STORY_GETSTORIESTOPTWO = "user/getStoriesTopTwo"

let URL_STORY_COLLECTSTORY = "user/collectStory"
let URL_STORY_ADDSTORY = "user/addStory"
let URL_STORY_ADDCOMMENT = "user/addComment"

let URL_ARTIST_GETARTISTCOLLECTION = "user/getArtistCollection"
let URL_ARTIST_COLLECTARTIST = "user/collectArtist"

let URL_SONG_COLLECTTRACK = "user/collectTrack"
let URL_SONG_GETTRACKBYTAGNAME = "user/getTrackByTagName"



//MARK: USER STORY URL
let URL_USER_GETHISTORY = "user/getHistory"
//拿到自己的story
let URL_USER_GETMYSTORY = "user/getMyStory"

//若沒有傳參數進去，拿到自己收藏的story
//若有傳參數進去，則拿到參數的那個人所收藏的story
let URL_USER_GETSTORYCOLLECTION = "user/getStoryCollection"

//若沒有傳參數進去，拿到自己喜歡的story
//若有傳參數進去，則拿到參數的那個人所喜歡的story
let URL_USER_GETLIKEDSTORY = "user/getLikedStory"

//若沒有傳參數進去，拿到自己收藏的專輯
//若有傳參數進去，則拿到參數的那個人收藏的專輯
let URL_USER_GETALBUMCOLLECTION = "user/getAlbumCollection"

//若沒有傳參數進去，拿到自己收藏的artist
//若有傳參數進去，則拿到參數的那個人收藏的artist
let URL_USER_GETARTISTCOLLECTION = "user/getArtistCollection"

//parameter: track_id
let URL_USER_ADDHISTORY = "user/addHistory"

//parameter: content(String), story_id(Int)
let URL_USER_ADDCOMMENT = "user/addComment"

//parameter: content, title, time, track_id (String)
let URL_USER_LIKESTORY = "user/likeStory"














//MARK: Data property

let LOGININFO = "loginInfo"
let NAME = "name"
let DESCRIPTION = "description"
let FOLLOWING = "following"
let TITLE = "title"
let CONTENT = "content"
let TIME = "time"
let TAGNAME = "tagName"

let TRACK_ID = "track_id"
let ALBUM_ID = "album_id"
let STORY_ID = "story_id"
let ARTIST_ID = "artist_id"
let PLAYLIST_ID = "playlist_id"











//for album["images"]
let PIXEL1000ALBUMIMG = 2

//for artist["images"]
let PIXEL300ALBUMIMG = 1
