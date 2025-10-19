//
//  HomeFeedViewModel.swift
//  WhatEven
//
//  SwiftUI HomeFeed ViewModel for MVVM architecture
//

import Foundation
import SwiftUI
import Firebase

class HomeFeedViewModel: ObservableObject {
    @Published var feedState: FeedState = .idle
    @Published var deleteState: DeleteState = .idle
    @Published var showingDeleteAlert = false
    @Published var showingErrorAlert = false
    
    private let firebaseAPI = FirebaseAPI()
    private var currentUser: User?
    
    var feedItems: [FeedItem] {
        switch feedState {
        case .loaded(let bloops):
            return bloops.map { bloop in
                let canDelete = currentUser?.uid == bloop.createdBy.uid
                return FeedItem(bloop: bloop, canDelete: canDelete)
            }
        default:
            return []
        }
    }
    
    var isLoading: Bool {
        feedState == .loading || deleteState != .idle
    }
    
    var errorMessage: String {
        switch feedState {
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
    
    init() {
        getCurrentUser()
        loadFeed()
    }
    
    // MARK: - Public Methods
    func handleAction(_ action: FeedAction) {
        switch action {
        case .refresh:
            loadFeed()
        case .deletePost(let bloop):
            showDeleteConfirmation(for: bloop)
        case .selectPost(let bloop):
            // Handle navigation in the view
            print("📱 Selected post: \(bloop.name)")
        case .logout:
            logout()
        case .addPost:
            // Handle navigation in the view
            print("📱 Add post tapped")
        }
    }
    
    func confirmDelete(_ bloop: Bloop) {
        deletePost(bloop)
    }
    
    // MARK: - Private Methods
    private func getCurrentUser() {
        currentUser = Auth.auth().currentUser
        print("👤 Current user UID: \(currentUser?.uid ?? "None")")
    }
    
    private func loadFeed() {
        print("🔄 Loading feed...")
        feedState = .loading
        
        firebaseAPI.getPosts(completion: { [weak self] bloops in
            DispatchQueue.main.async {
                print("✅ Loaded \(bloops.count) posts")
                self?.feedState = .loaded(bloops)
            }
        }, errorHandler: { [weak self] error in
            DispatchQueue.main.async {
                print("❌ Failed to load feed: \(error.localizedDescription)")
                self?.feedState = .error(error.localizedDescription)
                self?.showingErrorAlert = true
            }
        })
    }
    
    private func showDeleteConfirmation(for bloop: Bloop) {
        print("🗑️ Showing delete confirmation for: \(bloop.name)")
        showingDeleteAlert = true
    }
    
    private func deletePost(_ bloop: Bloop) {
        print("🔄 Deleting post: \(bloop.name)")
        deleteState = .deleting(bloop.postID)
        
        firebaseAPI.deletePost(bloop) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    print("✅ Post deleted successfully")
                    self?.deleteState = .success
                    self?.loadFeed() // Reload the feed
                } else {
                    print("❌ Failed to delete post")
                    self?.deleteState = .failed("Failed to delete post")
                    self?.showingErrorAlert = true
                }
                
                // Reset delete state after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.deleteState = .idle
                }
            }
        }
    }
    
    private func logout() {
        print("🔄 Logging out...")
        do {
            try Auth.auth().signOut()
            print("✅ Logout successful")
            // Navigation will be handled in the view
        } catch let error {
            print("❌ Logout failed: \(error.localizedDescription)")
            feedState = .error("Failed to logout: \(error.localizedDescription)")
            showingErrorAlert = true
        }
    }
    
    func resetStates() {
        showingDeleteAlert = false
        showingErrorAlert = false
        if case .error = feedState {
            feedState = .idle
        }
        if case .failed = deleteState {
            deleteState = .idle
        }
    }
}