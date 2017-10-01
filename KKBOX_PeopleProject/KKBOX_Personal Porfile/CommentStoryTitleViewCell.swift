//
//  CommentStoryTitleView.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/16.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

class CommentStoryTitleViewCell: UITableViewCell {
    
    
    @IBOutlet weak var postCommentTextview: UITextView!
    @IBOutlet weak var postCommentTextField: UITextField!
    @IBOutlet weak var storyContentLabel: UILabel!
    @IBOutlet weak var whoPostStoryProfileImg: MaterialProfileImgView!
    @IBOutlet weak var whoPostNameLabel: UILabel!
    
    @IBOutlet weak var storyTitle: UILabel!
    
    @IBOutlet weak var storyPostTime: UILabel!
    
    //    @IBOutlet weak var storyContentTextView: MaterialTextView!
    
    @IBOutlet weak var userProfileImg: MaterialProfileImgView!
    lazy var commentVC = CommentVC.init(nibName: "CommentVC", bundle: nil)

    var txt = ""
    var userKkboxId: String!
    var postKkboxId: String!
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        
    }
    
    
    func buttomTapped(sender: UIButton) {
        print("tap")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        postCommentTextField.delegate = self
        postCommentTextview.delegate = self
    }
    
    
    func configureCell(story: Story, user: User) {
        self.userKkboxId = user.kkboxId
        self.postKkboxId = story.kkboxId
//       self.postCommentTextField.layer.borderColor = UIColor(red: 243, green: 243, blue: 243, alpha: 1).CGColor
        let accountLeftView: UIView = UIView(frame: CGRectMake(0, 0, 10, 10))
//        postCommentTextField.leftViewMode = .Always
//        postCommentTextField.leftView = accountLeftView
        
        self.postCommentTextview.text = "寫些回覆..."
        self.postCommentTextview.textColor = UIColor.lightGrayColor() 
        self.storyTitle.text = story.storyName
        self.storyTitle.sizeToFit()
        self.storyPostTime.text = story.storyPostTime
        self.whoPostNameLabel.text = story.whoPostStory
        self.storyContentLabel.text = story.storyContent
        self.storyContentLabel.lineBreakMode = .ByCharWrapping
        self.storyContentLabel.sizeToFit()
        self.storyPostTime.sizeToFit()
        guard let imageUrl = NSURL(string: story.whoPostStoryImgUrl)else{
            return
        }
        self.whoPostStoryProfileImg.hnk_setImageFromURL(imageUrl)
        print("whoPostStoryProfileImg",imageUrl)
//        guard let imageData = NSData(contentsOfURL: imageUrl)else{
//            return
//        }
//        guard let img = UIImage(data: imageData)else{
//            return
//        }
//        self.whoPostStoryProfileImg.image = img
        
            
        
        guard let userProfileImageUrl = NSURL(string: user.userProfileImageUrl)else{
            return
        }
        self.userProfileImg.hnk_setImageFromURL(userProfileImageUrl)
//        guard let userProfileImageData = NSData(contentsOfURL: userProfileImageUrl)else{
//            return
//        }
//        guard let userProfileImg = UIImage(data: userProfileImageData)else{
//            return
//        }
//        self.userProfileImg.image = userProfileImg
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 14 // Whatever line spacing you want in points
        let text = storyContentLabel.attributedText
        let attributedString = NSMutableAttributedString(attributedString:text!)
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        storyContentLabel.attributedText = attributedString
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.frame = CGRectOffset(self.frame, 0, movement)
//        self.viewWithTag(100)!.frame = CGRectOffset(self.viewWithTag(100)!.frame, 0,  movement)
        UIView.commitAnimations()
    }
}
extension CommentStoryTitleViewCell: UITextFieldDelegate{
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.textColor == UIColor.lightGrayColor() {
            textField.text = nil
            textField.textColor = UIColor.blackColor()
        }
        animateViewMoving(true, moveValue: 180)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.returnKeyType = UIReturnKeyType.Done
        return true
    }
    
}

extension CommentStoryTitleViewCell: UITextViewDelegate{
    func textViewDidBeginEditing(textView: UITextView) {
       

        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        animateViewMoving(true, moveValue: 180)
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "寫些回覆..."
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    

}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
}

extension NSAttributedString {
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.height)
    }
}


