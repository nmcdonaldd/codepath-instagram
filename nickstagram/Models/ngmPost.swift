//
//  ngmPost.swift
//  nickstagram
//
//  Created by Nick McDonald on 2/25/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit
import Parse
import SwiftDate

private enum ngmPostsError: Error {
    case postsFailedToLoadError(String)
}

class ngmPost: NSObject {
    
    private static let authorIdentifier: String = "author"
    private static let imageDataIdentifier: String = "image_data"
    private static let captionIdentifier: String = "caption"
    
    private(set) var createdAt: Date?
    private(set) var formattedCreatedAt: String?
    private(set) var caption: String?
    private(set) var imageData: PFFile?
    private(set) var postAuthor: ngmUser?
    private(set) var postObject: PFObject?
    
    init?(fromPFObject post: PFObject?) {
        guard let post: PFObject = post else {
            return nil
        }
        self.postAuthor = ngmUser(withPFUser: post[ngmPost.authorIdentifier] as? PFUser)
        self.imageData = post[ngmPost.imageDataIdentifier] as? PFFile
        self.caption = post[ngmPost.captionIdentifier] as? String
        self.createdAt = post.createdAt
        
        // Get a formatted date.
        let date = DateInRegion(absoluteDate: self.createdAt!)
        let (colloquial, _): (String, String?) = try! date.colloquialSinceNow()
        self.formattedCreatedAt = colloquial
    }
    
    init?(withImage image: UIImage, withCaption caption: String) {
        self.postAuthor = ngmUser(withPFUser: PFUser.current())
        guard let imageData: Data = UIImagePNGRepresentation(image) else {
            return nil
        }
        self.imageData = PFFile(name: "image.png", data: imageData)
        self.caption = caption
        self.postObject = PFObject(className: postParseClassNameIdentifier)
        self.postObject?[ngmPost.authorIdentifier] = self.postAuthor?.parseUser
        self.postObject?[ngmPost.imageDataIdentifier] = self.imageData
        self.postObject?[ngmPost.captionIdentifier] = self.caption
    }
    
    // Return an array of ngmPosts from an array of PFObject posts.
    class func postsFromObjects(_ objects: [PFObject?]) -> [ngmPost] {
        var postArray: [ngmPost] = [ngmPost]()
        
        for postObject in objects {
            guard let post: ngmPost = ngmPost(fromPFObject: postObject) else {
                continue
            }
            postArray.append(post)
        }
        return postArray
    }
    
    // Post this object to Parse.
    func postToParse(success: @escaping ()->(), failure: @escaping (Error?)->()) {
        let parseClient: ngmParseClient = ngmParseClient.sharedInstance
        parseClient.postNewPostingToParse(self, success: { 
            success()
        }) { (error: Error?) in
            failure(error)
        }
    }
    
    // Make the network call to grab the posts.
    class func getPosts(success: @escaping ([ngmPost])->(), failure: @escaping (Error?)->()) {
        let parseClient: ngmParseClient = ngmParseClient.sharedInstance
        parseClient.getPosts(success: { (postObjects: [PFObject]?) in
            guard let postObjects: [PFObject] = postObjects else {
                failure(ngmPostsError.postsFailedToLoadError("Posts PFObjects came back nil"))
                return
            }
            let posts: [ngmPost] = ngmPost.postsFromObjects(postObjects)
            success(posts)
        }) { (error: Error?) in
            failure(error)
        }
    }
}
