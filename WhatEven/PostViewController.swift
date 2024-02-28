//
//  PostViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 1/22/24.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class PostViewController: UIViewController {
    
    //this will allow a user to pick an image, then add the name and description on the next controller
    
    
    //should send image, description and label
    //will be doing this with imagePicker but not now.
    //to test will use default image
    //hardedcoded to test functionality:
    
    let db = Firestore.firestore()
    var postID = ""
    
    
    var posts: [Bloop] = []
    
    @IBOutlet weak var clothingName: UITextField!
    
    @IBOutlet weak var clothingDescrip: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //imagePicker.delegate = self
        
    }
    
   
    
    
    
    
    //post content to cloud/Firestore
    
    @IBAction func post(_ sender: UIButton) {
        let name = "Shein Weird Dress"
        let description = "Just God Awful!"
        let photo = UIImage(named: "Reality1")!
        let comment = "Girl this product is gross I had the same problem you had"
        
        // Convert the UIImage to Data
        guard let imageData = photo.pngData() else {
            // Handle the error if conversion fails
            return
        }
        if
           //let name = clothingName.text,
           //let description = clothingDescrip.text,
           let user = Auth.auth().currentUser?.email {
            let documentRef = db.collection(Constants.FStore.collectionNamePost).addDocument(data: [ Constants.FStore.createdByField: user,
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
            
            //works
            let postID = documentRef.documentID
            
            db.collection(Constants.FStore.collectionNameComment).addDocument(data: [
                Constants.FStore.commentTextField: comment,
                Constants.FStore.createdByField: user,
                Constants.FStore.postIDField: postID
            
            ]){ (error) in
                if let e = error {
                    print("There was an issue saving data")
                } else {
                    print("Successfully saved data")
                }
            }
                
        }
        
        
        
        
    }
    
    //let comment = "Girl this product is gross I had the same problem you had"
    
   
    @IBAction func pickPhoto(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        
    }
    
}
extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            // Pass the selected image to the next view controller
            let nextViewController = AddBloopViewController()
            nextViewController.imageSelected = selectedImage
            navigationController?.pushViewController(nextViewController, animated: true)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
