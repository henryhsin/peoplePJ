//
//  CommentTableFooterView.swift
//  KKBOX_Personal Porfile
//
//  Created by 辛忠翰 on 2016/12/12.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class CommentTableFooterView: UIView {
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CommentTableFooterView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
}
