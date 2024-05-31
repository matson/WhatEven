//
//  Constants.swift
//  WhatEven
//
//  Created by Tracy Adams on 2/20/24.
//

import Foundation
import UIKit

struct Constants{
    
    //constants for entire project
    
    struct Segue {
        static let loginSegue = "LoginSuccess"
        static let registerSegue = "RegisterSuccess"
        static let toRegisterSegue = "ToRegister"
        static let toPostSegue = "ToPost"
        static let toDetailsSegue = "ToDetails"
        static let backToHomeSegue = "backToHomeSegue"
    }
    
    struct FStore {
        
        static let collectionNamePost = "post"
        static let collectionNameComment = "comments"
        static let postNameField = "name"
        static let postImageField = "image"
        static let postDescriptionField = "description"
        static let createdByField = "createdBy"
        static let postIDField = "postId"
        static let commentTextField = "commentText"
        static let collectionNameUserDetails = "userDetails"
        static let commentTimestampField = "timestamp"
    }
    
    struct Attributes {
        
        static let feedCell = "FeedCell"
        static let mainStoryboardName = "Main"
        static let commentViewControllerId = "CommentViewController"
        static let commentCell = "CommentCell"
        static let addBloop = "AddBloop"
        static let boldFont = "PTSans-Bold"
        static let regularFont = "PTSans-Regular"
        static let styleBlue1 = UIColor(red: 112/255.0, green: 151/255.0, blue: 250/255.0, alpha: 1.0)
        static let styleBlue2 = UIColor(red: 148/255.0, green: 188/255.0, blue: 255/255.0, alpha: 1.0)
        static let pink1 = UIColor(red: 216/255.0, green: 179/255.0, blue: 250/255.0, alpha: 1.0)
        
    }
    
    
    
    
    
    
}
