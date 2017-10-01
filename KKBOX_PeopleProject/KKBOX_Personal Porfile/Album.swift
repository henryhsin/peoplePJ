//
//  Album.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/22.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import Foundation

class Album: NSObject {
    private var _album_id: String!
    private var _album_name: String!
    private var _image_url: String!
    private var _artist: Artist?
    private var _songs: [Song]?
    
    var albumId: String {
        if _album_id == nil {
            _album_id = ""
        }
        return _album_id
    }
    var albumName: String {
        if _album_name == nil {
            _album_name = ""
        }
        return _album_name
    }
    var imageURL: String {
        if _image_url == nil {
            _image_url = ""
        }
        return _image_url
    }
    var artist: Artist? {
        return _artist
    }
    var songs: [Song]? {
        return _songs
    }
    
    init(obj: AnyObject) {
        self._album_id = obj["album_id"] as! String
        self._album_name = obj["name"] as! String
        
        if let album_images = obj["images"] as? [AnyObject] {
            if let images = album_images[ALBUM_IMAGE_URL_INDEX] as? [String:AnyObject] {
                self._image_url = images["url"] as! String
            }
        }
        
        if let artistDictionary = obj["artist"] as? [String:AnyObject] {
            let artist = Artist(obj: artistDictionary)
            self._artist = artist
        }
        
        if let songsArrayResponse = obj["songs"] as? [AnyObject] {
            var songArray = [Song]()
            
            songsArrayResponse.forEach({ (song) in
                let songObj = Song(obj: song)
                songArray.append(songObj)
            })
            self._songs = songArray
        }
    }
    
    func setAlbumProperty(albumId: String, albumName: String, imageURL: String, artist: Artist?, songs: [Song]?) {
        self._album_id = albumId
        self._album_name = albumName
        self._image_url = imageURL
        self._artist = artist
        self._songs = songs
    }
}