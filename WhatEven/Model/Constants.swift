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
    }
    
    
    
    
}
