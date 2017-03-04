//
//  ngmAddProfileImageViewController.swift
//  nickstagram
//
//  Created by Nick McDonald on 3/3/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit
import SVProgressHUD

class ngmAddProfileImageViewController: UIViewController {

    @IBOutlet weak var profileImageView: ngmUserProfileImageView!
    private var profileImagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.profileImagePicker = UIImagePickerController()
        self.profileImagePicker.delegate = self
        self.profileImagePicker.allowsEditing = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBarButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBarButtonTapped(_ sender: Any) {
        let currentUser: ngmUser = ngmUser.currentUser!
        currentUser.updateUserProfileImage(image: self.profileImageView.image!, success: {
            //Nothing
        }) { (error: Error?) in
            //code
            SVProgressHUD.showError(withStatus: error?.localizedDescription)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeProfileButtonTapped(_ sender: Any) {
        let actionSheet: UIAlertController = UIAlertController(title: "Change profile image", message: nil, preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (_: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        let cameraAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { (_: UIAlertAction) in
            self.profileImagePicker.sourceType = .camera
            self.profileImagePicker.cameraCaptureMode = .photo
            self.presentImagePicker(withCompletion: nil)
        }
        let photoLibraryAction: UIAlertAction = UIAlertAction(title: "Photo library", style: .default) { (_: UIAlertAction) in
            self.profileImagePicker.sourceType = .photoLibrary
            self.presentImagePicker(withCompletion: nil)
        }
        actionSheet.addAction(cancelAction)
        
        if (self.shouldAddCameraAction()) {
            actionSheet.addAction(cameraAction)
        }
        actionSheet.addAction(photoLibraryAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func presentImagePicker(withCompletion completion: (()->())?) {
        self.present(self.profileImagePicker, animated: true, completion: nil)
    }
    
    private func shouldAddCameraAction() -> Bool {
        return (UIImagePickerController.availableCaptureModes(for: .rear) != nil)
    }
}

extension ngmAddProfileImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Nothing: self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Code to process the image and add it to the view.
        let chosenImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profileImageView.image = chosenImage
        self.dismiss(animated: true, completion: nil)
    }
}
