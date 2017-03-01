//
//  ngmPhotoSectionHeaderLabel.swift
//  nickstagram
//
//  Created by Nick McDonald on 2/28/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit

class ngmPhotoSectionHeaderLabel: UILabel {
    
    override var text: String? {
        didSet {
            self.sizeToFit()
        }
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.textColor = UIColor.white
        self.font = UIFont(name: ngmDefaultFontIdentifier, size: 15.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
