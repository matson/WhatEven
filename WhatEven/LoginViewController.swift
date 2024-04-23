//
//  ViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 1/22/24.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    //Check activity indicator
    
    private let titleLabel: UITextView = {
        let textView = UITextView()
           textView.translatesAutoresizingMaskIntoConstraints = false
           textView.font = UIFont(name: Constants.Attributes.boldFont, size: 35) ?? UIFont.systemFont(ofSize: 35)
           textView.textColor = .white
           textView.backgroundColor = .clear
           textView.textAlignment = .center
           textView.text = "WhatEven!"
           return textView
    }()
   
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "username"
        label.font = UIFont(name: Constants.Attributes.boldFont, size: 15)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "password"
        label.font = UIFont(name: Constants.Attributes.boldFont, size: 15)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let usernameField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont(name: Constants.Attributes.regularFont, size: 15)
        field.backgroundColor = .white
        field.placeholder = "username"
        field.layer.cornerRadius = 5
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont(name: Constants.Attributes.regularFont, size: 15)
        field.backgroundColor = .white
        field.placeholder = "password"
        field.layer.cornerRadius = 5
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
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
        stack.axis = .horizontal
        stack.backgroundColor = .clear
        return stack
        
    }()
    
    private let stackView3: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .clear
        return stack
        
    }()
    
    private let topImageContainerView : UIView = {
        let topView = UIView()
        topView.backgroundColor = .clear
        topView.translatesAutoresizingMaskIntoConstraints = false
        return topView
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.color = .blue
        return activity
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Attributes.styleBlue1
        
        setUpTopLayout()
        setUpMedLayout()
        setUpButtonLayout()
     
        indicator.hidesWhenStopped = true
        
    }
    
    //Login
    @objc func loginButtonTapped() {
        print("works")
        // Start the activity indicator
        indicator.startAnimating()
        
        if let email = usernameField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                if let e = error {
                    let reason = e.localizedDescription
                    self.showErrorAlert(message: reason)
                }else{
                    self.performSegue(withIdentifier: Constants.Segue.loginSegue, sender: self)
                }
                // Stop the activity indicator when the process is complete
                //NEED TO ADD THIS
                self.indicator.stopAnimating()
                
            }
        }
        
    }
    
    @objc func registerButtonTapped() {
        print("register")
        performSegue(withIdentifier: Constants.Segue.toRegisterSegue, sender: self)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func setUpTopLayout(){
     
        view.addSubview(topImageContainerView)
        topImageContainerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            
            topImageContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            topImageContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topImageContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topImageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33),
            
            titleLabel.topAnchor.constraint(equalTo: topImageContainerView.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            titleLabel.bottomAnchor.constraint(equalTo: topImageContainerView.bottomAnchor, constant: -50),
            titleLabel.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.5),

        ])
    }
    
    func setUpMedLayout(){
        //username, password, labels
        
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
        
        yellowView.addSubview(usernameLabel)
        greenView.addSubview(usernameField)
        blueView.addSubview(passwordLabel)
        purpleView.addSubview(passwordField)
     
        NSLayoutConstraint.activate([
            stackView1.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor),
            stackView1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView1.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView1.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33),
            
            usernameLabel.topAnchor.constraint(equalTo: yellowView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            usernameLabel.heightAnchor.constraint(equalTo: yellowView.heightAnchor, multiplier: 0.75),
            
            usernameField.topAnchor.constraint(equalTo: greenView.topAnchor),
            usernameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            usernameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            usernameField.heightAnchor.constraint(equalTo: greenView.heightAnchor, multiplier: 0.75),
            
            passwordLabel.topAnchor.constraint(equalTo: blueView.topAnchor),
            passwordLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            passwordLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            passwordLabel.heightAnchor.constraint(equalTo: blueView.heightAnchor, multiplier: 0.75),
            
            passwordField.topAnchor.constraint(equalTo: purpleView.topAnchor),
            passwordField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            passwordField.heightAnchor.constraint(equalTo: purpleView.heightAnchor, multiplier: 0.75),
 
        ])
        
        
    }
    
    func setUpButtonLayout(){
        //two buttons and indicator
     
        view.addSubview(stackView2)
        view.addSubview(stackView3)
        stackView2.addArrangedSubview(loginButton)
        stackView2.addArrangedSubview(registerButton)
        stackView3.addSubview(indicator)
        
        
        
        NSLayoutConstraint.activate([
            stackView2.topAnchor.constraint(equalTo: stackView1.bottomAnchor),
            stackView2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView2.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
            
            stackView3.topAnchor.constraint(equalTo: stackView2.bottomAnchor),
            stackView3.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView3.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView3.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
            
            indicator.centerXAnchor.constraint(equalTo: stackView3.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: stackView3.centerYAnchor)
  
        ])
        
        
    }
 
}

