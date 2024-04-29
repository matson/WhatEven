//
//  Comment.swift
//  WhatEven
//
//  Created by Tracy Adams on 2/23/24.
//

import Foundation
import UIKit

struct Comment: Equatable {
    var user: UserDetails
    var postID: String
    var text: String
    var timestamp: Date
    var commentID: String
    
    static func ==(lhs: Comment, rhs: Comment) -> Bool {
        return lhs.user == rhs.user &&
            lhs.postID == rhs.postID &&
            lhs.text == rhs.text &&
            lhs.timestamp == rhs.timestamp &&
            lhs.commentID == rhs.commentID
    }
}
