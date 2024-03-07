//
//  CommentViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 2/27/24.
//

import UIKit
import Firebase

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var postComment: UIButton!
    
    var receivedPostId: String?
    
    var uid: String?
    
    var commentsReceived: [Comment] = []
    
    let firebaseAPI = FirebaseAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setButton()
        
        //get current user:
        if let currentUser = Auth.auth().currentUser {
            uid = currentUser.uid
        }
        
        //get comments
        firebaseAPI.getComments(forPostId: receivedPostId!) { comments in
            self.commentsReceived = comments // Assign the separate comments array to the commentsReceived array
            self.tableView.reloadData()
        }
        
    }
    
    @IBOutlet weak var commentText: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //post comment
    @IBAction func postComment(_ sender: UIButton) {
        
        let finalCommentText = commentText.text ?? ""
        
        //get the current time for comment posting
        let timestamp = Date().timeIntervalSince1970
    
        firebaseAPI.postCommentToFirestore(commentText: finalCommentText, uid: uid!, receivedPostId: receivedPostId!, timestamp: timestamp) { result in
            switch result {
            case .success:
                print("Comment posted successfully")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error posting comment: \(error.localizedDescription)")
            }
        }
        
        // Disable the post button
        postComment.isEnabled = false
        
        // Refresh the table view
        tableView.reloadData()
        
        // Reset the text field
        commentText.text = ""
        
    }
    
    @objc func commentTextChanged() {
        // Enable the post button only if the comment text field is not empty
        postComment.isEnabled = !commentText.text!.isEmpty
    }
    
    func setButton(){
        // Set up the initial state of the post button
        postComment.isEnabled = false
        
        // Add a target to the comment text field to detect changes in its text
        commentText.addTarget(self, action: #selector(commentTextChanged), for: .editingChanged)
        
    }
    
    //MARK: -- TableView Methods
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //get comments
        firebaseAPI.getComments(forPostId: receivedPostId!) { comments in
            self.commentsReceived = comments // Assign the separate comments array to the commentsReceived array
           
        }
        
        return commentsReceived.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Attributes.commentCell, for: indexPath) as! CommentViewCell
        // Configure the cell with data
        let comment = commentsReceived[indexPath.row]
        cell.commentText.text = comment.text
        cell.userLabel.text = comment.user.username
        
        return cell
    }
    
}
