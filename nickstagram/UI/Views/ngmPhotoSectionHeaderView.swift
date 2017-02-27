//
//  ngmPhotoSectionHeaderView.swift
//  nickstagram
//
//  Created by Nick McDonald on 2/25/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit

class ngmPhotoSectionHeaderView: UIView {
    
    @IBOutlet var sectionHeaderContentView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    var postData: ngmPost? {
        didSet {
            self.usernameLabel.text = postData?.postAuthor?.username
            self.createdAtLabel.text = "Just now"
        }
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        let subView: UIView = self.loadSubviews()
        subView.frame = self.bounds
        self.addSubview(subView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let subView: UIView = self.loadSubviews()
        subView.frame = self.bounds
        self.addSubview(subView)
    }
    
    private func loadSubviews() -> UIView {
        let view: UIView = UINib(nibName: "ngmPhotoSectionHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
