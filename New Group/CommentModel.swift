//
//  CommentModel.swift
//  WhatEven
//
//  SwiftUI Comment Model for MVVM architecture
//

import Foundation
import SwiftUI

// MARK: - Comment States
enum CommentViewState: Equatable {
    case idle
    case loading
    case loaded([Comment])
    case error(String)
}

// MARK: - Post Comment State
enum PostCommentState: Equatable {
    case idle
    case posting
    case success
    case error(String)
}

// MARK: - Comment Form Data
struct CommentFormData {
    var commentText: String = ""
    
    var canPost: Bool {
        return !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

// MARK: - Comment Actions
enum CommentAction {
    case loadComments
    case updateCommentText(String)
    case postComment
    case refresh
    case reset
}