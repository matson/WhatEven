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
    
    //should send image, description and label
    //will be doing this with imagePicker but not now.
    //to test will use default image
    //hardedcoded to test functionality:
    
    let db = Firestore.firestore()
    var postID = ""
    
    
    var posts: [Bloop] = [
        
        //        Bloop(images: UIImage(named: "Online1")!, description: "Link of item needed and more details", name: "Shein Tan Dress", comments: ["",""]),
        //        Bloop(images: UIImage(named: "Online2")!, description: "Link of item required", name: "Shein Jean Straps", comments: ["",""])
        
    ]
    
    @IBOutlet weak var clothingName: UITextField!
    
    @IBOutlet weak var clothingDescrip: UITextField!
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
            let documentRef = db.collection(Constants.FStore.collectionName).addDocument(data: [ Constants.FStore.createdByField: user,
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
            
            db.collection("comments").addDocument(data: [
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
    
    @IBAction func AddComment(_ sender: UIButton) {
        
       //assume that we select a post, then it shows the post on the DetailViewController.
        //We want to show the Post, as well as the collection comment's associated with this post.
        //Each comment should have the postID (firebase auto ID) for the post collection.  How do I retrieve the data from Firebase?
        

    }
    
}
