//
//  BackButton.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/23.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class BackButton: UIButton {

    func InitUI() {
        let backImg = UIImage(named: "btn_back arrow")
        self.setImage(backImg, forState: .Normal)
        self.frame = CGRectMake(0, 0, 30, 30)
    }
}
