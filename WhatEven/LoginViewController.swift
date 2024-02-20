//
//  ViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 1/22/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: UIButton) {
        
    }
    
    @IBAction func register(_ sender: UIButton) {
        performSegue(withIdentifier: "ToRegister", sender: self)
    }
}

