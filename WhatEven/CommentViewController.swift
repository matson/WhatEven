//
//  CommentViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 2/27/24.
//

import UIKit
import Firebase

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var receivedPostId: String?
    
    var userEmail: String?
    
    var commentsReceived: [Comment] = []
    
    let firebaseAPI = FirebaseAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let postID = receivedPostId {
            print("Received postID: \(postID)")
        }
        
        //get current user:
        if let currentUser = Auth.auth().currentUser {
            userEmail = currentUser.email
        }
        
        //tableView.reloadData()
        
        firebaseAPI.getComments(forPostId: receivedPostId!) { comments in
            self.commentsReceived = comments // Assign the separate comments array to the commentsReceived array
            self.tableView.reloadData()
        }
        
    }
    
    @IBOutlet weak var commentText: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func postComment(_ sender: UIButton) {
        
        let finalCommentText = commentText.text
        let db = Firestore.firestore()
        db.collection(Constants.FStore.collectionNameComment).addDocument(data: [
            Constants.FStore.commentTextField: finalCommentText,
            Constants.FStore.createdByField: userEmail,
            Constants.FStore.postIDField: receivedPostId
            
        ]){ (error) in
            if let e = error {
                print("There was an issue saving data")
            } else {
                print("Successfully saved data")
            }
        }
        
        // Refresh the table view
        tableView.reloadData()
        
        // Reset the text field
        commentText.text = ""
        
    }
    
    //MARK: -- TableView Methods
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return commentsReceived.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Attributes.commentCell, for: indexPath) as! CommentViewCell
        // Configure the cell with data
        let comment = commentsReceived[indexPath.row]
        cell.commentText.text = comment.text
        cell.userLabel.text = comment.user
        
        return cell
    }
    
}
