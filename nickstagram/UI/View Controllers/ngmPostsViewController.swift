//
//  ngmPostsViewController.swift
//  nickstagram
//
//  Created by Nick McDonald on 2/25/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit
import SVProgressHUD

class ngmPostsViewController: UIViewController {

    @IBOutlet weak var postsTableView: UITableView!
    fileprivate var posts: [ngmPost]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "nickstagram"
        
        self.postsTableView.delegate = self
        self.postsTableView.dataSource = self
        
        // TableView height.
        self.postsTableView.rowHeight = UITableViewAutomaticDimension
        self.postsTableView.estimatedRowHeight = 435
        
        // Load posts.
        self.loadPosts()
    }
    
    func loadPosts() {
        ngmPost.getPosts(success: { (posts: [ngmPost]) in
            // Code
            self.posts = posts
            self.postsTableView.reloadData()
        }) { (error: Error?) in
            SVProgressHUD.showError(withStatus: error?.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ngmPostsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ngmPostTableViewCell = self.postsTableView.dequeueReusableCell(withIdentifier: "postTableViewCell", for: indexPath) as! ngmPostTableViewCell
        
        cell.postData = self.posts![indexPath.section]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    private func generateHeaderLabel() -> UILabel {
        let label: ngmPhotoSectionHeaderLabel = ngmPhotoSectionHeaderLabel()
        return label
    }
    
    // TODO: - Fix this. This code is very ugly. Try to move to a XIB file?
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerViewHeight: CGFloat = 40
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerViewHeight))
        headerView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = headerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerView.addSubview(blurEffectView)
        
        let usernameLabel: UILabel = self.generateHeaderLabel()
        usernameLabel.text = self.posts![section].postAuthor!.username
        let usernameFrame: CGRect = CGRect(x: 8, y: 8, width: usernameLabel.frame.size.width, height: 18)
        usernameLabel.frame = usernameFrame
        headerView.addSubview(usernameLabel)
        
        let createdAtLabel: UILabel = self.generateHeaderLabel()
        createdAtLabel.text = self.posts![section].formattedCreatedAt
        let createdAtFrame: CGRect = CGRect(x: (UIScreen.main.bounds.width - 8) - createdAtLabel.frame.size.width, y: 8, width: createdAtLabel.frame.size.width, height: 18)
        createdAtLabel.frame = createdAtFrame
        headerView.addSubview(createdAtLabel)
        
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
