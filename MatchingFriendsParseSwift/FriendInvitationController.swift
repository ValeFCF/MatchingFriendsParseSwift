//
//  FriendInvitationController.swift
//  MatchingFriendsParseSwift
//
//  Created by Emmanuel Valentín Granados López on 06/11/15.
//  Copyright © 2015 DevWorms. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class FriendInvitationController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var myTableView: UITableView!
    var idFriends:[String] = []
    var nameFriends:[String] = []
    var pictureFriends:[String] = []
    var numOfInvites = 0
    var methodsParse = MyParseMethods()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Completion Handler
        self.methodsParse.getFriends { (resultArray) -> Void in
            
            if resultArray.count == 0 {
                print( "no invites" )
            }else {
                
                for i in 0 ... (resultArray.count - 1){
                    
                    FBSDKGraphRequest.init(graphPath: resultArray[i] , parameters: [ "fields": "name, picture.type(large){url}" ] ).startWithCompletionHandler({ (connection, result, error) -> Void in
                        
                        let data = result as! NSDictionary
                        let idFriend = data["id"] as! String
                        let nameFriend = data["name"] as! String
                        let pictureFriend = data["picture"]!["data"]!!["url"] as! String
                        
                        //print(idFriend)
                        print(nameFriend)
                        //print(picData)
                        
                        self.idFriends.append( idFriend )
                        self.nameFriends.append( nameFriend )
                        self.pictureFriends.append( pictureFriend )
                        
                        if i == (resultArray.count - 1){
                            
                            print( resultArray )
                            self.numOfInvites = self.idFriends.count
                            self.myTableView.reloadData()
                        }
                        
                    })
                    
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptFriend(sender: MyButtonID) {
        
        print( sender.idFriendFB )
        
    }
    
    @IBAction func refuseFriend(sender: MyButtonID) {
        
        print( sender.idFriendFB )
        
    }
    
    //Mark: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numOfInvites
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendInviteCell", forIndexPath: indexPath)
        
        // Configure the cell...
        
        let url = NSURL(string: self.pictureFriends[ indexPath.row ] )
        let picData = NSData(contentsOfURL: url!)
        
        let imageViewP = cell.viewWithTag(1) as! UIImageView
        imageViewP.image = UIImage(data: picData!)
        
        let nameFBfriend = cell.viewWithTag(2) as! UILabel
        nameFBfriend.text = self.nameFriends[ indexPath.row ]
        
        let buttonAccept = cell.viewWithTag(3) as! MyButtonID
        buttonAccept.idFriendFB = self.idFriends[ indexPath.row ]
        
        let buttonRefuse = cell.viewWithTag(4) as! MyButtonID
        buttonRefuse.idFriendFB = self.idFriends[ indexPath.row ]
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
