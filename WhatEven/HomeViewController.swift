//
//  HomeViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 1/22/24.
//

import Foundation
import UIKit
import Firebase



class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var feedView: UICollectionView!
    
    @IBOutlet weak var toolBar: UIToolbar!
   
    private let indicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.color = .blue
        return activity
    }()
   
    var bloops: [Bloop] = []
    
    var selectedPost: Bloop?
    
    //need this for posting comments
    var globalPostID: String?
    
    var loggedUser: String?
    
    let firebaseAPI = FirebaseAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedView.dataSource = self
        feedView.delegate = self
        feedView.register(FeedCell.self, forCellWithReuseIdentifier: Constants.Attributes.feedCell)
        
        indicator.hidesWhenStopped = true
        
        //get current user:
        if let currentUser = Auth.auth().currentUser {
            loggedUser = currentUser.uid
        }
        
        indicator.startAnimating()
        
        firebaseAPI.getPosts(completion: { bloops in
            
            self.bloops = bloops
            self.feedView.reloadData()
            self.indicator.stopAnimating()
          //add something here
        }, errorHandler: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        })
        
        //to hide back button
        navigationItem.hidesBackButton = true
        
        setRows()
        
        setCollectionLayout()

    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //to logout
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            //if successful...go back to Login
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            // Show alert
            let alert = UIAlertController(title: "Error", message: "Trouble signing out", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
                  
        }
    }
  
    @IBAction func addPost(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.Segue.toPostSegue, sender: self)
    }
    
    //MARK: -- CollectionView Methods
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return bloops.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Attributes.feedCell, for: indexPath) as! FeedCell
        
        let post = bloops[indexPath.item]
        
        configureDeleteButton(for: cell, post: post, loggedUser: loggedUser!)
        
        // Configure the cell's image and label views
        cell.imageView.image = post.images
        cell.clothingLabel.text = post.name
   
        
        return cell
    }
    
    
    // Implement the UICollectionViewDelegateFlowLayout method to customize the layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.bounds.width
        let space: CGFloat = 3.0
        let numberOfItemsPerRow: CGFloat = UIDevice.current.orientation.isPortrait ? 3 : 6
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
    
    //send selected post to next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.toDetailsSegue {
            if let detailsVC = segue.destination as? DetailsViewController {
                if let selectedPost = selectedPost {
                    detailsVC.selectedPost = selectedPost
                    
                    
                }
            }
        }
    }
    
    //MARK: --Helper Methods
    //go back to here if the delete buttons are wrong
    func configureDeleteButton(for cell: FeedCell, post: Bloop, loggedUser: String) {
        if post.createdBy.uid == loggedUser {
            cell.deleteButton.isHidden = false
            cell.deleteAction = { [weak self] in
                self?.deletePost(post)
            }
        } else {
            cell.deleteButton.isHidden = true
            cell.deleteAction = nil
        }
    }
    
    func deletePost(_ post: Bloop) {
        
        indicator.startAnimating()
        
        firebaseAPI.deletePost(post) { [weak self] success in
            if success {
                // Delete the post from the local array or perform any other necessary actions
                if let index = self?.bloops.firstIndex(of: post) {
                    self?.bloops.remove(at: index)
                    self?.feedView.reloadData()
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Failed to delete post", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
               
            }
            self?.indicator.stopAnimating()
        }
    }

}
extension HomeViewController {
    
    //MARK: -- Constraints
    
    func setCollectionLayout(){
        view.backgroundColor = Constants.Attributes.styleBlue2
        toolBar.tintColor = .white
        toolBar.barTintColor = Constants.Attributes.styleBlue2
        
        feedView.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: feedView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: feedView.centerYAnchor)
        ])
  
    }
    
}

