//
//  HomeFeedModel.swift
//  WhatEven
//
//  SwiftUI HomeFeed Model for MVVM architecture
//

import Foundation
import SwiftUI

// MARK: - Feed States
enum FeedState: Equatable {
    case idle
    case loading
    case loaded([Bloop])
    case error(String)
}

enum FeedAction {
    case refresh
    case deletePost(Bloop)
    case selectPost(Bloop)
    case logout
    case addPost
}

// MARK: - Feed Item for SwiftUI
struct FeedItem: Identifiable, Hashable {
    let id = UUID()
    let bloop: Bloop
    let canDelete: Bool
    
    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        return lhs.bloop.postID == rhs.bloop.postID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(bloop.postID)
    }
}

// MARK: - Delete State
enum DeleteState: Equatable {
    case idle
    case deleting(String) // postID being deleted
    case success
    case failed(String)
}