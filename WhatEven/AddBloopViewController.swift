//
//  AddBloopViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 1/22/24.
//

import Foundation
import UIKit

class AddBloopViewController: UIViewController {
    
    var imageSelected: UIImage?
    
    @IBOutlet weak var imageSelectedUI: UIImageView!
    
    @IBOutlet weak var itemName: UITextField!
   
    
    @IBOutlet weak var itemDescription: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        
        //keyboard code:
        super.viewWillAppear(animated)
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for testing:
        //let imageEx = UIImage(named: "Online5")
        
        print(imageSelected)
        imageSelectedUI.image = imageSelected

    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        
        //posts to Firebase
        
    }
    
    
    
}
