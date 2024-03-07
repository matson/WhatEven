//
//  BodyViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 1/22/24.
//

import Foundation
import UIKit
import Firebase

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var clothingLabel: UILabel!
    
    @IBOutlet weak var descriptionText: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var globalPostId: String?
    
    var comments: [Comment] = []
    
    var user: UserDetails?
    
    var selectedPost: Bloop?
    
    let firebaseAPI = FirebaseAPI()
    
    var loggedUser: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //get current user:
        if let currentUser = Auth.auth().currentUser {
            loggedUser = currentUser.uid
        }
        
        //get comments
        firebaseAPI.getComments(forPostId: selectedPost!.postID) { comments in
            self.comments = comments // Assign the separate comments array to the commentsReceived array
            self.tableView.reloadData()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setAttributes()
        
        //get comments
        firebaseAPI.getComments(forPostId: selectedPost!.postID) { comments in
            self.comments = comments // Assign the separate comments array to the commentsReceived array
            self.tableView.reloadData()
            
        }
        
        
    }
    
    
    @IBAction func add(_ sender: UIButton) {
        
        //to CommentViewController
        let storyBoard: UIStoryboard = UIStoryboard(name: Constants.Attributes.mainStoryboardName, bundle: nil)
        guard let commentVC = storyBoard.instantiateViewController(withIdentifier: Constants.Attributes.commentViewControllerId) as? CommentViewController else { return }
        commentVC.receivedPostId = globalPostId
        commentVC.modalPresentationStyle = .fullScreen
        commentVC.modalTransitionStyle = .crossDissolve
        
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
    //MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //get comments
        firebaseAPI.getComments(forPostId: selectedPost!.postID) { comments in
            self.comments = comments // Assign the separate comments array to the commentsReceived array
            
            
        }
        
        return comments.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Attributes.commentCell, for: indexPath) as! CommentViewCell
        
        // Configure the cell with data
        let comment = comments[indexPath.row]
        cell.commentText.text = comment.text
        cell.userLabel.text = comment.user.username
        
        // Update the delete button visibility
        updateDeleteButtonVisibility(for: cell, with: comment, loggedInUserID: loggedUser!)
        
        // Assign the delete action closure
        cell.deleteAction = { [weak self] in
            self?.deleteComment(at: indexPath)
        }
        
        return cell
    }
    
    //MARK: Helper Methods
    
    func setAttributes(){
        //set features to selectedPost attributes
        photo.image = selectedPost?.images
        clothingLabel.text = selectedPost?.name
        descriptionText.text = selectedPost?.description
        globalPostId = selectedPost?.postID
    }
    
    func updateDeleteButtonVisibility(for cell: CommentViewCell, with comment: Comment, loggedInUserID: String) {
        if comment.user.uid == loggedInUserID {
            // Show the delete button
            cell.delete.isHidden = false
        } else {
            // Hide the delete button
            cell.delete.isHidden = true
        }
    }
    
    func deleteComment(at indexPath: IndexPath) {
        let comment = comments[indexPath.row]
        
        // Delete the comment from Firestore
        firebaseAPI.deleteComment(comment) { [weak self] success in
            if success {
                // Delete the comment from the local array
                self?.comments.remove(at: indexPath.row)
                
                // Delete the comment from the table view
                self?.tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                // Handle deletion failure
                // Display an error message or take appropriate action
            }
        }
    }
    
}
