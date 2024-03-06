//
//  ViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 1/22/24.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var login: UIButton!
    
    @IBOutlet weak var register: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        usernameLabel.font = UIFont(name: "PTSans-Bold", size: 14)
        passwordLabel.font = UIFont(name: "PTSans-Bold", size: 14)
        titleLabel.font = UIFont(name: "PTSans-Regular", size: 26)
        
        // Create and configure the activity indicator
        activityIndicator.hidesWhenStopped = true
        
    }
    
    //Login
    @IBAction func login(_ sender: UIButton) {
        // Start the activity indicator
        activityIndicator.startAnimating()
        
        if let email = usernameText.text, let password = passwordText.text {
            Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                if let e = error {
                    let reason = e.localizedDescription
                    self.showErrorAlert(message: reason)
                }else{
                    self.performSegue(withIdentifier: Constants.Segue.loginSegue, sender: self)
                }
                // Stop the activity indicator when the process is complete
                self.activityIndicator.stopAnimating()
                
            }
        }
        
    }
    
    //Register
    @IBAction func register(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Segue.toRegisterSegue, sender: self)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

