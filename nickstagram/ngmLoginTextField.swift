//
//  ngmLoginTextField.swift
//  nickstagram
//
//  Created by Nick McDonald on 2/24/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit

class ngmLoginTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Border
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
}
