//
//  PostCellFooter.swift
//  KKBOX_Personal Porfile
//
//  Created by 辛忠翰 on 2016/8/29.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class PostCellFooterView: UIView {
    @IBOutlet var button : UIButton?
    var buttonAction: (()->())?
//    
    class func instanceFromNib() -> PostCellFooterView {
        return UINib(nibName: "PostCellFooterView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PostCellFooterView
    }
    
    
    @IBAction func upToTableView(sender: MaterialButton) {
        buttonAction?()
    }
}
