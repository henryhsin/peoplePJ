//
//  Artist.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/22.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import Foundation

class Artist: NSObject {
    private var _artist_id: String!
    private var _artist_name: String!
    private var _image_url: String!
    private var _albums: [Album]?
    private var _songs: [Song]?
    
    var artistId: String {
        if _artist_id == nil {
            _artist_id = ""
        }
        return _artist_id
    }
    var artistName: String {
        if _artist_name == nil {
            _artist_name = ""
        }
        return _artist_name
    }
    var imageURL: String {
        if _image_url == nil {
            _image_url = ""
        }
        return _image_url
    }
    var albums: [Album]? {
        return _albums
    }
    var songs: [Song]? {
        return _songs
    }
    
    init(obj: AnyObject) {
        self._artist_id = obj["artist_id"] as! String
        self._artist_name = obj["name"] as! String
        if let artist_images = obj["images"] as? [AnyObject] {
            if let images = artist_images[ARTIST_IMAGE_URL_INDEX] as? [String:AnyObject] {
                self._image_url = images["url"] as! String
            }
        }
        if let albumsArrayResponse = obj["album"] as? [AnyObject] {
            var albumArray = [Album]()
            
            albumsArrayResponse.forEach({ (obj) in
                let albumObj = Album(obj: obj)
                albumArray.append(albumObj)
            })
            self._albums = albumArray
        }
        
    }
    
    func setArtistProperty(artistId: String, artistName: String, imageURL: String, albums: [Album]?, songs: [Song]?) {
        self._artist_id = artistId
        self._artist_name = artistName
        self._image_url = imageURL
        self._albums = albums
        self._songs = songs
    }
}