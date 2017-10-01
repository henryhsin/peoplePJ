//
//  MusicStyleButton.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/23.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class MusicStyleButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initUI()
    }
    
    func initUI() {
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        self.setTitleColor(UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1), forState: .Normal)
    }
}
