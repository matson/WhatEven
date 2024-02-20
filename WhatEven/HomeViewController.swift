//
//  HomeViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 1/22/24.
//

import Foundation
import UIKit
import Firebase

//after user signs in, or registers will be shown this main screen.

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "WhatEven"
        //to hide back button
        navigationItem.hidesBackButton = true
    }
    
    
    //to logout
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        do {
          try Auth.auth().signOut()
        //if successful...go back to Login
            navigationController?.popToRootViewController(animated: true)

        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    
}
