//
//  DynaamicCellView.swift
//  KKBOX_Personal Porfile
//
//  Created by 辛忠翰 on 2016/12/12.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//
import UIKit

class DynamicCellView: UIView {
    
    override func awakeFromNib() {
        //make the shadow of our layer
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).CGColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 1.0
        layer.shadowOffset = CGSizeMake(0.0, 1.0)
        
        
       

    }
    
    
}


