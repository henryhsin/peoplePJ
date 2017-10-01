import UIKit

protocol StrangerGoToPlayerVCButtonDelegate {
//    func strangerGoToPlayerVCButtonTapped(cell: StrangerDynamicPostWallCell)
    func strangerGoToPlayerVCButtonTapped(cell: StrangerDynamicPostWallCell,selectStory: StrangerStories)
}

protocol StrangerDynamicPostWallCellDelegate {
    func passTheCell(cell: StrangerDynamicPostWallCell?)
    
}
class StrangerDynamicPostWallCell: UITableViewCell {
    var strangerDynamicPostWallCellDelegate: StrangerDynamicPostWallCellDelegate?
    @IBOutlet weak var CDContainerView: MaterialView!
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var storyContent: InsetLabel!
    @IBOutlet weak var trackImg: UIImageView!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    
    @IBOutlet weak var ArtistNameAlbumNameLabel: UILabel!
    
    @IBOutlet weak var storyTitleLabel: UILabel!
    
    @IBOutlet weak var postDateLabel: UILabel!
    
    
    @IBOutlet weak var reasonLabel: UILabel!
    
    
    @IBOutlet weak var likeImg: UIImageView!
    
    @IBOutlet weak var likeNumLabel: UILabel!
    
    
    @IBOutlet weak var commentImg: UIImageView!
    
    @IBOutlet weak var commentNumLabel: UILabel!
    
   
    var likeNum: Int!
    
    var selectedStioryId: String!
    var existSelectedCommentId = [String]()
    var buttonDelegate: StrangerGoToPlayerVCButtonDelegate?
//    var selectedStory: Story?
    var selectedStory: StrangerStories?

