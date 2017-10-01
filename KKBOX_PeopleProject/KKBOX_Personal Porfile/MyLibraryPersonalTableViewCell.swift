//
//  MyLibraryPersonalTableViewCell.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/10/11.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit

class MyLibraryPersonalTableViewCell: UITableViewCell {

    @IBOutlet weak var personalBackgroundImageView: UIImageView!
    @IBOutlet weak var personalImageView: UIImageView!
    @IBOutlet weak var personalNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    override func drawRect(rect: CGRect) {
        self.personalImageView.layer.cornerRadius = self.personalImageView.bounds.size.width/2
        self.personalImageView.clipsToBounds = true
    }
    
    func configCell() {
        if let userName = NSUserDefaults.standardUserDefaults().valueForKey("meName") as? String {
            self.personalNameLabel.text = userName
        } else {
            self.personalNameLabel.text = ""
        }
         
        print("MyLibraryUserName", NSUserDefaults.standardUserDefaults().valueForKey("maName"))
    }
}
