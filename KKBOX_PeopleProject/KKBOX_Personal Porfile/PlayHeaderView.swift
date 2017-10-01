//
//  PlayHeaderView.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/8/25.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class PlayHeaderView: UIView {

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "PlayHeaderView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }

}
