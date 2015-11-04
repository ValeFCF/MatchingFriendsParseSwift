//
//  FriendFBViewController.swift
//  MatchingFriendsParseSwift
//
//  Created by Emmanuel Valentín Granados López on 04/11/15.
//  Copyright © 2015 DevWorms. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class FriendFBViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addFriend(sender: AnyObject) {
        print("click")
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath)

        // Configure the cell...
        FBSDKGraphRequest.init(graphPath: "me/friends", parameters: [ "fields": "id, name, picture.type(large){url}" ] ).startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if error == nil {
                
                let data = result as! NSDictionary
                let nameFriend = data["data"]![0]["name"] as! String
                let pictureFriend = data["data"]![0]["picture"]!!["data"]!!["url"] as! String
                
                let url = NSURL(string: pictureFriend)
                let picData = NSData(contentsOfURL: url!)
                
                print(nameFriend)
                //print(picData)
                
                let imageViewP = cell.viewWithTag(1) as! UIImageView
                imageViewP.image = UIImage(data: picData!)
                
                let nameFBfriend = cell.viewWithTag(2) as! UILabel
                nameFBfriend.text = nameFriend
                
                let buttonFBfriend = cell.viewWithTag(3) as! UIButton
                buttonFBfriend.setTitle("follow", forState: UIControlState.Normal) //or .Normal
                
            } else {
                print("Error: \(error.localizedDescription)")
            }
            
        })

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
