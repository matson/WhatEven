//
//  RegisterViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 1/22/24.
//

import Foundation
import UIKit
import Firebase

class RegisterViewController: UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var createLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    
    let firebaseAPI = FirebaseAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and configure the activity indicator
        
        activityIndicator.hidesWhenStopped = true
        
        setAttributes()
        
    }
    
    //Register New User
    @IBAction func register(_ sender: UIButton) {
        
        checkFields()

    }
    
    func registerUser(username: String, email: String, password: String) {
        // Start the activity indicator
        activityIndicator.startAnimating()
        
        firebaseAPI.createUser(withEmail: email, password: password, username: username) { error in
            if let error = error {
                let reason = error.localizedDescription
                self.showErrorAlert(message: reason)
            } else {
                self.performSegue(withIdentifier: Constants.Segue.registerSegue, sender: self)
            }
            // Stop the activity indicator when the process is complete
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    //MARK: -- Alerts
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func checkFields(){
        // Check if any of the required fields are empty
        guard let username = usernameTextField.text, !username.isEmpty else {
            showErrorAlert(message: "Please enter a username")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showErrorAlert(message: "Please enter a password")
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            showErrorAlert(message: "Please enter an email")
            return
        }
        // Check if the email is valid
        if !isValidEmail(email) {
            showErrorAlert(message: "Please enter a valid email address")
            return
        }
        
        // Check if the password is at least 6 characters long
        if password.count < 8 {
            showErrorAlert(message: "Password must be at least 8 characters long")
            return
        }
        
        // All fields are valid, proceed with registration
        registerUser(username: username, email: email, password: password)
        
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // Use regular expression to validate email format
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func setAttributes(){
        view.backgroundColor = Constants.Attributes.styleBlue2
        emailLabel.font = UIFont(name: Constants.Attributes.regularFont, size: 14)
        emailLabel.textColor = .white
        createLabel.textColor = .white
        passwordLabel.textColor = .white
        createLabel.font = UIFont(name: Constants.Attributes.regularFont, size: 14)
        passwordLabel.font = UIFont(name: Constants.Attributes.regularFont, size: 14)
        registerButton.titleLabel!.font = UIFont(name: Constants.Attributes.boldFont, size: 18)
    }
    
    
}
