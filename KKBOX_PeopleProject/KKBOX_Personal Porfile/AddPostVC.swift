//
//  AddPostVCViewController.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/16.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit


class AddPostVC: UIViewController {
    
    @IBOutlet weak var searchTrackView: UIView!
    
    @IBOutlet weak var storyTitleTextField: UITextField!
    @IBOutlet weak var storyContentTextFieldView: UITextView!
    
    let storyTime = "20160827"
    var storyTitle: String!
    var storyContent: String!
    var feedVC: FeedVC!
    var isTextFieldEdit: Bool!
    var isTextViewEdit: Bool!
    let rightBarButton = PostBarButton()

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var beforeAddPostTrackView = BeforeAddPostTrackView.instanceFromNib()
    var afterAddPostTrackView = AfterAddPostTrackView.instanceFromNib()
    
    var selectedSong: Song!
    var postedStory: Story!
    
    convenience init(song: Song){
        self.init(nibName: "AddPostVC", bundle: nil)
        self.selectedSong = song
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isTextFieldEdit = false
        isTextViewEdit = false
        self.title = "新增故事"
        self.navigationController?.navigationBar.barTintColor =
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        
        rightBarButton.InitUI()
        rightBarButton.addTarget(self, action: #selector(self.postStory), forControlEvents: .TouchUpInside)
        let rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.customView = rightBarButton
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
        let leftBarButton = CancleBarButton()
        leftBarButton.InitUI()
        leftBarButton.addTarget(self, action: #selector(self.backToLastView), forControlEvents: .TouchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = leftBarButton
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        
        
        
        
        self.beforeAddPostTrackView.textField.tag = 100
        self.beforeAddPostTrackView.textField.delegate = self
        self.storyTitleTextField.delegate = self
        
        afterAddPostTrackView.tag = 101
        
        self.storyContentTextFieldView.delegate = self
        self.storyContentTextFieldView.text = "想些什麼..."
        self.storyContentTextFieldView.textColor = UIColor.lightGrayColor()
        self.storyContentTextFieldView.font = UIFont(name: "PingFang TC" , size: 12)
        
        
    }
    
    func backToLastView(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func backToFeedVC(){
        var feedVC: FeedVC!
        feedVC = FeedVC.init(isFromAddPostVC: true)
        self.navigationController?.pushViewController(feedVC, animated: true)
        
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.searchTrackView.addSubview(beforeAddPostTrackView)
        self.beforeAddPostTrackView.tag = 100
        if selectedSong != nil{
            self.removeSubview()
            self.searchTrackView.addSubview(afterAddPostTrackView)
            afterAddPostTrackView.center = CGPointMake(searchTrackView.frame.size.width  / 2, searchTrackView.frame.size.height / 2)
            afterAddPostTrackView.configureView(self.selectedSong)
        }
        
        isTextFieldEdit = false
        isTextViewEdit = false
        
    }
    
    func removeSubview(){
        for subView in self.searchTrackView.subviews{
            if subView.tag == 100{
                subView.removeFromSuperview()
            }
        }
        
    }
    
    func postStory(){
        if isTextFieldEdit && isTextViewEdit{
            self.addStoryToServer(self.storyTitle, storyContent: self.storyContentTextFieldView.text, song: self.selectedSong)
        }
    }
    
    //MARK: -HttpRequest
    func addStoryToServer(storyTitle: String, storyContent: String, song: Song){
        let group = dispatch_group_create()
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_group_enter(group)
        dispatch_group_async(group, queue, {
            ServerManager.addStory(storyTitle: storyTitle, storyContent: storyContent, createTime: self.storyTime, songId: song.trackId, completion: {
                dispatch_async(dispatch_get_main_queue(), {
                    self.backToFeedVC()
                    dispatch_group_leave(group)
                })
                
            }) { (error) in
                dispatch_group_leave(group)
                
            }
        })
        
        
    }
    
    
    
    
    
}

extension AddPostVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 100{
            let addStoryVC = AddStoryVC.init(nibName: "AddStoryVC", bundle: nil)
            self.navigationController?.pushViewController(addStoryVC, animated: true)
            textField.resignFirstResponder()
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.storyTitle = textField.text
        
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let maxtext = 10
        let count = textField.text!.characters.count + (string.characters.count - range.length)
        if count > 0{
            isTextFieldEdit = true
        }else{
            isTextFieldEdit = false
        }
        if isTextViewEdit && isTextFieldEdit{
            rightBarButton.setPostUI()
            rightBarButton.addTarget(self, action: #selector(self.postStory), forControlEvents: .TouchUpInside)
            let rightBarButtonItem = UIBarButtonItem()
            rightBarButtonItem.customView = rightBarButton
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        }else{
            rightBarButton.InitUI()
            rightBarButton.addTarget(self, action: #selector(self.postStory), forControlEvents: .TouchUpInside)
            let rightBarButtonItem = UIBarButtonItem()
            rightBarButtonItem.customView = rightBarButton
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
            
        }
        if count <= maxtext{
            print("textCount:",count)
            return true
        }
        return false
    }
    
}


//為TextView創造placeholder的效果
extension AddPostVC: UITextViewDelegate{
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "想些什麼..."
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
        self.storyContent = textView.text
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        let maxtext: Int = 100
        let count = textView.text.characters.count + (text.characters.count - range.length)
        if count > 0{
            isTextViewEdit = true
        }else{
            isTextFieldEdit = false
        }
        if isTextViewEdit && isTextFieldEdit{
            rightBarButton.setPostUI()
            rightBarButton.addTarget(self, action: #selector(self.postStory), forControlEvents: .TouchUpInside)
            let rightBarButtonItem = UIBarButtonItem()
            rightBarButtonItem.customView = rightBarButton
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        }else{
            rightBarButton.InitUI()
            rightBarButton.addTarget(self, action: #selector(self.postStory), forControlEvents: .TouchUpInside)
            let rightBarButtonItem = UIBarButtonItem()
            rightBarButtonItem.customView = rightBarButton
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        if count <= maxtext{
            return true
        }
        return false
        
    }
    
    
}



