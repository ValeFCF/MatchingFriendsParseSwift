//
//  MyParseMethods.swift
//  MatchingFriendsParseSwift
//
//  Created by Emmanuel Valentín Granados López on 05/11/15.
//  Copyright © 2015 DevWorms. All rights reserved.
//

import Parse
import FBSDKCoreKit

class MyParseMethods {

    //completionHandler
    func buttonsOfFriendsFollow( objectSearch: String, completion: (resultButton: Int) -> Void){
        
        // where 1 = follow, 2 = pending, 3 = unfollow
        
        let query = PFQuery(className:"User")
        query.whereKey("userID", equalTo: FBSDKAccessToken.currentAccessToken().userID )
        query.whereKey("idFriendsFB", containedIn: [ objectSearch ])
        query.getFirstObjectInBackgroundWithBlock({ (userObject: PFObject?, error: NSError?) -> Void in
            
            if error != nil {
                print("error  == \(error?.localizedDescription)")
                
                let queryRequest = PFQuery(className:"User")
                queryRequest.whereKey("userID", equalTo: FBSDKAccessToken.currentAccessToken().userID )
                queryRequest.whereKey("requestFriend", containedIn: [ objectSearch ])
                queryRequest.getFirstObjectInBackgroundWithBlock({ (uObject: PFObject?, error: NSError?) -> Void in
                    
                    if error != nil {
                        completion( resultButton: 1)
                    }else {
                        
                        completion( resultButton: 2)
                    }
                    
                })
                
            }else {
                print(userObject)
                completion(resultButton: 3)
            }
        })

    }
    
    func updatingRequestFriends( objectUpdating: String ) {
        
        let query = PFQuery(className:"User")
        
        // query add request to friend
        query.whereKey("userID", equalTo: FBSDKAccessToken.currentAccessToken().userID )
        query.getFirstObjectInBackgroundWithBlock({ (userObject: PFObject?, error: NSError?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            } else if let userObject = userObject {
                
                userObject.addObject( objectUpdating , forKey: "requestFriend")
                userObject.saveInBackgroundWithBlock({ (result: Bool, error: NSError?) -> Void in
                    
                    if error != nil {
                        print("error RequestFriend == \(error?.localizedDescription)")
                    }else {
                        
                        // query add invite from friend
                        query.whereKey("userID", equalTo: objectUpdating )
                        query.getFirstObjectInBackgroundWithBlock({ (friendObject: PFObject?, error: NSError?) -> Void in
                            
                            if error != nil {
                                print(error?.localizedDescription)
                            }else {
                                
                                friendObject!.addObject(FBSDKAccessToken.currentAccessToken().userID, forKey: "inviteFriend")
                                friendObject!.saveInBackground()
                                // we can separate the method
                            }
                            
                        })
                    }
                    
                })
                
            }
            
        })
    }
    
    func deletingIDFriends( objectDeleting: String, kindDeleting: String ){
        
        let query = PFQuery(className:"User")
        query.whereKey("userID", equalTo: FBSDKAccessToken.currentAccessToken().userID )
        query.getFirstObjectInBackgroundWithBlock({ (userObject: PFObject?, error: NSError?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            } else if let userObject = userObject {
                
                if kindDeleting == "unfollow" {
                    userObject.removeObject( objectDeleting , forKey: "idFriendsFB")
                }else {
                    userObject.removeObject( objectDeleting , forKey: "requestFriend")
                    //code user2
                }
                
                userObject.saveInBackground()
            }
            
        })
    }
    
    
    //
    
    
    
    
}