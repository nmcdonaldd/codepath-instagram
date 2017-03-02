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
            self.loadingImageActivityIndicatorView.isHidden = false
            self.loadingImageActivityIndicatorView.startAnimating()
            
            // Load the imageView with the PFFile data.
            self.postImageView.file = self.postData?.imageData
//            self.postImageView.loadInBackground()
            self.postImageView.load { (image: UIImage?, error: Error?) in
                guard error == nil else {
                    // Error is not nil. Show an error or something.
                    print(error?.localizedDescription)
                    return
                }
                self.loadingImageActivityIndicatorView.stopAnimating()
                self.loadingImageActivityIndicatorView.isHidden = true
            }
            
            // Set the caption.
            self.postCaptionLabel.text = self.postData?.caption
        }
    }
    
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var postCaptionLabel: UILabel!
    @IBOutlet weak var loadingImageActivityIndicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.imageView?.image = UIImage()
    }

}
