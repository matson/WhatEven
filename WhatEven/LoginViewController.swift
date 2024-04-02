//
//  ViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 1/22/24.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    //to replace storyboard:
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "WhatEven!"
        label.font = UIFont(name: Constants.Attributes.boldFont, size: 35)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont(name: Constants.Attributes.boldFont, size: 15)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "password"
        label.font = UIFont(name: Constants.Attributes.boldFont, size: 15)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let usernameField: UITextField = {
        let field = UITextField()
        field.font = UIFont(name: Constants.Attributes.regularFont, size: 15)
        field.backgroundColor = .white
        field.placeholder = "username"
        field.layer.cornerRadius = 5
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.font = UIFont(name: Constants.Attributes.regularFont, size: 15)
        field.backgroundColor = .white
        field.placeholder = "password"
        field.layer.cornerRadius = 5
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        //may have to add this outside of function 
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.setTitle("login", for: .normal)
        let buttonFont = UIFont(name: Constants.Attributes.regularFont, size: 25)
        let buttonColor = UIColor.white
        button.titleLabel?.font = buttonFont
        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonColor, for: .highlighted)
        button.setTitleColor(buttonColor, for: .disabled)
        button.setTitleColor(buttonColor, for: .selected)
        return button
        
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("register", for: .normal)
        let buttonFont = UIFont(name: Constants.Attributes.regularFont, size: 25)
        let buttonColor = UIColor.white
        button.titleLabel?.font = buttonFont
        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonColor, for: .highlighted)
        button.setTitleColor(buttonColor, for: .disabled)
        button.setTitleColor(buttonColor, for: .selected)
        return button
        
    }()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = Constants.Attributes.styleBlue1
        
        view.addSubview(titleLabel)
        view.addSubview(usernameLabel)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(passwordLabel)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        
        
        
        setAttributes()
       
        // Create and configure the activity indicator
        //activityIndicator.hidesWhenStopped = true
        
    }
    
    //Login
    @objc func loginButtonTapped() {
        // Start the activity indicator
        activityIndicator.startAnimating()
        
        if let email = usernameField.text, let password = passwordField.text {
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
       
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        //contraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.heightAnchor.constraint(equalToConstant: 35),
            usernameField.widthAnchor.constraint(equalToConstant: 250),
            passwordLabel.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 55),
            passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 35),
            passwordField.widthAnchor.constraint(equalToConstant: 250),
            
            //buttons
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 25),
            loginButton.widthAnchor.constraint(equalToConstant: 100),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            registerButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 25),
            registerButton.widthAnchor.constraint(equalToConstant: 100),
            loginButton.trailingAnchor.constraint(equalTo: registerButton.leadingAnchor, constant: -10)
           
        ])
      
    }
}

