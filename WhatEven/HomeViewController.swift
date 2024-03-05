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
    
    //need this for posting comments
    var globalPostID: String?
    
    let firebaseAPI = FirebaseAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedView.dataSource = self
        feedView.delegate = self
        
        firebaseAPI.getPosts { bloops in
            
            self.bloops = bloops
            self.feedView.reloadData()
            
        }
       
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
        
        return bloops.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Attributes.feedCell, for: indexPath) as! FeedCell
        
        let post = bloops[indexPath.item]
        
        // Configure the cell's image and label views
        cell.photo.image = post.images
        cell.clothingLabel.text = post.name
   
        
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

}
