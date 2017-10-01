//
//  CustomSearchBar.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/18.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {
    
    var preferredFont: UIFont!
    
    var preferredTextColor: UIColor!
    
    override func drawRect(rect: CGRect) {
        // Find the index of the search field in the search bar subviews.
        if let index = indexOfSearchFieldInSubviews() {
            // Access the search field
            let searchField: UITextField = subviews[0].subviews[index] as! UITextField
            
            // Set its frame.
            searchField.frame = CGRectMake(5.0, 5.0, frame.size.width - 10.0, frame.size.height - 10.0)
            
            // Set the font and text color of the search field.
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor
            
            // Set the background color of the search field.
            searchField.backgroundColor = barTintColor
        }
        
        super.drawRect(rect)
    }
    
    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
        
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        
        searchBarStyle = UISearchBarStyle.Prominent
        translucent = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //因為searchBar為一個元件，且裡面有兩個subView，分別為搜尋文字框和搜尋文字框(UITextField)的背景視圖(background view)
    //所以此func會return textField在這view中的index
    func indexOfSearchFieldInSubviews() -> Int! {
        // Uncomment the next line to see the search bar subviews.
        // println(subviews[0].subviews)
        
        var index: Int!
        let searchBarView = subviews[0]
        
        for i in 0 ..< searchBarView.subviews.count{
            if searchBarView.subviews[i].isKindOfClass(UITextField) {
                index = i
                break
            }
            
        }
        return index
    }
    
    
}
