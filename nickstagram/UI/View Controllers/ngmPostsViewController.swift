//
//  ngmPostsViewController.swift
//  nickstagram
//
//  Created by Nick McDonald on 2/25/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit

class ngmPostsViewController: UIViewController {

    @IBOutlet weak var postsTableView: UITableView!
    fileprivate var posts: [ngmPost]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "nickstagram"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ngmPostsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}
