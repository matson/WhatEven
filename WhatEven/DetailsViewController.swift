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
    
    private let imageSelectedUI: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
        
    }()
    
    private let stackView1: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .clear
        return stack
        
    }()
    
    private let stackView2: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.backgroundColor = .clear
        return stack
        
    }()
    
    private let clothingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.Attributes.boldFont, size: 20)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let addComment: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(add), for: .touchUpInside)
        button.setTitle("add a comment", for: .normal)
        let buttonFont = UIFont(name: Constants.Attributes.regularFont, size: 15)
        let buttonColor = UIColor.white
        button.titleLabel?.font = buttonFont
        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonColor, for: .highlighted)
        button.setTitleColor(buttonColor, for: .disabled)
        button.setTitleColor(buttonColor, for: .selected)
        return button
        
    }()
    
    private let descriptionText: UITextView = {
        let textView = UITextView()
           textView.translatesAutoresizingMaskIntoConstraints = false
           textView.font = UIFont(name: Constants.Attributes.boldFont, size: 10) ?? UIFont.systemFont(ofSize: 10)
           textView.textColor = .white
           textView.backgroundColor = .clear
           textView.textAlignment = .left
           return textView
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.color = .blue
        return activity
    }()
   
    
    
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
        firebaseAPI.getComments(forPostId: selectedPost!.postID, completion: { comments in
            self.comments = comments // Assign the separate comments array to the commentsReceived array
            self.tableView.reloadData()
            
        }, errorHandler: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setAttributes()
        setUpConstraints()
        
        //get comments
        firebaseAPI.getComments(forPostId: selectedPost!.postID, completion: {comments in
            self.comments = comments // Assign the separate comments array to the commentsReceived array
            self.tableView.reloadData()
        }, errorHandler: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        })
        
        
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
        firebaseAPI.getComments(forPostId: selectedPost!.postID, completion: { comments in
            self.comments = comments // Assign the separate comments array to the commentsReceived array
 
        }, errorHandler: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        })
        
        return comments.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Attributes.commentCell, for: indexPath) as! CommentViewCell
        
        
        // Configure the cell with data
        let comment = comments[indexPath.row]
        cell.commentView.text = comment.text
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
        imageSelectedUI.image = selectedPost?.images
        clothingLabel.text = selectedPost?.name
        descriptionText.text = selectedPost?.description
        globalPostId = selectedPost?.postID
    }
    
    func updateDeleteButtonVisibility(for cell: CommentViewCell, with comment: Comment, loggedInUserID: String) {
        if comment.user.uid == loggedInUserID {
            // Show the delete button
            cell.deleteButton.isHidden = false
        } else {
            // Hide the delete button
            cell.deleteButton.isHidden = true
        }
    }
    
    //indicator
    func deleteComment(at indexPath: IndexPath) {
        
        print("deleting comment")
        
        indicator.startAnimating()
        
        let comment = comments[indexPath.row]
        
        // Delete the comment from Firestore
        firebaseAPI.deleteComment(comment) { [weak self] success in
            if success {
                // Delete the comment from the local array
                self?.comments.remove(at: indexPath.row)
                
                // Delete the comment from the table view
                self?.tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                let alert = UIAlertController(title: "Error", message: "Failed to delete comment", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
            
            self?.indicator.stopAnimating() // Stop animating the indicator
        }
    }
    
}

extension DetailsViewController {
    
    //MARK: -- Constraints
    
    func setUpConstraints() {
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        view.backgroundColor = Constants.Attributes.styleBlue1
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView1)
        view.addSubview(stackView2)
        view.addSubview(indicator)
        stackView1.addArrangedSubview(imageSelectedUI)
        
        stackView2.addArrangedSubview(clothingLabel)
        stackView2.addArrangedSubview(descriptionText)
        stackView2.addArrangedSubview(addComment)
        
        // Add your NS constraints logic here
        NSLayoutConstraint.activate([
            
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            stackView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView1.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView1.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),
            
            stackView2.topAnchor.constraint(equalTo: stackView1.bottomAnchor),
            stackView2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView2.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
        
            //tableView
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: stackView2.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            //tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20),

        ])
    }
}
