//
//  ngmLoginViewController.swift
//  nickstagram
//
//  Created by Nick McDonald on 2/21/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit

class ngmLoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var signUpButton: ngmLoginButton!
    @IBOutlet weak var loginButton: ngmLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set the statusBar color to light.
        UIApplication.shared.statusBarStyle = .lightContent
        
        let color: UIColor = UIColor.lightGray
        self.usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: color])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: color])
        
        // Set the first responder to be the username textField.
        self.usernameTextField.becomeFirstResponder()
        
        // Set delegates.
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.usernameTextField.addTarget(self, action: #selector(ngmLoginViewController.textFieldTextDidChange), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(ngmLoginViewController.textFieldTextDidChange), for: .editingChanged)
        
        // Disable buttons.
        self.loginButton.isEnabled = false
        self.signUpButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        // The button can only be enabled if both of the textFields have text. So we can safely use bang (!) below.
        let usernameText: String = self.usernameTextField.text!
        let passwordText: String = self.passwordTextField.text!
        let userToSignUp: ngmUser = ngmUser(withUsername: usernameText, password: passwordText)
        userToSignUp.signUpWithParse(success: {
            print("User has signed up! Going to log this user in.")
            self.loginWithUser(userToSignUp)
        }) { (error: Error?) in
            self.handleSignUpError(error: error)
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        // The button can only be enabled if both of the textFields have text. So we can safely use bang (!) below.
        let usernameText: String = self.usernameTextField.text!
        let passwordText: String = self.passwordTextField.text!
        let user: ngmUser = ngmUser(withUsername: usernameText, password: passwordText)
        self.loginWithUser(user)
    }
    
    private func loginWithUser(_ user: ngmUser) {
        user.loginWithParse(success: { 
            // Segue or something
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController: ngmHomeTabBarController = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as! ngmHomeTabBarController
            self.modalPresentationStyle = .popover
            self.present(tabBarController, animated: true, completion: nil)
        }) { (error: Error?) in
            self.handleLoginError(error: error)
        }
    }
    
    
    // MARK: - Error handling
    
    private func handleSignUpError(error: Error?) {
        self.showErrorWithTitle("SignUp Error", withMessage: error?.localizedDescription)
    }
    
    private func handleLoginError(error: Error?) {
        self.showErrorWithTitle("Login Error", withMessage: error?.localizedDescription)
    }
    
    private func showErrorWithTitle(_ title: String, withMessage message: String?) {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction: UIAlertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension ngmLoginViewController: UITextFieldDelegate {
    
    private func setLoginButtonsEnabled(_ enabled: Bool, buttons: [ngmLoginButton]) {
        for button in buttons {
            // Only change the isEnabled if they are different than the enabled flag.
            if button.isEnabled != enabled {
                button.isEnabled = enabled
            }
        }
    }
    
    private func allTextFieldsReadyForEnabledButtons() -> Bool {
        let textFields: [UITextField] = [self.passwordTextField, self.usernameTextField]
        for textField in textFields {
            guard textField.text != nil else {
                return false
            }
            if (textField.text!.isEmpty) {
                return false
            }
        }
        return true
    }
    
    @objc fileprivate func textFieldTextDidChange() {
        self.setLoginButtonsEnabled(self.allTextFieldsReadyForEnabledButtons(), buttons: [self.loginButton, self.signUpButton])
    }
}
