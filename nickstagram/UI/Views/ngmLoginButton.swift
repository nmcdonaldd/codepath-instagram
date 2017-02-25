//
//  ngmLoginButton.swift
//  nickstagram
//
//  Created by Nick McDonald on 2/24/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit

class ngmLoginButton: UIButton {
    
    override var isEnabled: Bool {
        willSet {
            if (newValue) {
                self.alpha = 1.0
            } else {
                self.alpha = 0.65
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Border
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        
        // Text
        self.setTitleColor(UIColor.white, for: .normal)
    }
}
