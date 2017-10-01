//
//  MaterialLabel.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/11.
//  Copyright © 2016年 Keynote. All rights reserved.
//UILabel設置的參考

//http://www.hangge.com/blog/cache/detail_528.html
import UIKit

class MaterialLabel: UILabel {

    
    //這可以讓Label中的文字偏移
    //http://stackoverflow.com/questions/27459746/adding-space-padding-to-a-uilabel-swift
    override func drawTextInRect(rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
        
    }
    

    //若是要overRode property需要用getter和setter的方式寫
    override var adjustsFontSizeToFitWidth: Bool{
        get {
            return super.adjustsFontSizeToFitWidth
        }
        set {
            super.adjustsFontSizeToFitWidth = true
        }
    }
    
    override func awakeFromNib() {
        //make the shadow of our layer
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }
    
}
