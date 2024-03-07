//
//  CommentViewCell.swift
//  WhatEven
//
//  Created by Tracy Adams on 2/26/24.
//

import Foundation
import UIKit

class CommentViewCell: UITableViewCell {
    
    @IBOutlet weak var commentText: UILabel!
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var delete: UIButton!
    
    var deleteAction: (() -> Void)?

    @IBAction func deleteAction(_ sender: UIButton) {
        
        deleteAction?()
    }
    
}
