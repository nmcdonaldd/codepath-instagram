//
//  ngmParseClient.swift
//  nickstagram
//
//  Created by Nick McDonald on 2/24/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit
import Parse

enum ParseClientError: Error {
    case parseUserSaveError(String)
    case postFailedToPost(String)
}

typealias ngmUserResultFailureBlock = (Error?)->()
typealias ngmUserResultSuccessBlock = (PFUser?)->()

class ngmParseClient: NSObject {
    
    // ngmParseClient shared instance.
    static let sharedInstance: ngmParseClient = ngmParseClient()
    private override init() { /* Do nothing. Just want to override. */ }
    
    // Sign up the user with Parse.
    func signUpParseUser(_ user: ngmUser, success: @escaping ()->(), failure: @escaping ngmUserResultFailureBlock) {
        guard let parseUser: PFUser = user.parseUser else {
            failure(ParseClientError.parseUserSaveError("Error, no PFUser in ngmUser"))
            return
        }
        parseUser.signUpInBackground { (didComplete: Bool, error: Error?) in
            if (didComplete) {
                success()
            } else {
                failure(error)
            }
        }
    }
    
    // Login the user with Parse.
    func loginParseUser(_ user: ngmUser, success: @escaping ngmUserResultSuccessBlock, failure: @escaping ngmUserResultFailureBlock) {
        PFUser.logInWithUsername(inBackground: user.username, password: user.password) { (returnedUser: PFUser?, error: Error?) in
            guard returnedUser != nil else {
                failure(error)
                return
            }
            success(returnedUser)
        }
    }
    
    // Post a post objec to Parse.
    func postNewPostingToParse(_ post: ngmPost, success: @escaping ()->(), failure: @escaping (Error?)->()) {
        guard let postObject: PFObject = post.postObject else {
            failure(ParseClientError.postFailedToPost("Post PFObject is nil!"))
            return
        }
        postObject.saveInBackground { (didComplete: Bool, error: Error?) in
            if (didComplete) {
                success()
            } else {
                failure(error)
            }
        }
    }
    
    // Update the user's profile.
    func saveUserToParse(_ user: ngmUser, success: @escaping ()->(), failure: @escaping (Error?)->()) {
        guard let parseUser: PFUser = user.parseUser else {
            failure(ParseClientError.parseUserSaveError("Error, no PFUser in ngmUser."))
            return
        }
        
        parseUser.saveInBackground { (didComplete: Bool, error: Error?) in
            if (didComplete) {
                success()
            } else {
                failure(error)
            }
        }
    }
    
    // Get posts from Parse.
    func getPosts(success: @escaping ([PFObject]?)->(), failure: @escaping (Error?)->()) {
        let query: PFQuery = PFQuery(className: postParseClassNameIdentifier)
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.includeKey("createdAt")
        query.limit = 20
        
        query.findObjectsInBackground { (postObjects: [PFObject]?, error: Error?) in
            guard error == nil else {
                failure(error)
                return
            }
            success(postObjects)
        }
    }
}
