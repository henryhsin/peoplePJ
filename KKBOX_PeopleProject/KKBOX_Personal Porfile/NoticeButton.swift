//
//  NoticeButton.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tie Lin on 2016/8/27.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class NoticeButton: UIButton {

    func InitUI() {
        let backImg = UIImage(named: "btn_notice")
        self.setImage(backImg, forState: .Normal)
        self.frame = CGRectMake(0, 0, 30, 30)
    }
}
