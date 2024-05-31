//
//  ViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 1/22/24.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    private let titleLabel: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: Constants.Attributes.boldFont, size: 50) ?? UIFont.systemFont(ofSize: 35)
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.text = "WhatEven!"
        return textView
    }()
    
    private let gotStuffText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "got stuff to say?"
        label.font = UIFont(name: Constants.Attributes.regularFont, size: 20)
        label.textColor = .white
        label.textAlignment = .center
        
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.5
        label.layer.shadowRadius = 6
        label.layer.masksToBounds = false
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "password"
        label.font = UIFont(name: Constants.Attributes.boldFont, size: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    
    private let usernameField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont(name: Constants.Attributes.regularFont, size: 15)
        field.backgroundColor = .clear
        field.textColor = .white
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.5),
        ]
        field.attributedPlaceholder = NSAttributedString(string: "username", attributes: attributes)
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont(name: Constants.Attributes.regularFont, size: 15)
        field.backgroundColor = .clear
        field.textColor = .white
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.5),
        ]
        field.attributedPlaceholder = NSAttributedString(string: "password", attributes: attributes)
        return field
    }()
    
    //choose the animation you want
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.setTitle("login", for: .normal)
        let buttonFont = UIFont(name: Constants.Attributes.regularFont, size: 25)
        let buttonColor = UIColor.white
        button.backgroundColor = Constants.Attributes.styleBlue2
        button.layer.cornerRadius = 15
        button.titleLabel?.font = buttonFont
        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonColor, for: .highlighted)
        button.setTitleColor(buttonColor, for: .disabled)
        button.setTitleColor(buttonColor, for: .selected)
        
        // Adding borders
        button.layer.borderWidth = 2 // Adjust border width as needed
        button.layer.borderColor = UIColor.white.cgColor // Adjust border color as needed
        
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 6
        button.layer.masksToBounds = false
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
        button.backgroundColor = Constants.Attributes.styleBlue2
        button.layer.cornerRadius = 15
        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonColor, for: .highlighted)
        button.setTitleColor(buttonColor, for: .disabled)
        button.setTitleColor(buttonColor, for: .selected)
        
        // Adding borders
        button.layer.borderWidth = 2 // Adjust border width as needed
        button.layer.borderColor = UIColor.white.cgColor // Adjust border color as needed
        
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 6
        button.layer.masksToBounds = false
        return button
        
    }()
    
    private let containerView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.backgroundColor = Constants.Attributes.pink1
        stack.layer.cornerRadius = 15
        stack.layer.shadowColor = UIColor.black.cgColor
        stack.layer.shadowOffset = CGSize(width: 0, height: 2)
        stack.layer.shadowOpacity = 0.5
        stack.layer.shadowRadius = 6
        stack.layer.masksToBounds = false
        
        // Adding border
        stack.layer.borderWidth = 2 // Adjust border width as needed
        stack.layer.borderColor = UIColor.white.cgColor //
        return stack
        
    }()
    
    private let stackView2: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
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
        
    
        
        setUpTopLayout()
        setUpMedLayout()
        setUpButtonLayout()
        
        indicator.hidesWhenStopped = true
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    
    
    //Login Action
    @objc func loginButtonTapped() {
        
        //loginButton.alpha = 0.5
        
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
                
                self.indicator.stopAnimating()
                
            }
        }
        
    }
    
    //To Register Screen
    @objc func registerButtonTapped() {
        performSegue(withIdentifier: Constants.Segue.toRegisterSegue, sender: self)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: -- Keyboard Functionality
    
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        let keyboardHeight = view.frame.maxY - keyboardFrame.origin.y
        let animationCurve = UIView.AnimationCurve(rawValue: userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        let animationOptions = UIView.AnimationOptions(rawValue: UInt(animationCurve.rawValue << 16))
        
        if keyboardFrame.origin.y < view.frame.maxY {
            // Keyboard is appearing
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
                self.view.frame.origin.y = -keyboardHeight + self.view.safeAreaInsets.bottom
            }, completion: nil)
        } else {
            // Keyboard is disappearing
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
                self.view.frame.origin.y = 0
            }, completion: nil)
        }
    }
    
    //to dismiss Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension LoginViewController {
    
    //MARK: -- Constraints
    
    func setUpTopLayout(){
        
        view.addSubview(topImageContainerView)
        topImageContainerView.addSubview(titleLabel)
        view.backgroundColor = Constants.Attributes.styleBlue1
        
        //title
        setTitleDetails()
        
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
        
        
        view.addSubview(containerView)
        
        containerView.addArrangedSubview(yellowView)
        containerView.addArrangedSubview(greenView)
        containerView.addArrangedSubview(blueView)
        
        
        yellowView.addSubview(gotStuffText)
        greenView.addSubview(usernameField)
        blueView.addSubview(passwordField)
        
        setBorderStyle()
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33),
            
            
            gotStuffText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            gotStuffText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            gotStuffText.centerXAnchor.constraint(equalTo: yellowView.centerXAnchor),
            gotStuffText.centerYAnchor.constraint(equalTo: yellowView.centerYAnchor, constant: 5),
            
            
            usernameField.centerXAnchor.constraint(equalTo: greenView.centerXAnchor),
            usernameField.centerYAnchor.constraint(equalTo: greenView.centerYAnchor, constant: -10),
            usernameField.widthAnchor.constraint(equalTo: greenView.widthAnchor, multiplier: 0.8), // Adjust the multiplier as needed
            usernameField.heightAnchor.constraint(equalTo: greenView.heightAnchor, multiplier: 0.5),
            
            passwordField.centerXAnchor.constraint(equalTo: blueView.centerXAnchor),
            passwordField.centerYAnchor.constraint(equalTo: blueView.centerYAnchor, constant: -10),
            passwordField.widthAnchor.constraint(equalTo: blueView.widthAnchor, multiplier: 0.8), // Adjust the multiplier as needed
            passwordField.heightAnchor.constraint(equalTo: blueView.heightAnchor, multiplier: 0.5),
            
            
        ])
        
        
    }
    
    func setUpButtonLayout(){
        //two buttons and indicator
        
        let yellowView = UIView()
        yellowView.backgroundColor = .clear
        
        let greenView = UIView()
        greenView.backgroundColor = .clear
        
        view.addSubview(stackView2)
        view.addSubview(stackView3)
        
        stackView2.addArrangedSubview(yellowView)
        stackView2.addArrangedSubview(greenView)
        
        yellowView.addSubview(loginButton)
        greenView.addSubview(registerButton)
        
        stackView3.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            stackView2.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 5),
            stackView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView2.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
            
            //buttons
            loginButton.centerXAnchor.constraint(equalTo: yellowView.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: yellowView.centerYAnchor),
            loginButton.widthAnchor.constraint(equalTo: yellowView.widthAnchor, multiplier: 0.95),
            loginButton.heightAnchor.constraint(equalTo: yellowView.heightAnchor, multiplier: 0.95),
            
            registerButton.centerXAnchor.constraint(equalTo: greenView.centerXAnchor),
            registerButton.centerYAnchor.constraint(equalTo: greenView.centerYAnchor),
            registerButton.widthAnchor.constraint(equalTo: greenView.widthAnchor, multiplier: 0.95),
            registerButton.heightAnchor.constraint(equalTo: greenView.heightAnchor, multiplier: 0.95),
            
            stackView3.topAnchor.constraint(equalTo: stackView2.bottomAnchor),
            stackView3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView3.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
            
            indicator.centerXAnchor.constraint(equalTo: stackView3.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: stackView3.centerYAnchor)
            
        ])
        
        
    }
    
    
    func setBorderStyle(){
        
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: usernameField.frame.height))
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: passwordField.frame.height))
        
        usernameField.leftView = paddingView1
        usernameField.leftViewMode = .always
        
        passwordField.leftView = paddingView2
        passwordField.leftViewMode = .always
        
        usernameField.borderStyle = .none
        // Set up rounded corners and white border
        usernameField.layer.cornerRadius = 20
        usernameField.layer.borderWidth = 2
        usernameField.layer.borderColor = UIColor.white.cgColor
        usernameField.layer.shadowColor = UIColor.systemPink.cgColor// Set shadow color
        usernameField.layer.shadowOpacity = 0.5 // Set shadow opacity
        usernameField.layer.shadowOffset = CGSize(width: 0, height: 2) // Set shadow offset
        usernameField.layer.shadowRadius = 9 // Set shadow radius
        
        passwordField.borderStyle = .none
        // Set up rounded corners and white border
        passwordField.layer.cornerRadius = 20
        passwordField.layer.borderWidth = 2
        passwordField.layer.borderColor = UIColor.white.cgColor
        passwordField.layer.shadowColor = UIColor.systemPink.cgColor // Set shadow color
        passwordField.layer.shadowOpacity = 0.5 // Set shadow opacity
        passwordField.layer.shadowOffset = CGSize(width: 0, height: 2) // Set shadow offset
        passwordField.layer.shadowRadius = 9 // Set shadow radius
    }
    
    func setTitleDetails(){
        //title
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        titleLabel.layer.shadowOpacity = 0.5
        titleLabel.layer.shadowRadius = 6
        titleLabel.layer.masksToBounds = false
    }
    
    
}

extension UIImage {
    convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        self.init(ciImage: CIImage(image: image)!)
    }
}

