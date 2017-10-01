//
//  Playlist.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/22.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import Foundation

class Playlist: NSObject {
    private var _playlist_id: String!
    private var _playlist_name: String!
    private var _songs: [Song]?
    
    var playlistId: String {
        if _playlist_id == nil {
            _playlist_id = ""
        }
        return _playlist_id
    }
    var playlistName: String {
        if _playlist_name == nil {
            _playlist_name = ""
        }
        return _playlist_name
    }
    var songs: [Song]? {
        return _songs
    }
    
    init(obj: AnyObject) {
        self._playlist_id = obj["playlist_id"] as! String
        self._playlist_name = obj["playlist_name"] as! String
        
        if let songsArrayResponse = obj["songs"] as? [AnyObject] {
            var songArray = [Song]()
            songsArrayResponse.forEach({ (song) in
                let songObj = Song(obj: song)
                songArray.append(songObj)
            })
            self._songs = songArray
        }
    }
    
    
    func setPlaylistProperty(playlistId: String, playlistName: String, songs: [Song]?) {
        self._playlist_id = playlistId
        self._playlist_name = playlistName
        self._songs = songs
    }
    
}