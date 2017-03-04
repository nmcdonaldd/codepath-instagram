//
//  ngmUser.swift
//  nickstagram
//
//  Created by Nick McDonald on 2/24/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit
import Parse

class ngmUser: NSObject {
    
    private static let userProfileImageDataIdentifier: String = "user_profile_image_data"
    
    var username: String!
    var password: String!
    
    private(set) var userProfileImage: PFFile?
    private(set) var parseUser: PFUser?
    
    init(withUsername username: String, password: String) {
        self.username = username
        self.password = password
        let user: PFUser = PFUser()
        user.username = username
        user.password = password
        self.parseUser = user
    }
    
    init?(withPFUser user: PFUser?) {
        guard let user = user, let username: String = user.username else {
            return nil
        }
        
        self.username = username
        self.parseUser = user
    }
    
    func updateUserProfileImage(image: UIImage, success: @escaping ()->(), failure: @escaping (Error?)->()) {
        
        guard let imageData: Data = UIImagePNGRepresentation(image) else {
            return
        }
        
        self.userProfileImage = PFFile(name: "image.png", data: imageData)
        self.parseUser?[ngmUser.userProfileImageDataIdentifier] = self.userProfileImage
        let parseClient: ngmParseClient = ngmParseClient.sharedInstance
        parseClient.saveUserToParse(self, success: { 
            success()
        }) { (error: Error?) in
            failure(error)
        }
        ngmUser.currentUser = self
    }
    
    func signUpWithParse(success: @escaping ()->(), failure: @escaping ngmUserResultFailureBlock) {
        let parseClient: ngmParseClient = ngmParseClient.sharedInstance
        parseClient.signUpParseUser(self, success: {
            success()
        }) { (error: Error?) in
            failure(error)
        }
    }
    
    func loginWithParse(success: @escaping ()->(), failure: @escaping ngmUserResultFailureBlock) {
        let parseClient: ngmParseClient = ngmParseClient.sharedInstance
        parseClient.loginParseUser(self, success: { (user: PFUser?) in
            guard user != nil else {
                failure(ParseClientError.parseUserSaveError("Error with user returned from network"))
                return
            }
            ngmUser.currentUser = ngmUser(withPFUser: PFUser.current())
            success()
        }) { (error: Error?) in
            failure(error)
        }
    }
    
    class func logoutCurrentUser() {
        PFUser.logOut()
        NotificationCenter.default.post(name: UserNotificationCenterOps.userDidLogout.notification, object: nil)
    }
    
    
    // MARK: - currentUser
    
    static private var _currentUser: ngmUser?
    
    class var currentUser: ngmUser? {
        get {
            if _currentUser == nil {
                _currentUser = ngmUser(withPFUser: PFUser.current())
            }
            return _currentUser
        }
        set {
            _currentUser = newValue
        }
    }
}
