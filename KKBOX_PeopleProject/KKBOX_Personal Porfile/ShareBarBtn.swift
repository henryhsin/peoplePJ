//
//  UpdateBarBtn.swift
//  KKBOX_Personal Porfile
//
//  Created by 辛忠翰 on 2016/8/30.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class ShareBarBtn: UIButton {

    
    func InitUI() {
        let backImg = UIImage(named: "icon_nav_Share")
        self.setImage(backImg, forState: .Normal)
        self.frame = CGRectMake(0, 0, 30, 30)
    }

}
