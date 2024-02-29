//
//  BodyViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 1/22/24.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //reload data here first
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var clothingLabel: UILabel!
    
    @IBOutlet weak var descriptionText: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var comments: [Comment] = []
    
    private let mainStoryboardName = "Main"
    private let commentViewControllerID = "CommentViewController"
    
    var selectedPost: Bloop?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //set features to selectedPost attributes
        photo.image = selectedPost?.images
        clothingLabel.text = selectedPost?.name
        descriptionText.text = selectedPost?.description
        comments = selectedPost!.comments
    }
    
    
    @IBAction func add(_ sender: UIButton) {
        
        //access postID through comment:
        let postID = selectedPost?.postID
            
        //to CommentViewController
        let storyBoard: UIStoryboard = UIStoryboard(name: mainStoryboardName, bundle: nil)
        guard let commentVC = storyBoard.instantiateViewController(withIdentifier: commentViewControllerID) as? CommentViewController else { return }
        commentVC.receivedPostID = postID
        commentVC.modalPresentationStyle = .fullScreen
        commentVC.modalTransitionStyle = .crossDissolve
        //need to send the postID through here. 
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
    //MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        comments.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentViewCell
        
        // Configure the cell with data
        let comment = comments[indexPath.row]
        cell.commentText.text = comment.text
        cell.userLabel.text = comment.user
        
        return cell
    }
    
    
    
}
