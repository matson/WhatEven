//
//  FeedCell.swift
//  WhatEven
//
//  Created by Tracy Adams on 2/21/24.
//

import Foundation
import UIKit

class FeedCell: UICollectionViewCell {
    
    //MARK: UI Elements
    
    public let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .clear
        return image
    }()
    
    public let clothingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.Attributes.boldFont, size: 10)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    
    public let deleteButtonFeed: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteTap), for: .touchUpInside)
        let mailImage = UIImage(systemName: "trash.circle")
        button.tintColor = UIColor.white
        button.setImage(mailImage, for: .normal)
        return button
        
    }()
    
    
    // Override the initializer method
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = Constants.Attributes.styleBlue2
        setUpCellLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUpCellLayout()
        //not sure what this is for
        
    }
   
    @objc func deleteTap() {
        deleteAction?()
    }
    
    var deleteAction: (() -> Void)?

    
    func setUpCellLayout(){
        
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButtonFeed)
        contentView.addSubview(clothingLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            deleteButtonFeed.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            deleteButtonFeed.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            clothingLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
            clothingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            clothingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            clothingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
        
        
        
        
    }
    
}
