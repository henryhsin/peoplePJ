//
//  MaterialBackgroundView.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/14.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit
class MaterialBackgroundView: MaterialView{
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.opacity = 0.74
        layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).CGColor
    }
}