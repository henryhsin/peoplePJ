//
//  CustomSegmentedControl.swift
//  KKBox_People_Project
//
//  Created by Chun Tie Lin on 2016/8/27.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl {

    func initUI(){
        setupBackground()
        setupFonts()
    }
    
    func setupBackground(){
        let backgroundImage = UIImage(named: "segment_bg_half")
        let backgroundImageSelected = UIImage(named: "segment_bg_actived")
        
        self.frame = CGRectMake(0, 0, 320, 44)
        self.setBackgroundImage(backgroundImage, forState: .Normal, barMetrics: .Default)
        self.setBackgroundImage(backgroundImageSelected, forState: .Highlighted, barMetrics: .Default)
        self.setBackgroundImage(backgroundImageSelected, forState: .Selected, barMetrics: .Default)
        
        self.setDividerImage(imageWithColor(UIColor.whiteColor()), forLeftSegmentState: .Normal, rightSegmentState: .Normal, barMetrics: .Default)
    }
    
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
    
    func setupFonts(){
        let font = UIFont(name: "PingFang TC", size: 14)
        
        
        let normalTextAttributes = [
            NSForegroundColorAttributeName: UIColor.init(red: 120/255, green: 120/255, blue: 120/255, alpha: 1),
            NSFontAttributeName: font!
        ]
        
        let selectedTextAttributes = [
            NSForegroundColorAttributeName: UIColor.init(red: 0, green: 174/255, blue: 216/255, alpha: 1),
            NSFontAttributeName: font!
        ]
        
        self.setTitleTextAttributes(normalTextAttributes, forState: .Normal)
        self.setTitleTextAttributes(selectedTextAttributes, forState: .Highlighted)
        self.setTitleTextAttributes(selectedTextAttributes, forState: .Selected)
    }


}
