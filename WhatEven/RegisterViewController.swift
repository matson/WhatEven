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
    //comment here to commit test
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func register(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) {
                authResult, error in
                if let e = error {
                    print(error)
                    //take care of this later
                }else{
                    //go to homepage.
                    
                }
                
            }
        }
        
        
    }
    
}
