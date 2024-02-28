//
//  CommentViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 2/27/24.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    //load the comments from FireBase here
    //then populate, and then add them to Firebase.
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
   @IBAction func commentTyped(_ sender: UITextField) {
        
    }
    
    @IBAction func postComment(_ sender: UIButton) {
        
        //work on posting comments first through here.
        
        
        //This will post the comment immediately.
        //Should send to Firebase then should be able to see it refreshed on the top of the tableView of this controller
        //should then be able to select it and then delete
        
        
        
    }
    
    //MARK: -- TableView Methods
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentViewCell
        
        return cell
    }

}
