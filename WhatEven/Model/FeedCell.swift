//
//  FeedCell.swift
//  WhatEven
//
//  Created by Tracy Adams on 2/21/24.
//

import Foundation
import UIKit

class FeedCell: UICollectionViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var clothingLabel: UILabel!
    
    @IBOutlet weak var delete: UIButton!
    
    var deleteAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clothingLabel.font = UIFont(name: Constants.Attributes.boldFont, size: 12)
        clothingLabel.textColor = .white
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        deleteAction?()
    }
}
