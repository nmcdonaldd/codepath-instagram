//
//  ngmPostTableViewCell.swift
//  nickstagram
//
//  Created by Nick McDonald on 2/26/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ngmPostTableViewCell: UITableViewCell {
    
    var postData: ngmPost? {
        didSet {
            // Load the imageView with the PFFile data.
            self.postImageView.file = self.postData?.imageData
            self.postImageView.loadInBackground()
            
            // Set the caption.
            self.postCaptionLabel.text = self.postData?.caption
        }
    }
    
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var postCaptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
