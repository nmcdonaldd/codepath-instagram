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
    
    var username: String!
    private(set) var parseUser: PFUser?
    
    init(withUsername username: String, password: String) {
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
    
    func signUpWithParse(success: @escaping ()->(), failure: @escaping ngmUserResultFailureBlock) {
        let parseClient: ngmParseClient = ngmParseClient.sharedInstance
        parseClient.signUpParseUser(self, success: {
            success()
        }) { (error: Error?) in
            failure(error)
        }
    }
}
