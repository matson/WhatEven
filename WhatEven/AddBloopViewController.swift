//
//  AddBloopViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 1/22/24.
//

import Foundation
import UIKit
import Firebase

class AddBloopViewController: UIViewController, UITextFieldDelegate {
    
    private let imageSelectedUI: UIImageView = {
        let image = UIImageView()
        return image
        
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(share), for: .touchUpInside)
        button.setTitle("Share", for: .normal)
        let buttonFont = UIFont(name: Constants.Attributes.regularFont, size: 25)
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
        activity.color = .blue
        return activity
    }()
    
    private let itemField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont(name: Constants.Attributes.regularFont, size: 15)
        field.backgroundColor = .white
        field.placeholder = "item name"
        field.layer.cornerRadius = 5
        return field
    }()
    
    private let descriptionField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont(name: Constants.Attributes.regularFont, size: 15)
        field.backgroundColor = .white
        field.placeholder = "item description"
        field.layer.cornerRadius = 5
        return field
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
        stack.axis = .vertical
        stack.backgroundColor = .clear
        return stack
        
    }()
    
    private let stackView3: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .clear
        return stack
        
    }()
    
    var imageSelected: UIImage?
    
    var uid: String?
    
    let firebaseAPI = FirebaseAPI()
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        indicator.hidesWhenStopped = true
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //This in the end should come from imagePicker
        imageSelectedUI.image = imageSelected
        
        itemField.delegate = self
        descriptionField.delegate = self
        
        //get current user:
        if let currentUser = Auth.auth().currentUser {
            uid = currentUser.uid
        }
        
        setUpLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    
    //post
    @objc func share(){
        guard checkFields() else {
            return
        }
        
        // Disable the share button
        shareButton.isEnabled = false
        
        // Start the activity indicator
        indicator.startAnimating()
        
        let name = itemField.text ?? ""
        let description = descriptionField.text ?? ""
        
       
        firebaseAPI.postItemToFirestore(name: name, description: description, image: imageSelectedUI.image!, uid: uid!) { error in
            if let error = error {
                let message = "Failed posting item: \(error)"
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                // Item posted successfully, perform the segue here
                self.performSegue(withIdentifier: Constants.Segue.backToHomeSegue, sender: self)
            }
            // Stop the activity indicator when the process is complete
            self.indicator.stopAnimating()
            
            // Enable the share button
            self.shareButton.isEnabled = true
        }
    }

    //MARK: -- Alerts
    
    
    func checkFields() -> Bool {
            // Check if the item name is empty
            guard let item = itemField.text, !item.isEmpty else {
                showErrorAlert(message: "Please enter an item name")
                return false
            }
            
            // Check if the item description is empty or less than 50 characters
            guard let descrip = descriptionField.text, !descrip.isEmpty, descrip.count > 50 else {
                showErrorAlert(message: "Please enter an item description with more than 50 characters")
                return false
            }
            
            return true
    }
    
    func setButton(){
        
        // Disable the share button
        shareButton.isEnabled = false
        
        // Add targets to the text fields to detect changes in their values
        itemField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        descriptionField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
           // Enable the share button only if both the name and description fields have text
           shareButton.isEnabled = !(itemField.text?.isEmpty ?? true) && !(descriptionField.text?.isEmpty ?? true)
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
extension AddBloopViewController {
    
    func setUpLayout(){
        
        view.backgroundColor = Constants.Attributes.styleBlue1
        view.addSubview(stackView1)
        view.addSubview(stackView2)
        view.addSubview(stackView3)
        
        let yellowView = UIView()
        yellowView.backgroundColor = .clear
        
        let greenView = UIView()
        greenView.backgroundColor = .clear
        
        stackView1.addArrangedSubview(imageSelectedUI)
        
        stackView2.addArrangedSubview(greenView)
        stackView2.addArrangedSubview(yellowView)
        
        stackView3.addArrangedSubview(shareButton)
        stackView3.addArrangedSubview(indicator)
        
        yellowView.addSubview(descriptionField)
        greenView.addSubview(itemField)
        
        NSLayoutConstraint.activate([
            stackView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView1.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView1.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40),
            
            stackView2.topAnchor.constraint(equalTo: stackView1.bottomAnchor),
            stackView2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView2.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            itemField.topAnchor.constraint(equalTo: greenView.topAnchor),
            itemField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            itemField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            itemField.heightAnchor.constraint(equalTo: greenView.heightAnchor, multiplier: 0.75),
            
            descriptionField.topAnchor.constraint(equalTo: yellowView.topAnchor),
            descriptionField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            descriptionField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            descriptionField.heightAnchor.constraint(equalTo: yellowView.heightAnchor, multiplier: 0.75),
            
            
            stackView3.topAnchor.constraint(equalTo: stackView2.bottomAnchor),
            stackView3.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView3.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView3.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20),

        ])
       
    }
}
