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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        commentText.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = Constants.Attributes.styleBlue1
        
        // Add your constraints here
        NSLayoutConstraint.activate([
            
            userLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            userLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            userLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -31),
            userLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -236),
            userLabel.heightAnchor.constraint(equalToConstant: 13),
            
            commentText.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: -4),
            commentText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            commentText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            commentText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            commentText.heightAnchor.constraint(equalToConstant: 17.33)
            
            
            
            
        ])
        
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        
        deleteAction?()
    }
    
}
