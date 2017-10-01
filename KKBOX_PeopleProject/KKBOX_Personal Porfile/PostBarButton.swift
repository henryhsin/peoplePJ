//
//  PostBarButton.swift
//  KKBOX_Personal Porfile
//
//  Created by 辛忠翰 on 2016/8/30.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class PostBarButton: UIButton {
    
    func InitUI() {
        let backImg = UIImage(named: "新增")
        self.setImage(backImg, forState: .Normal)
        self.frame = CGRectMake(0, 0, 30, 30)
    }

    func setPostUI(){
        let backImg = UIImage(named: "btn_story_send")
        self.setImage(backImg, forState: .Normal)
        self.frame = CGRectMake(0, 0, 30, 30)
    }

}
