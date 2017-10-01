//
//  MaterialTextField.swift
//  SNSRealTimeAppOldVision
//
//  Created by 辛忠翰 on 2016/6/23.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.borderWidth = 1.0

    }
    
    // for placeholder
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        //向右偏移10
        self.borderStyle = .None
        self.returnKeyType = .Done
        return CGRectInset(bounds, 10, 0)
    }
    
    // fot editable text
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    }
