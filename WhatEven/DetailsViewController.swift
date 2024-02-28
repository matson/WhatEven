//
//  BodyViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 1/22/24.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var clothingLabel: UILabel!
    
    @IBOutlet weak var descriptionText: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var comments: [Comment] = []
    
    
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
        
        //CommentViewController?
        let commentVC = CommentViewController()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentViewCell
        
        // Configure the cell with data
        let comment = comments[indexPath.row]
        cell.commentText.text = comment.text
        cell.userLabel.text = comment.user
        
        return cell
    }
    
    
    
}
