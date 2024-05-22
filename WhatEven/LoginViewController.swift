//
//  ViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 1/22/24.
//

import UIKit
import Firebase

//fix this screen first, add some borders/styles/shadow to set tone
//light baby blue-pinkish-white

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
   
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "username"
        label.font = UIFont(name: Constants.Attributes.boldFont, size: 20)
        label.textColor = .white
        label.textAlignment = .center
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
        field.placeholder = "username"
        field.layer.cornerRadius = 20
        field.borderStyle = .none
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        //field.placeholder = "Madison.k.adams@gmail.com"
        field.font = UIFont(name: Constants.Attributes.regularFont, size: 15)
        field.backgroundColor = .white
        field.placeholder = "password"
        field.layer.cornerRadius = 20
        return field
    }()
    
    //choose the animation you want
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.setTitle("login", for: .normal)
        let buttonFont = UIFont(name: Constants.Attributes.regularFont, size: 25)
        let buttonColor = UIColor.white
        button.setBackgroundImage(UIImage(color: Constants.Attributes.styleBlue1), for: .normal)
        button.setBackgroundImage(UIImage(color: .systemPink), for: .highlighted)
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
        
        setUpTopLayout()
        setUpMedLayout()
        setUpButtonLayout()
     
        indicator.hidesWhenStopped = true
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
      
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Create a custom layer for the dashed border
        let dashedBorder = CAShapeLayer()
        dashedBorder.strokeColor = Constants.Attributes.pink1.cgColor // Set the color of the border
        dashedBorder.lineDashPattern = [3, 3] // Set the dash pattern [dashLength, gapLength]

        // Create a path for the dashed border (a rectangle path in this case)
        let path = UIBezierPath(roundedRect: usernameField.bounds, cornerRadius: usernameField.layer.cornerRadius)
        dashedBorder.path = path.cgPath

        // Set other properties of the dashed border
        dashedBorder.frame = usernameField.bounds
        dashedBorder.fillColor = nil // Make sure the border doesn't fill the inside of the path
        dashedBorder.lineWidth = 3 // Set the width of the border

        // Add the dashed border layer to the text field's layer
        usernameField.layer.addSublayer(dashedBorder)
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
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        titleLabel.layer.shadowOpacity = 0.5
        titleLabel.layer.shadowRadius = 6
        titleLabel.layer.masksToBounds = false
        

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
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: usernameField.frame.height))
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: passwordField.frame.height))
        
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
        
        // Assign the padding view to the leftView property of the UITextField
        // Create a padding view
     
        usernameField.leftView = paddingView1
        usernameField.leftViewMode = .always
        
        usernameField.layer.shadowColor = UIColor.black.cgColor // Set shadow color
        usernameField.layer.shadowOpacity = 0.5 // Set shadow opacity
        usernameField.layer.shadowOffset = CGSize(width: 0, height: 2) // Set shadow offset
        usernameField.layer.shadowRadius = 4 // Set shadow radius
        
        passwordField.leftView = paddingView2
        passwordField.leftViewMode = .always
     
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
            usernameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            usernameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            usernameField.heightAnchor.constraint(equalTo: greenView.heightAnchor, multiplier: 0.75),
            
            passwordLabel.topAnchor.constraint(equalTo: blueView.topAnchor),
            passwordLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            passwordLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            passwordLabel.heightAnchor.constraint(equalTo: blueView.heightAnchor, multiplier: 0.75),
            
            passwordField.topAnchor.constraint(equalTo: purpleView.topAnchor),
            passwordField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            passwordField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
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

