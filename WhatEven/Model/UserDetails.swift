//
//  User.swift
//  WhatEven
//
//  Created by Tracy Adams on 2/21/24.
//

import Foundation
import UIKit
//
//struct UserDetails {
//
//    var username: String?
//    var userEmail: String?
//    //var profileImage: UIImage?
//    var uid: String?
//
//}
struct UserDetails: Equatable {
    var username: String?
    var userEmail: String?
    var uid: String?
    
    static func ==(lhs: UserDetails, rhs: UserDetails) -> Bool {
        return lhs.username == rhs.username &&
            lhs.userEmail == rhs.userEmail &&
            lhs.uid == rhs.uid
    }
}
