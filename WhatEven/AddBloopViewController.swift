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
    
    //to add to this controller:
    //an alert to state you need a name, description to share ***
    
    
    @IBOutlet weak var imageSelectedUI: UIImageView!
    
    @IBOutlet weak var itemName: UITextField!
    
    @IBOutlet weak var itemDescription: UITextField!
    
    var imageSelected: UIImage?
    
    var userEmail: String?
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for testing:
        //This in the end should come from imagePicker. ***
        //imageSelectedUI.image = imageSelected
        let imageEx = UIImage(named: "Online5")
        imageSelectedUI.image = imageEx
        
        //get current user:
        if let currentUser = Auth.auth().currentUser {
            userEmail = currentUser.email
        }

    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        
        let name = itemName.text
        let description = itemDescription.text!
        
        // Convert the UIImage to Data
        guard let imageData = imageSelectedUI.image!.pngData() else {
            // Handle the error if conversion fails
            return
        }

        let db = Firestore.firestore()
        let documentRef = db.collection(Constants.FStore.collectionNamePost).addDocument(data: [ Constants.FStore.createdByField: userEmail,
            Constants.FStore.postImageField: imageData,
            Constants.FStore.postNameField: name,
            Constants.FStore.postDescriptionField: description
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data")
            } else {
                print("Successfully saved data")
            }
        }
        // Perform the segue to navigate back to HomeViewController
        performSegue(withIdentifier: Constants.Segue.backToHomeSegue, sender: self)
    }
  
}
