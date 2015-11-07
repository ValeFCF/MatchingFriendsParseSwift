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
    
    func updatingRequestFriends( objectUpdating: String ) {
        
        // query add request to friend
        let query = PFQuery(className:"User")
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
                        let queryInvite = PFQuery(className:"User")
                        queryInvite.whereKey("userID", equalTo: objectUpdating )
                        queryInvite.getFirstObjectInBackgroundWithBlock({ (friendObject: PFObject?, error: NSError?) -> Void in
                            
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
    
    func acceptFriend(objectAccept: String) {
    
        // query add friend 2
        let query = PFQuery(className:"User")
        query.whereKey("userID", equalTo: FBSDKAccessToken.currentAccessToken().userID )
        query.getFirstObjectInBackgroundWithBlock({ (userObject: PFObject?, error: NSError?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            } else if let userObject = userObject {
                
                userObject.addObject( objectAccept , forKey: "idFriendsFB")
                userObject.removeObject( objectAccept , forKey: "inviteFriend")
                userObject.saveInBackgroundWithBlock({ (result: Bool, error: NSError?) -> Void in
                    
                    if error != nil {
                        print("error RequestFriend == \(error?.localizedDescription)")
                    }else {
                        
                        // query add friend 1
                        let queryAdd = PFQuery(className:"User")
                        queryAdd.whereKey("userID", equalTo: objectAccept )
                        queryAdd.getFirstObjectInBackgroundWithBlock({ (friendObject: PFObject?, error: NSError?) -> Void in
                            
                            if error != nil {
                                print(error?.localizedDescription)
                            }else {
                                
                                friendObject!.addObject(FBSDKAccessToken.currentAccessToken().userID, forKey: "idFriendsFB")
                                friendObject!.removeObject(FBSDKAccessToken.currentAccessToken().userID, forKey: "requestFriend")
                                friendObject!.saveInBackground()
                                // we can separate the method
                            }
                            
                        })
                    }
                    
                })
                
            }
            
        })

    }
    
    func refuseFriend(objectRefuse: String) {
    
        // query refuse friend 2
        let query = PFQuery(className:"User")
        query.whereKey("userID", equalTo: FBSDKAccessToken.currentAccessToken().userID )
        query.getFirstObjectInBackgroundWithBlock({ (userObject: PFObject?, error: NSError?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            } else if let userObject = userObject {
                
                userObject.removeObject( objectRefuse , forKey: "inviteFriend")
                userObject.saveInBackgroundWithBlock({ (result: Bool, error: NSError?) -> Void in
                    
                    if error != nil {
                        print("error RequestFriend == \(error?.localizedDescription)")
                    }else {
                        
                        // query refuse friend 1
                        let queryAdd = PFQuery(className:"User")
                        queryAdd.whereKey("userID", equalTo: objectRefuse )
                        queryAdd.getFirstObjectInBackgroundWithBlock({ (friendObject: PFObject?, error: NSError?) -> Void in
                            
                            if error != nil {
                                print(error?.localizedDescription)
                            }else {
                                
                                friendObject!.removeObject(FBSDKAccessToken.currentAccessToken().userID, forKey: "requestFriend")
                                friendObject!.saveInBackground()
                                // we can separate the method
                            }
                            
                        })
                    }
                    
                })
                
            }
            
        })

    }
    
    //MARK: - Completion Handler
    
    func buttonsOfFriendsFollow( objectSearch: String, completion: (resultButton: Int) -> Void) {
        
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
    
    func getFriends( completion: (resultArray: [String]) -> Void) {
        
        var friendInvitations: [String] = []
        
        let query = PFQuery(className:"User")
        query.whereKey("userID", equalTo: FBSDKAccessToken.currentAccessToken().userID )
        query.getFirstObjectInBackgroundWithBlock { (userObject: PFObject?, error: NSError?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            }else {
                
                friendInvitations = userObject!["inviteFriend"] as! [String]
                
                completion(resultArray: friendInvitations)
            }
        }
        
    }

    
    //
    
    
    
    
}