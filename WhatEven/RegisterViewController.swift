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
    
    //Register New User
    @IBAction func register(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) {
                authResult, error in
                if let e = error {
                    let reason = e.localizedDescription
                    self.showErrorAlert(message: reason)
                    //take care of this later
                }else{
                    //go to homepage.
                    self.performSegue(withIdentifier: Constants.Segue.toRegisterSegue, sender: self)
                }
                
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