    var kkboxId: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(StrangerDynamicPostWallCell.likeTapped(_:)))
        likeTap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(likeTap)
        likeImg.userInteractionEnabled = true
        
        
        let goToProfileTap = UITapGestureRecognizer(target: self, action: #selector(profileTapped(_:)))
        //只需點擊一次，即可觸發likeTapped
        goToProfileTap.numberOfTapsRequired = 1
        //在likeImg上，添加tap這個gesture
        profileImg.addGestureRecognizer(goToProfileTap)
        //controll by default,do not have the user interaction enabel, so we need to enable the user interaction mannual
        profileImg.userInteractionEnabled = true

        
    }
    func profileTapped(sender: UIGestureRecognizer){
        if let delegate = strangerDynamicPostWallCellDelegate{
            delegate.passTheCell(self)
        }
        
    }
    
    func likeTapped(sender: UIGestureRecognizer){
        if self.likeImg.image == UIImage(named: "icon_like_normal"){
            self.likeImg.image = UIImage(named: "icon_like_actived")
            self.likeNum = self.likeNum + 1
            self.likeNumLabel.text = "\(self.likeNum)"
            self.likeNumLabel.textColor = UIColor(red: 0, green: 174/255, blue: 216/255, alpha: 1)
        }else{
            self.likeImg.image = UIImage(named: "icon_like_normal")
            self.likeNum = self.likeNum - 1
            self.likeNumLabel.text = "\(self.likeNum)"
            self.likeNumLabel.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        }
        let meId = NSUserDefaults.standardUserDefaults().valueForKey("meId") as? String
        ServerManager.getStoryCollection(userId: meId!, completion: { (stories) in
            if stories.count > 0{
                for story in stories{
                    if story.storyId == self.selectedStioryId{
                        ServerManager.decollectStory(storyId: story.storyId, completion: {
                            }, failure: { (error) in
                                
                        })
                    }else{
                        ServerManager.collectStory(storyId: self.selectedStioryId, completion: {
                            }, failure: { (error) in
                                
                        })
                    }
                }
            }else{
                ServerManager.collectStory(storyId: self.selectedStioryId, completion: {
                    }, failure: { (error) in
                        
                })
            }
        }) { (error) in
            
        }
    }
    
    
    func getDispatchTimeByDate(date: NSDate) -> dispatch_time_t {
        let interval = date.timeIntervalSince1970
        var second = 0.0
        let subsecond = modf(interval, &second)
        var time = timespec(tv_sec: __darwin_time_t(second), tv_nsec: (Int)(subsecond * (Double)(NSEC_PER_SEC)))
        return dispatch_walltime(&time, 0)
    }
    
    
    override func drawRect(rect: CGRect) {
        
        trackImg.contentMode = .ScaleAspectFill
        trackImg.layer.cornerRadius = 3.0
        trackImg.clipsToBounds = true
        
        
        
    }
    
    @IBAction func goToPlayerVC(sender: UIButton) {
        if let delegate = buttonDelegate{
//            delegate.strangerGoToPlayerVCButtonTapped(self)
            delegate.strangerGoToPlayerVCButtonTapped(self, selectStory: selectedStory!)
        }
    }
    
    
    func configureCell(story: StrangerStories){
        self.kkboxId = story.kkboxId
        guard let profileImageURL = NSURL(string: story.whoPostStoryImgUrl)else{
            return
        }
        self.profileImg.hnk_setImageFromURL(profileImageURL)
//        guard let profileImageData = NSData(contentsOfURL: profileImageURL)else{
//            return
//        }
//        guard let img = UIImage(data: profileImageData)else{
//            return
//        }
//        self.profileImg.image = img
        
        
        
        guard let albumCoverImageUrl = NSURL(string: story.storySongCoverUrl)else{
            return
        }
        self.trackImg.hnk_setImageFromURL(albumCoverImageUrl)
//        guard let albumCoverImageData = NSData(contentsOfURL: albumCoverImageUrl)else{
//            return
//        }
//        guard let albumCoverImg = UIImage(data: albumCoverImageData)else{
//            return
//        }
//        self.trackImg.image = albumCoverImg
//        let imageColor = self.trackImg.image?.getPixelColor(CGPointMake(self.trackImg.bounds.size.width/2 - 10, self.trackImg.bounds.size.height/2 - 10))
//        let whiteColor = UIColor.whiteColor().CGColor
//        let gradient = CAGradientLayer()
//        gradient.colors = [(imageColor?.CGColor)!,whiteColor]
//        gradient.startPoint = CGPointMake(0, 0)
//        gradient.endPoint = CGPointMake(1, 0)
//        gradient.frame = self.CDContainerView.bounds
//        CDContainerView.layer.insertSublayer(gradient, atIndex: 0)
        
        
        self.selectedStioryId = story.storyId
        self.selectedStory = story
        self.commentNumLabel.text = "\(story.storyComments.count)" + "\(story.storyTopTwoComments.count)"
        self.likeNumLabel.text = "\(story.storyLikeNum)"
        self.likeNumLabel.sizeToFit()
        self.commentNumLabel.sizeToFit()
        self.profileNameLabel.text = story.whoPostStory
        self.storyTitleLabel.text = story.storyName
        self.storyTitleLabel.sizeToFit()
        self.postDateLabel.text = story.storyPostTime
        self.postDateLabel.sizeToFit()
        self.trackNameLabel.text = story.storySongName
        self.ArtistNameAlbumNameLabel.text = "\(story.stroySongArtistName)"+"  \(story.storySongAlbumName)"
        self.reasonLabel.text = story.reasonToRecommend
        self.storyContent.text = story.storyContent
        self.likeNum = story.storyLikeNum
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8 // Whatever line spacing you want in points
        let text = storyContent.attributedText
        let attributedString = NSMutableAttributedString(attributedString:text!)
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        storyContent.attributedText = attributedString
    }
}

class InsetLabel: UILabel {
    let topInset = CGFloat(0.0), bottomInset = CGFloat(0.0), leftInset = CGFloat(0.0), rightInset = CGFloat(0.0)
    
    override func drawTextInRect(rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override func intrinsicContentSize() -> CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize()
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}


