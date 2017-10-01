//
//  AddStoryVC.swift
//  KKBox_People_Project
//
//  Created by 辛忠翰 on 2016/8/16.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

class AddStoryVC:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource
{
    
    var dataArray = [String]()
    
    var filteredArray = [String]()
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    
    var customSearchController: CustomSearchController!
    var feedVC: FeedVC!
    var addPostVC: AddPostVC!
    
    var historySongs = [Song]()
    var searchSongs = [Song]()
    var selectedSong: Song!
    let nib0 = UINib(nibName: "AddStoryCell", bundle: nil)
    var searchText = String()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //MARK: -Http Request
    func getHistorySongsInfo() {
        hideView.hidden = false
        spinner.startAnimating()
        if !self.historySongs.isEmpty{
            self.historySongs.removeAll()
        }
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            ServerManager.getTrackByTagName(tagName: "爵士", completion: { (songs) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.historySongs = songs
                    self.hideView.hidden = true
                    self.spinner.stopAnimating()
                    self.tableView.reloadData()
                })
                
            }) { (error) in
            }
        }
    }
    
    func searchSong(query query: String){
        if !self.historySongs.isEmpty{
            self.historySongs.removeAll()
        }
            ServerManager.search(query: query, completion: { (tracks) in
                self.historySongs = tracks
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }) { (error) in
                dispatch_async(dispatch_get_main_queue(), {
                })
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideView.hidden = false
        spinner.startAnimating()
        tableView.delegate = self
        tableView.dataSource = self
        // 導覽列標題
        self.title = "新增故事"
        // 導覽列底色
        self.navigationController?.navigationBar.barTintColor =
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        // 導覽列左邊按鈕
        let rightBarButton = PostBarButton()
        rightBarButton.InitUI()
        rightBarButton.addTarget(self, action: nil, forControlEvents: .TouchUpInside)
        
        let rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.customView = rightBarButton
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
        let leftBarButton = CancleBarButton()
        leftBarButton.InitUI()
        leftBarButton.addTarget(self, action: #selector(self.backToLastView), forControlEvents: .TouchUpInside)
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = leftBarButton
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        tableView.registerNib(nib0, forCellReuseIdentifier: "AddStoryCell")
        self.searchTextfield.addTarget(self, action:#selector(self.textFieldEditChanged), forControlEvents: .EditingChanged)
        let searchIconImage = UIImage(named: "icon_search")
        let leftImageView = UIImageView()
        leftImageView.contentMode = .ScaleAspectFit
        leftImageView.image = searchIconImage
        let leftView = UIView()
        leftView.frame = CGRectMake(0, 0, 30, 33)
        leftView.addSubview(leftImageView)
        leftImageView.frame = CGRectMake(13, 6, 20, 20)
        searchTextfield.leftView = leftView
        searchTextfield.leftViewMode = .Always
        searchTextfield.delegate = self
    

    }
    
    func textFieldEditChanged(textField: UITextField) {
        if textField.markedTextRange == nil{
            searchSong(query: textField.text!)
        }
    }
    override func viewWillAppear(animated: Bool){
        hideView.hidden = false
        spinner.startAnimating()
        if searchTextArray.isEmpty{
            self.getHistorySongsInfo()
        }
    }
    func backToLastView(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //MARK: -tableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddStoryCell") as! AddStoryCell
        if self.historySongs.count > 0{
            let song = self.historySongs[indexPath.row]
            cell.configureCell(song)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let addStoryHeaderView = AddStoryHeaderView.instanceFromNib()
        return addStoryHeaderView
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.historySongs.count > 0{
            self.selectedSong = self.historySongs[indexPath.row]
            self.searchTextfield.text = ""
            addPostVC = AddPostVC.init(song: historySongs[indexPath.row])
            self.navigationController?.pushViewController(addPostVC, animated: true)
        }
    }
    func backToFeedVC(){
        var feedVC: FeedVC!
        feedVC = FeedVC.init(nibName: "FeedVC", bundle: nil)
        self.navigationController?.pushViewController(feedVC, animated: true)
    }
    
    
    @IBOutlet weak var searchTextfield: UITextField!

    var searchTextArray = [String]()
    
    @IBAction func deleteSearchText(sender: UIButton) {
        textFieldShouldClear(searchTextfield)
    }
    
}

extension AddStoryVC: UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        textField.becomeFirstResponder()
        let count = textField.text!.characters.count + (string.characters.count - range.length)
        if count > 0{
            if range.length == 0{
                searchText = textField.text! + string
                print("searchText",searchText)
            }else{
                searchText = String(searchText.characters.dropLast())
                print("searchText--Delete",searchText)
            }
        }
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        textField.text = ""
        searchTextArray.removeAll()
        self.getHistorySongsInfo()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
    }
    
}


