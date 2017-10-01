//
//  MaterialSegmentedControl.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/12.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

@IBDesignable
class MaterialSegmentedControl: UIControl {
    private var labels = [UILabel]()
    private var thumbView = UIView()
    
    var items: [String] = ["動態", "探索"]{
        didSet{
            setupLabels()
        }
    }
    
    //目前選擇到的segmented control index
    var selectedIndex: Int = 0{
        didSet{
            displayNewSelectedIndex()
        }
    }
    
    func setupLabels(){
        //第一件事就是先把預設的label移除，以便之後加入我們的label
        for label in labels{
            label.removeFromSuperview()
        }
        
        //一旦把label從superView中移除，我們也就可以把label從labels arr中全移除
        labels.removeAll(keepCapacity: true)
        
        //將預設的label移除完後，便可以加入自己的label
        
        for index in 1...items.count{
            //先做出一個(x, y) = (0, 0); 寬高也皆為0的label
            let label = UILabel(frame: CGRectZero)
            label.text = items[index - 1]
            label.textAlignment = .Center
            label.textColor = UIColor(red: 0/255, green: 174/255, blue: 216/255, alpha: 1.0)
            self.addSubview(label)
            labels.append(label)
        }
    }
    
    func setupView() {
        //layer is a part of UIControl
        layer.cornerRadius = frame.height/2
        layer.borderColor = UIColor(white: 1.0, alpha: 0.5).CGColor
        layer.borderWidth = 2.0
        
        backgroundColor = UIColor.clearColor()
        
        self.setupLabels()
        insertSubview(thumbView, atIndex: 0)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder : NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    //來追蹤我們點擊到哪個segmented controll
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        //we want to get the location that the user touched
        let location = touch.locationInView(self)
        
        var caculateIndex: Int?
        for(index, item) in EnumerateSequence(labels){
            if item.frame.contains(location){
                caculateIndex = index
            }
            
            if caculateIndex != nil{
                selectedIndex = caculateIndex!
                sendActionsForControlEvents(.ValueChanged)
            }
        }
        return false
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectedFrame = self.bounds
        let newWidth = CGRectGetWidth(selectedFrame) / CGFloat(self.items.count)
        selectedFrame.size.width = newWidth
        
        
        thumbView.frame = selectedFrame
        thumbView.backgroundColor = UIColor.whiteColor()
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        
        let lableHeight = self.bounds.height
        let labelWidth = self.bounds.width / CGFloat(labels.count)
        
        for index in 0...labels.count - 1{
            let label = labels[index]
            
            let xPosition = CGFloat(index) * labelWidth
            label.frame = CGRectMake(xPosition, 0, labelWidth, lableHeight)
        }
        
        
        
        
    }
    
    
    
    
    func displayNewSelectedIndex() {
        let label = self.labels[selectedIndex]
        self.thumbView.frame = label.frame
    }
    
}
