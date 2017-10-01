//
//  TableHeaderView.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/25.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class BackgroundImageView: UIView {

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    
    }
    
    func addImageView(image: UIImage, width: CGFloat, height: CGFloat) {
        let backgroundImageView = UIImageView(image: image)
        backgroundImageView.frame = CGRectMake(0, 0, width, height)
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        visualEffectView.frame = backgroundImageView.bounds
        
        backgroundImageView.addSubview(visualEffectView)
        self.addSubview(backgroundImageView)
    }
}


