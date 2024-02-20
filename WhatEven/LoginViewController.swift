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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //Login
    @IBAction func login(_ sender: UIButton) {
        if let email = usernameText.text, let password = passwordText.text {
            Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                if let e = error {
                    let reason = e.localizedDescription
                    self.showErrorAlert(message: reason)
                }else{
                    self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
                }
              
            }
        }
        
    }
    
    //Register
    @IBAction func register(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.toRegisterSegue, sender: self)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

