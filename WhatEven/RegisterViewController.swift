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
    
    let firebaseAPI = FirebaseAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and configure the activity indicator

        activityIndicator.hidesWhenStopped = true
        
        
    }
    
    //Register New User
    @IBAction func register(_ sender: UIButton) {
        // Start the activity indicator
        activityIndicator.startAnimating()
        
        if let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text {
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
        
        
        
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}
