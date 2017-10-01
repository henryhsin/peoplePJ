//
//  MaterialButton.swift
//  SNSRealTimeAppOldVision
//
//  Created by 辛忠翰 on 2016/6/23.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

class MaterialButton: UIButton {
    override func awakeFromNib() {
        //make the shadow of our layer
        layer.cornerRadius = 3.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.8).CGColor
        //給shadowOpacity屬性一個大於默認值（也就是0）的值，陰影就可以顯示在任意圖層之下。shadowOpacity是一個必須在0.0（不可見）和1.0（完全不透明）之間的浮點數。如果設置為1.0，將會顯示一個有輕微模糊的黑色陰影稍微在圖層之上。若要改動陰影的表現，你可以使用CALayer的另外三個屬性：shadowColor，shadowOffset和shadowRadius。
        //原文連結：https://read01.com/48yMk6.html
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 3.0)
    }
}
