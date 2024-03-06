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
    
    var uid: String?
    
    let firebaseAPI = FirebaseAPI()
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
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
        
        
        
    }
    
    
    //post
    @IBAction func shareButton(_ sender: UIButton) {
        
        let name = itemName.text ?? ""
        let description = itemDescription.text ?? ""
        
        // Convert the UIImage to Data
        guard let imageData = imageSelectedUI.image!.pngData() else {
            // Handle the error if conversion fails
            return
        }
        
        firebaseAPI.postItemToFirestore(name: name, description: description, image: imageSelectedUI.image!, uid: uid!) { error in
            if let error = error {
                // Handle the error
                print("Error posting item: \(error)")
            } else {
                // Item posted successfully, perform the segue here
                self.performSegue(withIdentifier: Constants.Segue.backToHomeSegue, sender: self)
            }
        }
        
    }
    
}
