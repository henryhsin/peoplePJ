//
//  File.swift
//  KKBOX_Personal Porfile
//
//  Created by 辛忠翰 on 2016/12/12.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class MaterialTrackContainerView: UIImageView{
    
    func addImageView(image: UIImage, width: CGFloat, height: CGFloat) {
        let backgroundImageView = UIImageView(image: image)
        backgroundImageView.frame = CGRectMake(0, 0, width, height)
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        visualEffectView.frame = backgroundImageView.bounds
        
        backgroundImageView.addSubview(visualEffectView)
        self.addSubview(backgroundImageView)
    }
    
}