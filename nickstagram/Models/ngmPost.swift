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
    
    var createdAt: Date?
    var formattedCreatedAt: String?
    var caption: String?
    var imageData: PFFile?
    var postAuthor: PFUser?
    var postObject: PFObject?
    
    init?(fromPFObject post: PFObject?) {
        guard let post: PFObject = post else {
            return nil
        }
        self.postAuthor = post["author"] as? PFUser
        self.imageData = post["image_data"] as? PFFile
        self.caption = post["caption"] as? String
        // TODO: - Finish implementing this. Need created at.
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
