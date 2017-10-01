//
//  MaterialImgView.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/12.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

class MaterialProfileImgView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        //make the shadow of our layer
        self.contentMode = .ScaleAspectFill
        layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        
        
        
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }
    
    
    
    



}
