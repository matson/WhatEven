//
//  CommentViewModel.swift
//  WhatEven
//
//  SwiftUI Comment ViewModel for MVVM architecture
//

import Foundation
import SwiftUI
import Firebase

class CommentViewModel: ObservableObject {
    @Published var commentViewState: CommentViewState = .idle
    @Published var postCommentState: PostCommentState = .idle
    @Published var formData = CommentFormData()
    @Published var showingErrorAlert = false
    
    private let firebaseAPI = FirebaseAPI()
    private var currentUserID: String?
    
    let postId: String
    
    var comments: [Comment] {
        switch commentViewState {
        case .loaded(let comments):
            return comments
        default:
            return []
        }
    }
    
    var isLoading: Bool {
        commentViewState == .loading
    }
    
    var isPosting: Bool {
        postCommentState == .posting
    }
    
    var canPost: Bool {
        formData.canPost && !isPosting
    }
    
    var errorMessage: String {
        switch commentViewState {
        case .error(let message):
            return message
        default:
            switch postCommentState {
            case .error(let message):
                return message
            default:
                return ""
            }
        }
    }
    
    init(postId: String) {
        self.postId = postId
        getCurrentUser()
        loadComments()
    }
    
    // MARK: - Public Methods
    func handleAction(_ action: CommentAction) {
        switch action {
        case .loadComments:
            loadComments()
        case .updateCommentText(let text):
            formData.commentText = text
        case .postComment:
            postComment()
        case .refresh:
            loadComments()
        case .reset:
            resetState()
        }
    }
    
    // MARK: - Private Methods
    private func getCurrentUser() {
        currentUserID = Auth.auth().currentUser?.uid
        print("👤 Current user UID for comments: \(currentUserID ?? "None")")
    }
    
    private func loadComments() {
        print("🔄 Loading comments for post: \(postId)")
        commentViewState = .loading
        
        firebaseAPI.getComments(forPostId: postId, completion: { [weak self] comments in
            DispatchQueue.main.async {
                print("✅ Loaded \(comments.count) comments")
                self?.commentViewState = .loaded(comments)
            }
        }, errorHandler: { [weak self] error in
            DispatchQueue.main.async {
                print("❌ Failed to load comments: \(error.localizedDescription)")
                self?.commentViewState = .error(error.localizedDescription)
                self?.showingErrorAlert = true
            }
        })
    }
    
    private func postComment() {
        guard let uid = currentUserID else {
            postCommentState = .error("User not authenticated")
            showingErrorAlert = true
            return
        }
        
        let commentText = formData.commentText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !commentText.isEmpty else {
            postCommentState = .error("Comment cannot be empty")
            showingErrorAlert = true
            return
        }
        
        print("🔄 Posting comment...")
        print("📝 Comment: \(commentText.prefix(50))...")
        
        postCommentState = .posting
        let timestamp = Date().timeIntervalSince1970
        
        firebaseAPI.postCommentToFirestore(
            commentText: commentText,
            uid: uid,
            receivedPostId: postId,
            timestamp: timestamp
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("✅ Comment posted successfully!")
                    self?.postCommentState = .success
                    self?.formData.commentText = "" // Clear the text field
                    self?.loadComments() // Reload comments to show new one
                case .failure(let error):
                    print("❌ Failed to post comment: \(error.localizedDescription)")
                    self?.postCommentState = .error(error.localizedDescription)
                    self?.showingErrorAlert = true
                }
                
                // Reset posting state after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if case .success = self?.postCommentState {
                        self?.postCommentState = .idle
                    }
                }
            }
        }
    }
    
    private func resetState() {
        print("🔄 Resetting comment state")
        commentViewState = .idle
        postCommentState = .idle
        formData = CommentFormData()
        showingErrorAlert = false
    }
    
    func resetStates() {
        showingErrorAlert = false
        if case .error = commentViewState {
            commentViewState = .idle
        }
        if case .error = postCommentState {
            postCommentState = .idle
        }
    }
}