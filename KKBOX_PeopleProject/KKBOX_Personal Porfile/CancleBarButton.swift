//
//  CancleBarButton.swift
//  KKBOX_Personal Porfile
//
//  Created by 辛忠翰 on 2016/8/30.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class CancleBarButton: UIButton {

    func InitUI() {
        let backImg = UIImage(named: "取消")
        self.setImage(backImg, forState: .Normal)
        self.frame = CGRectMake(0, 0, 30, 30)
    }
    func feedVCInitUI() {
        let backImg = UIImage(named: "取消")
        self.setImage(backImg, forState: .Normal)
        self.frame = CGRectMake(0, 0, 0, 0)
    }

}
