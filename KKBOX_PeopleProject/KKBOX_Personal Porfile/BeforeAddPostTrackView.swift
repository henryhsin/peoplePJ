//
//  BeforeAddPostTrackView.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/26.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

class BeforeAddPostTrackView: UIView  {
    @IBOutlet weak var textField: UITextField!
    class func instanceFromNib() -> BeforeAddPostTrackView {
        return UINib(nibName: "BeforeAddPostTrackView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! BeforeAddPostTrackView
    }
    
    override func drawRect(rect: CGRect) {
        
        let searchIconImage = UIImage(named: "icon_search")
        let leftImageView = UIImageView()
        leftImageView.contentMode = .ScaleAspectFit
        leftImageView.image = searchIconImage
        
        let leftView = UIView()
        leftView.frame = CGRectMake(0, 0, 40, 20)
        leftView.addSubview(leftImageView)
        
        leftImageView.frame = CGRectMake(13, 6, 20, 20)
        textField.leftView = leftView
        textField.leftViewMode = UITextFieldViewMode.Always
        textField.addSubview(leftImageView)
        
        
        textField.placeholder = "搭配一首歌曲..."
        textField.layer.cornerRadius=5.0;
        
        
    }
}








