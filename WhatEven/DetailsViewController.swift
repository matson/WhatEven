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
    
    //reload data here first
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var clothingLabel: UILabel!
    
    @IBOutlet weak var descriptionText: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var globalPostId: String?
    
    var comments: [Comment] = []
    
    var user: UserDetails?
    
    var selectedPost: Bloop?
    
    let firebaseAPI = FirebaseAPI()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setAttributes()
        
        //print(selectedPost?.createdBy.username)

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
        
        comments.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Attributes.commentCell, for: indexPath) as! CommentViewCell
        
        // Configure the cell with data
        let comment = comments[indexPath.row]
        cell.commentText.text = comment.text
        cell.userLabel.text = comment.user.username
        
        return cell
    }
    
    func setAttributes(){
        //set features to selectedPost attributes
        photo.image = selectedPost?.images
        clothingLabel.text = selectedPost?.name
        descriptionText.text = selectedPost?.description
        globalPostId = selectedPost?.postID
    }
    
}
