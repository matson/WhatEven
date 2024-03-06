//
//  Constants.swift
//  WhatEven
//
//  Created by Tracy Adams on 2/20/24.
//

import Foundation

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

        
    }
    
    
    
    
    
    
}
