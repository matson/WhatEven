//
//  CommentViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 2/27/24.
//

import UIKit
import Firebase

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    private let postButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(postComment), for: .touchUpInside)
        let mailImage = UIImage(systemName: "paperplane")
        mailImage?.withTintColor(.white)
        button.setImage(mailImage, for: .normal)
        return button
        
    }()
    
    private let commentField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont(name: Constants.Attributes.regularFont, size: 15)
        field.backgroundColor = .white
        field.placeholder = "speak your mind"
        field.layer.cornerRadius = 10
        return field
    }()
    
    
    private let stackView1: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = Constants.Attributes.styleBlue1
        return stack
        
    }()
    
    var receivedPostId: String?
    
    var uid: String?
    
    var commentsReceived: [Comment] = []
    
    let firebaseAPI = FirebaseAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        commentField.delegate = self
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        
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
        
        setUpTableView()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    //Post Action
    @objc func postComment(){
        
        let finalCommentText = commentField.text ?? ""
        
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
        postButton.isEnabled = false
        
        // Refresh the table view
        tableView.reloadData()
        
        // Reset the text field
        commentField.text = ""
        
        
    }
    
    
    //MARK: Helper Functions
    
    @objc func commentTextChanged() {
        // Enable the post button only if the comment text field is not empty
        postButton.isEnabled = !commentField.text!.isEmpty
    }
    
    func setButton(){
        // Set up the initial state of the post button
        postButton.isEnabled = false
        
        // Add a target to the comment text field to detect changes in its text
        commentField.addTarget(self, action: #selector(commentTextChanged), for: .editingChanged)
        
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
        cell.commentView.text = comment.text
        cell.userLabel.text = comment.user.username
        
        return cell
    }
    
    //MARK: Constraints
    func setUpTableView(){
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView1)
        stackView1.addSubview(commentField)
        stackView1.addSubview(postButton)
        
       
        NSLayoutConstraint.activate([
            
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -75),
            
            stackView1.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            stackView1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView1.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView1.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            commentField.topAnchor.constraint(equalTo: stackView1.topAnchor, constant: 20),
            commentField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            commentField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60),
            commentField.heightAnchor.constraint(equalTo: stackView1.heightAnchor, multiplier: 0.50),
            
            postButton.topAnchor.constraint(equalTo: stackView1.topAnchor, constant: 20),
            postButton.leadingAnchor.constraint(equalTo: commentField.trailingAnchor, constant: 10),
            postButton.trailingAnchor.constraint(equalTo: stackView1.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            postButton.heightAnchor.constraint(equalTo: stackView1.heightAnchor, multiplier: 0.50),
            
        ])
    }
    
    //MARK: -- Keyboard Functionality
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo,
               let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
               let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
             return
         }
         
         let keyboardHeight = keyboardFrame.height
         let animationCurve = UIView.AnimationCurve(rawValue: userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
         let animationOptions = UIView.AnimationOptions(rawValue: UInt(animationCurve.rawValue << 16))
         
         if keyboardFrame.origin.y < view.frame.maxY {
             // Keyboard is appearing
             let yOffset = keyboardHeight - (commentField.frame.height + postButton.frame.height) + 65
             UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
                 self.view.frame.origin.y = -yOffset
             }, completion: nil)
         } else {
             // Keyboard is disappearing
             UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
                 self.view.frame.origin.y = 0
             }, completion: nil)
         }
    }
    
    //to dismiss Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
