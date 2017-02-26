//
//  ngmBaseNavigationController.swift
//  nickstagram
//
//  Created by Nick McDonald on 2/25/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit

class ngmBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.barTintColor = ngmDefaultAppColor
        self.navigationBar.isTranslucent = true
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: "TrebuchetMS-Bold", size: 18)!]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
