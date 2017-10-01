//
//  Song.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/22.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import Foundation

class Song: NSObject {
    private var _track_id: String!
    private var _song_name: String!
    private var _song_duration: Int!
    private var _album: Album?
    private var _artist: Artist?
    private var _songArtistName: String!
    private var _songAlbumName: String!
    private var _songAlbumImgUrl: String!
    
    var trackId: String {
        if _track_id == nil {
            _track_id = ""
        }
        return _track_id
    }
    var songName: String {
        if _song_name == nil {
            _song_name = ""
        }
        return _song_name
    }
    var songDuration: Int {
        if _song_duration == nil {
            _song_duration = 0
        }
        return _song_duration
    }
    var album: Album? {
        return _album
    }
    var artist: Artist? {
        return _artist
    }
    var songAlbumName: String {
        get{
            if _songAlbumName == nil {
                _songAlbumName = ""
            }
            return _songAlbumName
        }
    }
    var songAlbumImgUrl: String {
        get{
            if _songAlbumImgUrl == nil {
                _songAlbumImgUrl = ""
            }
            return _songAlbumImgUrl
        }
    }
    var songArtistName: String {
        get{
            if _songArtistName == nil {
                _songArtistName = ""
            }
            return _songArtistName
        }
    }

    
    
    init(obj: AnyObject?) {
        self._track_id = obj!["track_id"] as! String
        self._song_name = obj!["name"] as! String
        self._song_duration = obj!["duration"] as! Int
        
        if let albumDictionary = obj!["album"] as? [String:AnyObject] {
            if let albumName = albumDictionary["name"] as? String {
                self._songAlbumName = albumName
            }
            
            if let image = albumDictionary["images"] as? [Dictionary<String, AnyObject>]{
                self._songAlbumImgUrl = image[0]["url"] as? String
                
            }
            if let artist = albumDictionary["artist"] as? Dictionary<String, AnyObject> {
                if let artistName = artist["name"] as? String{
                    self._songArtistName = artistName
                }
            }
            let album = Album(obj: albumDictionary)
            self._album = album
        }
        
        if let artistDictionary = obj!["artist"] as? [String:AnyObject] {
            if let artist = obj!["artist"] as? Dictionary<String, AnyObject> {
                if let artistName = artist["name"] as? String{
                    self._songArtistName = artistName
                }
            }
            let artist = Artist(obj: artistDictionary)
            self._artist = artist
        }
    }
    
    func setSongProperty(trackId: String, songName: String, album: Album?, artist: Artist?) {
        self._track_id = trackId
        self._song_name = songName
        self._album = album
        self._artist = artist
    }
    
}