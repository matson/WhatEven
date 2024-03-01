//
//  CommentViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 2/27/24.
//

import UIKit
import Firebase

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    //load the comments from FireBase here
    //then populate, and then add them to Firebase.
    //need to get comments here
    
    var receivedPostID: String?
    
    var userEmail: String?
    
    var commentsReceived: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let postID = receivedPostID {
            print("Received postID: \(postID)")
        }
        
        //get current user:
        if let currentUser = Auth.auth().currentUser {
            userEmail = currentUser.email
        }
        
        tableView.reloadData()
        
        print(commentsReceived)

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var commentText: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func postComment(_ sender: UIButton) {
        
        let finalCommentText = commentText.text
        let db = Firestore.firestore()
        db.collection(Constants.FStore.collectionNameComment).addDocument(data: [
            Constants.FStore.commentTextField: finalCommentText,
            Constants.FStore.createdByField: userEmail,
            Constants.FStore.postIDField: receivedPostID
            
        ]){ (error) in
            if let e = error {
                print("There was an issue saving data")
            } else {
                print("Successfully saved data")
            }
        }
        let newComment = Comment(user: userEmail!, postID: receivedPostID!, text: finalCommentText!)
        //append to array:
        commentsReceived.append(newComment)
        
        //This will post the comment immediately.
        //Should send to Firebase then should be able to see it refreshed on the top of the tableView of this controller
        //should then be able to select it and then delete
        
        //saving correctly but need to figure out why it is not showing fast
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentViewCell
        // Configure the cell with data
        let comment = commentsReceived[indexPath.row]
        cell.commentText.text = comment.text
        cell.userLabel.text = comment.user
        
        return cell
    }

}
