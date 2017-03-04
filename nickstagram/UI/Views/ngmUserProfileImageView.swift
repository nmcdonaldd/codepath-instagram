//
//  ngmUserProfileImageView.swift
//  nickstagram
//
//  Created by Nick McDonald on 3/3/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit
import ParseUI

class ngmUserProfileImageView: PFImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.width/2.0
        self.clipsToBounds = true
    }
}
