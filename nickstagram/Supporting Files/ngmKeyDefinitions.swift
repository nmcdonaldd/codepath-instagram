//
//  File.swift
//  nickstagram
//
//  Created by Nick McDonald on 2/25/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit
import SVProgressHUD

let ngmDefaultAppColor: UIColor = .black
let postParseClassNameIdentifier: String = "Post"
let ngmDefaultFontIdentifier: String = "TrebuchetMS"

enum ngmTabBarViewControllers: Int {
    case homeViewController
    case postToParseViewController
    case profileViewController
}

enum UserNotificationCenterOps: String {
    case userDidLogout = "UserDidLogOut"
    
    var notification: Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}
