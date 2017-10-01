//
//  LoginViewController.swift
//  KKBOX_Personal Porfile
//
//  Created by Chun Tai on 2016/9/20.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import SafariServices
import Alamofire

class LoginViewController: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    
    var safariController: SFSafariViewController!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.didLogin(_:)), name: KKBOXAppDidLoginNotification, object: nil)
    }
    
    
    
    //MARK: - Action
    @IBAction func loginButtonTapped(sender: AnyObject) {
            guard let URL = NSURL(string: LoginPageURL) else {
                return
            }
            self.safariController = SFSafariViewController(URL: URL)
            self.presentViewController(self.safariController, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        safariController.delegate = self
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didLogin(n: NSNotification) {
        guard let token = n.userInfo![CallbackPrefix] else {
            return
        }
        NSUserDefaults.standardUserDefaults().setValue(token, forKey: "token")
        
        ServerManager.getMe({ (user) in
            let meId = user.meUserId
            let meName = user.meUserName
            
            NSUserDefaults.standardUserDefaults().setValue(meId, forKey: "meId")
            NSUserDefaults.standardUserDefaults().setValue(meName, forKey: "meName")
            
            let window = appDelegate().window
            let tabBarVC = appDelegate().tabBarController
            window?.rootViewController = tabBarVC
            
            self.showViewController(tabBarVC, sender: self)
            }, failure: { (error) in
                print("getMe error: \(error)")
        })
    }
}
