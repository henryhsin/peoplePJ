//
//  Followings.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/23.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import Foundation

class Following: NSObject{
    private var _name: String!
    private var _imageUrl: String!
    
    var name: String{
        get{
            if _name == nil{
                return ""
            }
            return _name
        }
    }
    
    var imageUrl: String{
        get{
            if _imageUrl == nil{
                return ""
            }
            return _imageUrl
        }
    }
    
    init(followings: Dictionary<String, AnyObject>) {
        super.init()
        if let name = followings["name"] as? String{
            self._name = name
        }
        
        if let imageUrl = followings["image"] as? String{
            self._imageUrl = imageUrl
        }

    }
}