//
//  HomeViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 1/22/24.
//

import Foundation
import UIKit
import Firebase


//after user signs in, or registers will be shown this main screen.

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    //Goal:
    //Label should be the name
    //image should be the image
    
    @IBOutlet weak var feedView: UICollectionView!
    
    var bloops: [Bloop] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedView.dataSource = self
        feedView.delegate = self
        
        //Need Listener:
        let db = Firestore.firestore()
        let postsCollection = db.collection(Constants.FStore.collectionNamePost)
        
        postsCollection.addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching something")
                return
            }
            
            //map to custom object
            
            for document in documents {
                let data = document.data()
                
                //extract and then create a Post instance:
                let imageData = data["image"] as? Data ?? Data()
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let createdBy = data["createdBy"] as? String ?? ""
                
                let image = UIImage(data: imageData)
                
                let bloop = Bloop(images: image!, description: description, name: name, createdBy: createdBy)
                
                //add to array
                self.bloops.append(bloop)
                
            }
            self.bloops = self.bloops
            self.feedView.reloadData()
            
            
            
        }
            
        
        
        
        //to hide back button
        navigationItem.hidesBackButton = true
    }
    
    
    //to logout
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        do {
          try Auth.auth().signOut()
        //if successful...go back to Login
            navigationController?.popToRootViewController(animated: true)

        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func addPost(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.Segue.toPostSegue, sender: self)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //number in the array
        print(bloops.count)
        return bloops.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as! FeedCell
        
        let post = bloops[indexPath.item]
        // Configure the cell's image and label views
        cell.photo.image = post.images
        cell.clothingLabel.text = post.name
        //c= post.description
        //cell works and shows.
              
        return cell
    }
    
    
    // Implement the UICollectionViewDelegateFlowLayout method to customize the layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width
        let cellHeight: CGFloat = 300 // Set the desired height for each cell
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    //For DetailedViewController:
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    
}
