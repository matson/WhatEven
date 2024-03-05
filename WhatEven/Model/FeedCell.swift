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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clothingLabel.font = UIFont(name: "PTSans-Bold", size: 12)
    }
    
}
