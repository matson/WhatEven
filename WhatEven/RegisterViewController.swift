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
    
    //Check registration logic and indicator 
    
    private let stackView1: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.backgroundColor = .clear
        return stack
        
    }()
    
    private let stackView2: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.backgroundColor = .clear
        return stack
        
    }()
    
    private let stackView3: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.backgroundColor = .clear
        return stack
        
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "email"
        label.font = UIFont(name: Constants.Attributes.boldFont, size: 25)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "password"
        label.font = UIFont(name: Constants.Attributes.boldFont, size: 25)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "create a cool username"
        label.font = UIFont(name: Constants.Attributes.boldFont, size: 25)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont(name: Constants.Attributes.regularFont, size: 15)
        field.backgroundColor = .white
        field.placeholder = "password"
        field.layer.cornerRadius = 5
        return field
    }()
    
    private let usernameTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont(name: Constants.Attributes.regularFont, size: 15)
        field.backgroundColor = .white
        field.placeholder = "username"
        field.layer.cornerRadius = 5
        return field
    }()
    
    private let emailTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont(name: Constants.Attributes.regularFont, size: 15)
        field.backgroundColor = .white
        field.placeholder = "email"
        field.layer.cornerRadius = 5
        return field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        button.setTitle("register", for: .normal)
        let buttonFont = UIFont(name: Constants.Attributes.boldFont, size: 25)
        let buttonColor = UIColor.white
        button.titleLabel?.font = buttonFont
        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonColor, for: .highlighted)
        button.setTitleColor(buttonColor, for: .disabled)
        button.setTitleColor(buttonColor, for: .selected)
        return button
        
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.color = .black
        return activity
    }()
    
    let firebaseAPI = FirebaseAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and configure the activity indicator
        indicator.hidesWhenStopped = true
        
        setUpTopLayout()
        setUpMedLayout()
        setUpBottomLayout()
        
        view.backgroundColor = Constants.Attributes.styleBlue2
        
        
    }
    
    //Register New User
    @IBAction func register(_ sender: UIButton) {
        
        checkFields()

    }
    
    @objc func registerButtonTapped() {
        // Start the activity indicator
        indicator.startAnimating()
        
        if let email = emailTextField.text,
           let password = passwordTextField.text,
           let username = usernameTextField.text {
            firebaseAPI.createUser(withEmail: email, password: password, username: username) { error in
                if let error = error {
                    let reason = error.localizedDescription
                    self.showErrorAlert(message: reason)
                } else {
                    self.performSegue(withIdentifier: Constants.Segue.registerSegue, sender: self)
                }
                // Stop the activity indicator when the process is complete
                self.indicator.stopAnimating()
            }
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
        registerButtonTapped()
        
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // Use regular expression to validate email format
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func setUpTopLayout(){
        let yellowView = UIView()
        yellowView.backgroundColor = .clear
        
        let greenView = UIView()
        greenView.backgroundColor = .clear
        
        let blueView = UIView()
        blueView.backgroundColor = .clear
        
        let purpleView = UIView()
        purpleView.backgroundColor = .clear
        view.addSubview(stackView1)
        
        stackView1.addArrangedSubview(yellowView)
        stackView1.addArrangedSubview(greenView)
        stackView1.addArrangedSubview(blueView)
        stackView1.addArrangedSubview(purpleView)
        
        yellowView.addSubview(emailLabel)
        greenView.addSubview(emailTextField)
        blueView.addSubview(passwordLabel)
        purpleView.addSubview(passwordTextField)
        

        NSLayoutConstraint.activate([
            
            stackView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView1.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView1.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),
            
            emailLabel.topAnchor.constraint(equalTo: yellowView.topAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emailLabel.heightAnchor.constraint(equalTo: yellowView.heightAnchor, multiplier: 0.75),
            
            emailTextField.topAnchor.constraint(equalTo: greenView.topAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalTo: greenView.heightAnchor, multiplier: 0.75),
            
            passwordLabel.topAnchor.constraint(equalTo: blueView.topAnchor),
            passwordLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            passwordLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            passwordLabel.heightAnchor.constraint(equalTo: blueView.heightAnchor, multiplier: 0.75),
            
            passwordTextField.topAnchor.constraint(equalTo: purpleView.topAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: purpleView.heightAnchor, multiplier: 0.75),
        
            
        ])
    }
    
    func setUpMedLayout(){
        
        let blueView = UIView()
        blueView.backgroundColor = .clear
        
        let purpleView = UIView()
        purpleView.backgroundColor = .clear
        view.addSubview(stackView2)
        stackView2.addArrangedSubview(blueView)
        stackView2.addArrangedSubview(purpleView)
        blueView.addSubview(usernameLabel)
        purpleView.addSubview(usernameTextField)
        
        
        NSLayoutConstraint.activate([
            
            stackView2.topAnchor.constraint(equalTo: stackView1.bottomAnchor),
            stackView2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView2.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            usernameLabel.topAnchor.constraint(equalTo: blueView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            usernameLabel.heightAnchor.constraint(equalTo: blueView.heightAnchor, multiplier: 0.75),
            
            usernameTextField.topAnchor.constraint(equalTo: purpleView.topAnchor),
            usernameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            usernameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            usernameTextField.heightAnchor.constraint(equalTo: purpleView.heightAnchor, multiplier: 0.75),
            
            
            
        ])
     
    }
    
    func setUpBottomLayout(){
        let blueView = UIView()
        blueView.backgroundColor = .clear
        
        let purpleView = UIView()
        purpleView.backgroundColor = .clear
        view.addSubview(stackView3)
        stackView3.addArrangedSubview(blueView)
        stackView3.addArrangedSubview(purpleView)
        blueView.addSubview(registerButton)
        purpleView.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            
            stackView3.topAnchor.constraint(equalTo: stackView2.bottomAnchor),
            stackView3.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView3.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView3.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),

            registerButton.topAnchor.constraint(equalTo: blueView.topAnchor),
            registerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            registerButton.heightAnchor.constraint(equalTo: blueView.heightAnchor, multiplier: 0.75),
            
            indicator.topAnchor.constraint(equalTo: purpleView.topAnchor),
            indicator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            indicator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            indicator.heightAnchor.constraint(equalTo: purpleView.heightAnchor, multiplier: 0.75),
   
        ])
    }
    
    
}
