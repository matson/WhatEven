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
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setAttributes()
       
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
    
    func setAttributes(){
        
        let buttonFont = UIFont(name: Constants.Attributes.regularFont, size: 14)
        let buttonColor = UIColor.white
        
        usernameLabel.font = UIFont(name: Constants.Attributes.boldFont, size: 14)
        passwordLabel.font = UIFont(name: Constants.Attributes.boldFont, size: 14)
        titleLabel.font = UIFont(name: Constants.Attributes.boldFont, size: 35)
        
        view.backgroundColor = Constants.Attributes.styleBlue1

        loginButton.titleLabel?.font = buttonFont
        loginButton.setTitleColor(buttonColor, for: .normal)
        loginButton.setTitleColor(buttonColor, for: .highlighted)
        loginButton.setTitleColor(buttonColor, for: .disabled)
        loginButton.setTitleColor(buttonColor, for: .selected)

        registerButton.titleLabel?.font = buttonFont
        registerButton.setTitleColor(buttonColor, for: .normal)
        registerButton.setTitleColor(buttonColor, for: .highlighted)
        registerButton.setTitleColor(buttonColor, for: .disabled)
        registerButton.setTitleColor(buttonColor, for: .selected)
    }
}

