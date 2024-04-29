//
//  CommentViewCell.swift
//  WhatEven
//
//  Created by Tracy Adams on 2/26/24.
//

import Foundation
import UIKit

class CommentViewCell: UITableViewCell {
    
    public let userLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.Attributes.boldFont, size: 10)
        label.textColor = .black
        label.text = "username"
        label.textAlignment = .left
        return label
    }()
    
    public let commentView: UILabel = {
        let textView = UILabel()
           textView.translatesAutoresizingMaskIntoConstraints = false
           textView.font = UIFont(name: Constants.Attributes.boldFont, size: 14) ?? UIFont.systemFont(ofSize: 35)
           textView.textColor = .white
           textView.backgroundColor = .clear
           textView.textAlignment = .left
           textView.text = "comment goes here"
           return textView
    }()
    
    public let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteTap), for: .touchUpInside)
        let mailImage = UIImage(systemName: "trash.circle")
        mailImage?.withTintColor(.white)
        button.setImage(mailImage, for: .normal)
        return button
        
    }()
    
    private let stackView1: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.backgroundColor = Constants.Attributes.styleBlue2
        return stack
        
    }()
    
    private let yellowView: UIView = {
         let view = UIView()
         view.backgroundColor = .clear
         return view
     }()
     
     private let greenView: UIView = {
         let view = UIView()
         view.backgroundColor = .clear
         return view
     }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
          super.setSelected(selected, animated: animated)
          
          // Update the layout of subviews when the cell is selected
          contentView.layoutIfNeeded()
      }
 
    @objc func deleteTap(){
        deleteAction?()
    }
    
    var deleteAction: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        contentView.backgroundColor = .clear
        contentView.addSubview(stackView1)
        
        stackView1.addArrangedSubview(yellowView)
        stackView1.addArrangedSubview(greenView)
        
        yellowView.addSubview(userLabel)
        greenView.addSubview(commentView)
        greenView.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            
            stackView1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView1.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            userLabel.topAnchor.constraint(equalTo: yellowView.topAnchor),
            userLabel.leadingAnchor.constraint(equalTo: stackView1.leadingAnchor),
            userLabel.trailingAnchor.constraint(equalTo: stackView1.trailingAnchor),
            userLabel.heightAnchor.constraint(equalTo: yellowView.heightAnchor, multiplier: 0.75),
  
            commentView.centerYAnchor.constraint(equalTo: greenView.centerYAnchor),
            commentView.leadingAnchor.constraint(equalTo: greenView.leadingAnchor),
            
            deleteButton.centerYAnchor.constraint(equalTo: greenView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: greenView.trailingAnchor)
            
           
        ])

    }
    
}
