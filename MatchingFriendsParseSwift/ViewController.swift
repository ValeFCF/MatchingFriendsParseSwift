//
//  ViewController.swift
//  MatchingFriendsParseSwift
//
//  Created by Emmanuel Valentín Granados López on 03/11/15.
//  Copyright © 2015 DevWorms. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Parse

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if ((FBSDKAccessToken.currentAccessToken()) == nil){
            print("Not logged in..")
            
        }else{
            print("Logged in..")
            //print("current: \(FBSDKAccessToken.currentAccessToken().userID)")
            
            self.performSegueWithIdentifier("FriendFBSegue", sender: nil)
            
        }
        
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self //important!
        loginButton.center = self.view.center
        loginButton.readPermissions =  ["user_friends"]
        self.view.addSubview(loginButton)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: - FBSDKLoginButtonDelegate
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error != nil {
            // Process error
            print("error Login")
        }
        else if result.isCancelled {
            // Handle cancellations
            print("isCancelled Login")
        }
        else {
            // Navigate to other view
            print("logIN")
            
            let userObject = PFObject(className: "User")
            userObject["userID"] = result.token.userID
            userObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                
                if error == nil {
                    //print("objectID = \(userObject.objectId)")
                    self.performSegueWithIdentifier("FriendFBSegue", sender: nil)
                } else {
                    
                }
               
                
            }
            
            
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("logOut")
    }

}

