//
//  ngmPostPhotoViewController.swift
//  nickstagram
//
//  Created by Nick McDonald on 2/26/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit
import ParseUI
import SVProgressHUD

class ngmPostPhotoViewController: UIViewController {
    
    fileprivate static let captionPlaceholderText: String = "Caption..."
    private var imagePicker: UIImagePickerController!

    @IBOutlet weak var postPhotobarButtonItem: UIBarButtonItem!
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var noImageYetContentView: UIView!
    @IBOutlet weak var tapToAddImageLabel: UILabel!
    @IBOutlet weak var photoCaptionTextView: ngmPhotoCaptionTextView!
    @IBOutlet weak var captionTextViewHeightConstraint: NSLayoutConstraint!
    fileprivate var defaultCaptionTextViewHeightConstraint: CGFloat!
    fileprivate var currentTextViewContentHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "New Post"
        self.postPhotobarButtonItem.isEnabled = false
        
        // Hide the imageView since we want the text to show up first.
        self.postImageView.isHidden = true
        
        // Set the textView delegate.
        self.photoCaptionTextView.delegate = self
        self.photoCaptionTextView.text = ngmPostPhotoViewController.captionPlaceholderText
        self.photoCaptionTextView.textColor = UIColor.lightGray
        self.defaultCaptionTextViewHeightConstraint = self.captionTextViewHeightConstraint.constant
        self.photoCaptionTextView.tintColor = .white
        
        // Tap recognizer for adding a new photo.
        let addPhotoTapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ngmPostPhotoViewController.userTappedToAddPhoto))
        self.noImageYetContentView.addGestureRecognizer(addPhotoTapRecognizer)
        
        let changePhotoTapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ngmPostPhotoViewController.userTappedImageView))
        self.postImageView.addGestureRecognizer(changePhotoTapRecognizer)
        self.postImageView.isUserInteractionEnabled = true
        
        // Set the imagePickerController.
        self.imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        // First show the progress HUD.
        SVProgressHUD.show()
        
        // Need image and caption.
        let imageToPost: UIImage = self.resizeImage(self.postImageView.image!, newSize: CGSize(width: 2048, height: 2048))
        let caption: String = self.photoCaptionTextView.text
        guard let post: ngmPost = ngmPost(withImage: imageToPost, withCaption: caption) else {
            // Show some error.
            return
        }
        self.photoCaptionTextView.endEditing(true)
        post.postToParse(success: {
            // Now need to quit the progress HUD and bring us to the homeVC.
            let homeViewController: ngmPostsViewController = (self.tabBarController?.viewControllers![ngmTabBarViewControllers.homeViewController.rawValue] as! ngmBaseNavigationController).topViewController as! ngmPostsViewController
            homeViewController.loadPosts()
            SVProgressHUD.dismiss()
            self.tabBarController!.selectedIndex = ngmTabBarViewControllers.homeViewController.rawValue
            self.resetViewsToDefault()
        }) { (error: Error?) in
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: error?.localizedDescription)
        }
    }
    
    private func resetViewsToDefault() {
        self.postImageView.isHidden = true
        self.noImageYetContentView.isHidden = false
        self.photoCaptionTextView.text = ""
        self.postImageView.image = nil
        self.postPhotobarButtonItem.isEnabled = false
    }
    
    private func resizeImage(_ image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = .scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    @objc private func userTappedToAddPhoto() {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    @objc private func userTappedImageView() {
        // Don't need to do anything. Only want to add action if the user wants to change photos.
        guard postImageView.image != nil else {
            return
        }
        
        let alertController: UIAlertController = UIAlertController(title: "Change/Remove photo", message: nil, preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        let removePhotoAction: UIAlertAction = UIAlertAction(title: "Remove Photo", style: .destructive) { (action: UIAlertAction) in
            self.resetViewsToDefault()
        }
        let changePhotoAction: UIAlertAction = UIAlertAction(title: "Change Photo", style: .default) { (action: UIAlertAction) in
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(changePhotoAction)
        alertController.addAction(removePhotoAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ngmPostPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.postImageView.image = chosenImage
        self.postImageView.contentMode = .scaleAspectFill
        self.postImageView.isHidden = false
        self.noImageYetContentView.isHidden = true
        
        // Determine whether or not we should enable the post button.
        if (!self.photoCaptionTextView.text.isEmpty) {
            if (self.photoCaptionTextView.textColor == UIColor.lightGray) {
                self.postPhotobarButtonItem.isEnabled = false
            } else {
                self.postPhotobarButtonItem.isEnabled = true
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ngmPostPhotoViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    private func updateSendContainerViewHeightConstraintWithValue(_ value: CGFloat) {
        self.captionTextViewHeightConstraint.constant = value
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let height: CGFloat = textView.contentSize.height
        if height != self.currentTextViewContentHeight {
            let newHeight = self.captionTextViewHeightConstraint.constant + ((self.currentTextViewContentHeight == 0) ? 0 : height - self.currentTextViewContentHeight)
            self.updateSendContainerViewHeightConstraintWithValue(newHeight)
            self.currentTextViewContentHeight = height
        }
        self.postPhotobarButtonItem.isEnabled = !textView.text.isEmpty && self.postImageView.image != nil
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = ngmPostPhotoViewController.captionPlaceholderText
            textView.textColor = UIColor.lightGray
        }
    }
}
