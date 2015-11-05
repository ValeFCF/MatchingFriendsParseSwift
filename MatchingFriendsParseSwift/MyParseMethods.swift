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
    func buttonsOfFriendsFollow( objectSearch: String, completion: (resultButton: Bool) -> Void){
        
        let query = PFQuery(className:"User")
        query.whereKey("userID", equalTo: FBSDKAccessToken.currentAccessToken().userID )
        query.whereKey("idFriendsFB", containedIn: [ objectSearch ])
        query.getFirstObjectInBackgroundWithBlock({ (userObject: PFObject?, error: NSError?) -> Void in
            
            if error != nil {
                print("errorrrrr == \(error?.localizedDescription)")
                completion( resultButton: false)
            }else {
                //print(userObject)
                completion(resultButton: true)
            }
        })

    }
    
    func updatingIDFriends( objectUpdating: String ) {
        
        let query = PFQuery(className:"User")
        query.whereKey("userID", equalTo: FBSDKAccessToken.currentAccessToken().userID )
        query.getFirstObjectInBackgroundWithBlock({ (userObject: PFObject?, error: NSError?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            } else if let userObject = userObject {
                
                userObject.addObject( objectUpdating , forKey: "idFriendsFB")
                userObject.saveInBackground()
            }
            
        })
    }
    
    func deletingIDFriends( objectDeleting: String ){
        
        let query = PFQuery(className:"User")
        query.whereKey("userID", equalTo: FBSDKAccessToken.currentAccessToken().userID )
        query.getFirstObjectInBackgroundWithBlock({ (userObject: PFObject?, error: NSError?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            } else if let userObject = userObject {
                
                userObject.removeObject( objectDeleting , forKey: "idFriendsFB")
                userObject.saveInBackground()
            }
            
        })
    }
    
    
    //
    
    
    
    
}