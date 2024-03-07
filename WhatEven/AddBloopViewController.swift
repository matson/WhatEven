//
//  AddBloopViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 1/22/24.
//

import Foundation
import UIKit
import Firebase

class AddBloopViewController: UIViewController {

    @IBOutlet weak var imageSelectedUI: UIImageView!
    
    @IBOutlet weak var itemName: UITextField!
    
    @IBOutlet weak var itemDescription: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var share: UIButton!
    
    var imageSelected: UIImage?
    
    var uid: String?
    
    let firebaseAPI = FirebaseAPI()
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        activityIndicator.hidesWhenStopped = true
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for testing:
        //This in the end should come from imagePicker. ***
        //imageSelectedUI.image = imageSelected
        let imageEx = UIImage(named: "Online3")
        imageSelectedUI.image = imageEx
        
        //get current user:
        if let currentUser = Auth.auth().currentUser {
            uid = currentUser.uid
        }
        
        setButton()
        
    }
    
    
    //post
    @IBAction func shareButton(_ sender: UIButton) {
        
        guard checkFields() else {
            return
        }
        
        // Disable the share button
        sender.isEnabled = false
        
        // Start the activity indicator
        activityIndicator.startAnimating()
        
        let name = itemName.text ?? ""
        let description = itemDescription.text ?? ""
        
        //****
        // Convert the UIImage to Data
        guard let imageData = imageSelectedUI.image!.pngData() else {
            // Handle the error if conversion fails
            return
        }
        
        //****
        firebaseAPI.postItemToFirestore(name: name, description: description, image: imageSelectedUI.image!, uid: uid!) { error in
            if let error = error {
                // Handle the error
                print("Error posting item: \(error)")
            } else {
                // Item posted successfully, perform the segue here
                self.performSegue(withIdentifier: Constants.Segue.backToHomeSegue, sender: self)
            }
            // Stop the activity indicator when the process is complete
            self.activityIndicator.stopAnimating()
            
            // Enable the share button
            sender.isEnabled = true
        }
        
    }
    
    //MARK: -- Alerts
    
    func checkFields() -> Bool {
            // Check if the item name is empty
            guard let item = itemName.text, !item.isEmpty else {
                showErrorAlert(message: "Please enter an item name")
                return false
            }
            
            // Check if the item description is empty or less than 50 characters
            guard let descrip = itemDescription.text, !descrip.isEmpty, descrip.count > 50 else {
                showErrorAlert(message: "Please enter an item description with more than 50 characters")
                return false
            }
            
            return true
    }
    
    func setButton(){
        
        // Disable the share button
        share.isEnabled = false
        
        // Add targets to the text fields to detect changes in their values
        itemName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        itemDescription.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
           // Enable the share button only if both the name and description fields have text
           share.isEnabled = !(itemName.text?.isEmpty ?? true) && !(itemDescription.text?.isEmpty ?? true)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
  
}
