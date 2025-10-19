//
//  DetailsModel.swift
//  WhatEven
//
//  SwiftUI Details Model for MVVM architecture
//

import Foundation
import SwiftUI

// MARK: - Details States
enum DetailsState: Equatable {
    case idle
    case loading
    case loaded(PostDetails)
    case error(String)
}

// MARK: - Comments States  
enum CommentsState: Equatable {
    case idle
    case loading
    case loaded([Comment])
    case error(String)
}

// MARK: - Comment Delete State
enum CommentDeleteState: Equatable {
    case idle
    case deleting(String) // commentID being deleted
    case success
    case failed(String)
}

// MARK: - Post Details Data
struct PostDetails {
    let bloop: Bloop
    let comments: [Comment]
    let currentUserID: String
    
    var canDeleteComments: [String: Bool] {
        var canDelete: [String: Bool] = [:]
        for comment in comments {
            canDelete[comment.commentID] = comment.user.uid == currentUserID
        }
        return canDelete
    }
}

// MARK: - Details Actions
enum DetailsAction {
    case loadComments
    case addComment
    case deleteComment(Comment)
    case refresh
}