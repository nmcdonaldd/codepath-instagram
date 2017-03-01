//
//  ngmProfileViewController.swift
//  nickstagram
//
//  Created by Nick McDonald on 2/26/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit

class ngmProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = ngmUser.currentUser?.username
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutButtonPressed(_ sender: Any) {
        ngmUser.logoutCurrentUser()
    }
}
