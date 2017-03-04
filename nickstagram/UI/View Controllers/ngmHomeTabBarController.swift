//
//  ngmHomeTabBarController.swift
//  nickstagram
//
//  Created by Nick McDonald on 2/25/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit

class ngmHomeTabBarController: UITabBarController {
    
    private var didInitiallyPresentAddProfileViewController: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.barTintColor = ngmDefaultAppColor
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .lightGray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (ngmUser.currentUser?.userProfileImage == nil && didInitiallyPresentAddProfileViewController == false) {
            // Want to show the screen to allow the user to add a profile image.
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let addProfileImageNavigationController: ngmBaseNavigationController = storyboard.instantiateViewController(withIdentifier: "addProfileImageNavigationController") as! ngmBaseNavigationController
            self.modalPresentationStyle = .popover
            self.present(addProfileImageNavigationController, animated: true, completion: {
                self.didInitiallyPresentAddProfileViewController = true
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
