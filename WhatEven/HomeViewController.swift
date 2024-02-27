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
    
    @IBOutlet weak var feedView: UICollectionView!
    
    var bloops: [Bloop] = []
    var selectedPost: Bloop?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedView.dataSource = self
        feedView.delegate = self
        
        getData()
       
        //to hide back button
        navigationItem.hidesBackButton = true
        setRows()
        
        
    }
    
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
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
        //print(bloops.count)
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
        let collectionViewWidth = collectionView.bounds.width
        let space: CGFloat = 3.0
        let numberOfItemsPerRow: CGFloat = 3
        let dimension = (collectionViewWidth - ((numberOfItemsPerRow - 1) * space)) / numberOfItemsPerRow
        
        return CGSize(width: dimension, height: dimension)
    }
    
    func setRows(){
        // Create a new flow layout instance
        let layout = UICollectionViewFlowLayout()
        
        // Set the spacing between cells
        layout.minimumInteritemSpacing = 3.0
        layout.minimumLineSpacing = 3.0
        
        // Calculate the item size based on the available width
        let collectionViewWidth = feedView.bounds.width
        let numberOfItemsPerRow: CGFloat = 3
        let dimension = (collectionViewWidth - ((numberOfItemsPerRow - 1) * layout.minimumInteritemSpacing)) / numberOfItemsPerRow
        layout.itemSize = CGSize(width: dimension, height: dimension)
        
        // Set the collection view's layout
        feedView.collectionViewLayout = layout
    }
    
    
    //For DetailedViewController:
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the index of the selected item
        let selectedIndex = indexPath.item
        
        // Access the corresponding post from your array of posts
        selectedPost = bloops[selectedIndex]
        
        performSegue(withIdentifier: Constants.Segue.toDetailsSegue, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.toDetailsSegue {
            if let detailsVC = segue.destination as? DetailsViewController {
                if let selectedPost = selectedPost {
                    detailsVC.selectedPost = selectedPost
                    
                }
            }
        }
    }
    
    func getData(){
        //to interact with FireBase
        //Need Listener:
        let db = Firestore.firestore()
        let postsCollection = db.collection(Constants.FStore.collectionNamePost)

        postsCollection.addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching something")
                return
            }
            
            var bloops = [Bloop]() // Create a separate array for bloops
            
            let dispatchGroup = DispatchGroup()
            
            for document in documents {
                let data = document.data()
                let postID = document.documentID
                
                dispatchGroup.enter() // Enter the dispatch group
                
                // Retrieve comments for the current post
                let commentsCollection = db.collection(Constants.FStore.collectionNameComment)
                commentsCollection.whereField("postId", isEqualTo: postID).getDocuments { (snapshot, error) in
                    
                    defer {
                        dispatchGroup.leave() // Leave the dispatch group when the closure finishes
                    }
                    
                    guard let commentDocuments = snapshot?.documents else {
                        print("Error fetching comments for post \(postID)")
                        return
                    }
                    
                    var tempComments = [Comment]() // Create a separate array for comments
                    
                    // Iterate through comment documents
                    for commentDocument in commentDocuments {
                        let commentData = commentDocument.data()
                        // Extract comment attributes and create a Comment instance
                        let user = commentData["createdBy"] as? String ?? ""
                        let text = commentData["commentText"] as? String ?? ""
                        let postID = commentData["postId"] as? String ?? ""
                        // ...
                        let comment = Comment(user: user, postID: postID, text: text/* comment attributes */)
                        //print(comment)
                        
                        // Add comment to the post's comments array
                        tempComments.append(comment)
                    }
                    
                    // Rest of the code for creating Bloop instance
                    
                    let imageData = data["image"] as? Data ?? Data()
                    let name = data["name"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let createdBy = data["createdBy"] as? String ?? ""
                    
                    let image = UIImage(data: imageData)
                    
                    let bloop = Bloop(images: image!, description: description, name: name, comments: tempComments, createdBy: createdBy)
                    
                    //add to array
                    bloops.append(bloop)
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.bloops = bloops // Assign the separate bloops array to the main bloops array
                self.feedView.reloadData()
                //print(self.bloops)
            }
        
        }
    }
    
    
    
    
}
