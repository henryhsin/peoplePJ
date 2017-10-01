//
//  OriginalPlayHeaderView.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tie Lin on 2016/8/25.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class OriginalPlayHeaderView: UIView {

    @IBOutlet weak var blueHeaderView: UIView!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "OriginalPlayHeaderView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.blueHeaderView.clipsToBounds = true
        self.blueHeaderView.layer.cornerRadius = 20
    }
}
