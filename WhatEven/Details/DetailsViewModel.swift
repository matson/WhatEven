//
//  DetailsViewModel.swift
//  WhatEven
//
//  SwiftUI Details ViewModel for MVVM architecture
//

import Foundation
import SwiftUI
import Firebase

class DetailsViewModel: ObservableObject {
    @Published var detailsState: DetailsState = .idle
    @Published var commentsState: CommentsState = .idle
    @Published var deleteState: CommentDeleteState = .idle
    @Published var showingDeleteAlert = false
    @Published var showingErrorAlert = false
    
    private let firebaseAPI = FirebaseAPI()
    private var currentUserID: String?
    
    let selectedPost: Bloop
    
    var comments: [Comment] {
        switch commentsState {
        case .loaded(let comments):
            return comments
        default:
            return []
        }
    }
    
    var isLoading: Bool {
        commentsState == .loading || deleteState != .idle
    }
    
    var errorMessage: String {
        switch commentsState {
        case .error(let message):
            return message
        default:
            switch deleteState {
            case .failed(let message):
                return message
            default:
                return ""
            }
        }
    }
    
    init(selectedPost: Bloop) {
        self.selectedPost = selectedPost
        getCurrentUser()
        loadComments()
    }
    
    // MARK: - Public Methods
    func handleAction(_ action: DetailsAction) {
        switch action {
        case .loadComments:
            loadComments()
        case .addComment:
            // Handle navigation in the view
            print("📱 Add comment tapped for post: \(selectedPost.postID)")
        case .deleteComment(let comment):
            showDeleteConfirmation(for: comment)
        case .refresh:
            loadComments()
        }
    }
    
    func confirmDelete(_ comment: Comment) {
        deleteComment(comment)
    }
    
    func canDeleteComment(_ comment: Comment) -> Bool {
        return comment.user.uid == currentUserID
    }
    
    // MARK: - Private Methods
    private func getCurrentUser() {
        currentUserID = Auth.auth().currentUser?.uid
        print("👤 Current user UID for details: \(currentUserID ?? "None")")
    }
    
    private func loadComments() {
        print("🔄 Loading comments for post: \(selectedPost.postID)")
        commentsState = .loading
        
        firebaseAPI.getComments(forPostId: selectedPost.postID, completion: { [weak self] comments in
            DispatchQueue.main.async {
                print("✅ Loaded \(comments.count) comments")
                self?.commentsState = .loaded(comments)
            }
        }, errorHandler: { [weak self] error in
            DispatchQueue.main.async {
                print("❌ Failed to load comments: \(error.localizedDescription)")
                self?.commentsState = .error(error.localizedDescription)
                self?.showingErrorAlert = true
            }
        })
    }
    
    private func showDeleteConfirmation(for comment: Comment) {
        print("🗑️ Showing delete confirmation for comment by: \(comment.user.username)")
        showingDeleteAlert = true
    }
    
    private func deleteComment(_ comment: Comment) {
        print("🔄 Deleting comment: \(comment.commentID)")
        deleteState = .deleting(comment.commentID)
        
        firebaseAPI.deleteComment(comment) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    print("✅ Comment deleted successfully")
                    self?.deleteState = .success
                    self?.loadComments() // Reload comments
                } else {
                    print("❌ Failed to delete comment")
                    self?.deleteState = .failed("Failed to delete comment")
                    self?.showingErrorAlert = true
                }
                
                // Reset delete state after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.deleteState = .idle
                }
            }
        }
    }
    
    func resetStates() {
        showingDeleteAlert = false
        showingErrorAlert = false
        if case .error = commentsState {
            commentsState = .idle
        }
        if case .failed = deleteState {
            deleteState = .idle
        }
    }
}