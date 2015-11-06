//
//  FriendFBViewController.swift
//  MatchingFriendsParseSwift
//
//  Created by Emmanuel Valentín Granados López on 04/11/15.
//  Copyright © 2015 DevWorms. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class FriendFBController: UITableViewController {
    
    var idFriends: [String] = []
    var nameFriends: [String] = []
    var pictureFriends: [String] = []
    var numFriends = 0
    var methodsParse = MyParseMethods()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FBSDKGraphRequest.init(graphPath: "me/friends", parameters: [ "fields": "id, name, picture.type(large){url}" ] ).startWithCompletionHandler({ (connection, results, error) -> Void in
            
            if error == nil {
                
                //print("count= \(results.count)")
                
                if results.count > 0 {
                    
                    let data = results as! NSDictionary
                    
                    for result in 0 ... (results.count - 1) {
                        
                        let idFriend = data["data"]![ result ]["id"] as! String
                        let nameFriend = data["data"]![ result ]["name"] as! String
                        let pictureFriend = data["data"]![ result ]["picture"]!!["data"]!!["url"] as! String
                        
                        //print(idFriend)
                        //print(nameFriend)
                        //print(picData)
                        
                        self.idFriends.append( idFriend )
                        self.nameFriends.append( nameFriend )
                        self.pictureFriends.append( pictureFriend )
                        
                    }
                }
                
                self.numFriends = self.idFriends.count
                
                self.tableView.reloadData()
                
            } else {
                print("Error: \(error.localizedDescription)")
            }
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addFriend(sender: MyButtonID) {
        
        print(sender.titleLabel!.text)
        print( sender.idFriendFB )
        
        if sender.titleLabel!.text == "follow" {

            self.methodsParse.updatingRequestFriends( sender.idFriendFB )
    
            sender.setTitle("pending", forState: UIControlState.Normal) //or .Normal
            
        } else {
            
            self.methodsParse.deletingIDFriends( sender.idFriendFB, kindDeleting: sender.titleLabel!.text! )
            
            sender.setTitle("follow", forState: UIControlState.Normal)
            
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.idFriends.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath)
        
        // Configure the cell...
        
        let url = NSURL(string: self.pictureFriends[ indexPath.row ] )
        let picData = NSData(contentsOfURL: url!)
        
        let imageViewP = cell.viewWithTag(1) as! UIImageView
        imageViewP.image = UIImage(data: picData!)
        
        let nameFBfriend = cell.viewWithTag(2) as! UILabel
        nameFBfriend.text = self.nameFriends[ indexPath.row ]
        
        let buttonFBfriend = cell.viewWithTag(3) as! MyButtonID
        
        
        //Completion Handler
        self.methodsParse.buttonsOfFriendsFollow( self.idFriends[ indexPath.row ] , completion: { (resultButton) -> Void in
            
            if resultButton == true {
                print("not working")
                buttonFBfriend.setTitle("unfollow", forState: UIControlState.Normal)
            }else {
                print("working")
                buttonFBfriend.setTitle("follow", forState: UIControlState.Normal)
            }
            
        })

        
        buttonFBfriend.idFriendFB = self.idFriends[ indexPath.row ]
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
