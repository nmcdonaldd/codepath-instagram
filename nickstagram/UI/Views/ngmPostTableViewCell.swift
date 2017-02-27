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
            self.imageLoadingActivityView.startAnimating()
            self.postImageView.load(inBackground: { (image: UIImage?, error: Error?) in
                guard error == nil else {
                    print("Error!")
                    return
                }
                self.imageLoadingActivityView.stopAnimating()
                self.imageLoadingActivityView.isHidden = true
            }) { (progress: Int32) in
            }
            
            // Set the caption.
            self.postCaptionLabel.text = self.postData?.caption
        }
    }
    
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var postCaptionLabel: UILabel!
    @IBOutlet weak var imageLoadingActivityView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageLoadingActivityView.isHidden = false
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
//        self.postImageView.layer.cornerRadius = 8
//        self.postImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.postImageView.image = nil
    }

}
