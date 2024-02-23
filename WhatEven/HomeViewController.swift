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
    
    //to populate feed:
    var bloops: [Bloop] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedView.dataSource = self
        feedView.delegate = self
        
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as! FeedCell
              
        // Configure the cell's image and label views
        //cell.photo.image = UIImage(named: "Online1")
        //cell.clothingLabel.text = "Tan CockTail Dress"
        //cell works and shows.
              
        return cell
    }
    
    
    // Implement the UICollectionViewDelegateFlowLayout method to customize the layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width
        let cellHeight: CGFloat = 300 // Set the desired height for each cell
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    
}
