//
//  MaterialTextFieldView.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/17.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

class MaterialTextView: UITextView {
    override func awakeFromNib() {
        //make the shadow of our layer
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).CGColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 4.0)
    }

}
