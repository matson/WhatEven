//
//  Post.swift
//  WhatEven
//
//  Created by Tracy Adams on 2/21/24.
//

import Foundation

//this serves as a custom object to store pictures and descriptions
//A user can post a Bloop to critique an artical of clothing purchased

import UIKit

struct Bloop: Equatable {
    var images: UIImage
    var description: String
    var name: String
    var comments: [Comment]
    var createdBy: UserDetails
    var postID: String
    
    static func ==(lhs: Bloop, rhs: Bloop) -> Bool {
        return lhs.images == rhs.images &&
            lhs.description == rhs.description &&
            lhs.name == rhs.name &&
            lhs.comments == rhs.comments &&
            lhs.createdBy == rhs.createdBy &&
            lhs.postID == rhs.postID
    }
}
