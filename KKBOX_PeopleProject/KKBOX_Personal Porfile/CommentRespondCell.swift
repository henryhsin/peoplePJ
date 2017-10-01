//
//  CommentRespondVellTableViewCell.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/16.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

protocol CommentRespondCellDelegate {
    func passCell(cell: CommentRespondCell?)
    
}


class CommentRespondCell: UITableViewCell {
    
    var commentRespondCelldelegate: CommentRespondCellDelegate?

    @IBOutlet weak var whoPostImg: MaterialProfileImgView!
    
    @IBOutlet weak var whoPostNameLabe: MaterialLabel!
    
    @IBOutlet weak var whoPostTime: UILabel!
    
    @IBOutlet weak var commentContent: UILabel!
    
    @IBOutlet weak var likeNumLabel: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    lazy var commentVC = CommentVC(nibName: "CommentVC", bundle: nil)
    var selectedCommentId: String!
    var existSelectedCommentId = [String]()
    
    var likeNum: Int!
    var kkboxId: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(CommentRespondCell.likeTapped(_:)))
        //只需點擊一次，即可觸發likeTapped
        likeTap.numberOfTapsRequired = 1
        //在likeImg上，添加tap這個gesture
        likeImg.addGestureRecognizer(likeTap)
        //controll by default,do not have the user interaction enabel, so we need to enable the user interaction mannual
        likeImg.userInteractionEnabled = true
        
        
    }
    
      
    
    
    
    
    
    func likeTapped(sender: UIGestureRecognizer){
        if self.likeImg.image == UIImage(named: "icon_like_normal"){
            self.likeImg.image = UIImage(named: "icon_like_actived")
            self.likeNum = self.likeNum + 1
            self.likeNumLabel.text = "\(self.likeNum)"
            ServerManager.likeComment(commentId: self.selectedCommentId, completion: {
                }, failure: { (error) in
                    
            })
        }else{
            self.likeImg.image = UIImage(named: "icon_like_normal")
            self.likeNum = self.likeNum - 1
            self.likeNumLabel.text = "\(self.likeNum)"
            ServerManager.decollectComment(commentId: self.selectedCommentId, completion: {
                }, failure: { (error) in
            })
        }
    }
    
    func configureCell(comment: Comment) {
        let goToProfileTap = UITapGestureRecognizer(target: self, action: #selector(goToProfileViewController))
        goToProfileTap.numberOfTapsRequired = 1
        whoPostImg.addGestureRecognizer(goToProfileTap)
        whoPostImg.userInteractionEnabled = true        
        self.kkboxId = comment.kkboxId
        self.whoPostNameLabe.text = comment.whoPostComment
        self.whoPostTime.text = comment.postCommentTime
        self.whoPostTime.sizeToFit()
        self.commentContent.text = comment.commentContent
        self.commentContent.lineBreakMode = .ByCharWrapping
        self.commentContent.sizeToFit()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 14 // Whatever line spacing you want in points
        let text = commentContent.attributedText
        let attributedString = NSMutableAttributedString(attributedString:text!)
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        commentContent.attributedText = attributedString
        self.likeNumLabel.text = comment.commentLikeNum
        self.selectedCommentId = comment.commentId
        self.likeNum = Int(comment.commentLikeNum)
        
        guard let profileImageURL = NSURL(string: comment.commentPostManPhototUrl)else{
            return
        }
        
        guard let profileImageData = NSData(contentsOfURL: profileImageURL)else{
            return
        }
        guard let profileImg = UIImage(data: profileImageData)else{
            return
        }
        self.whoPostImg.image = profileImg
    }
    
    func goToProfileViewController(){
        print("commentRespondCelldelegate",commentRespondCelldelegate)
        if let delegate = commentRespondCelldelegate {
            
            delegate.passCell(self)
        }
    }
}

    
    
    
    

