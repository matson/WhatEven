//
//  DetailsView.swift
//  WhatEven
//
//  SwiftUI Details View for MVVM architecture
//

import SwiftUI

struct DetailsView: View {
    let postId: String
    @StateObject private var viewModel: DetailsViewModel
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @State private var selectedCommentForDeletion: Comment?
    
    init(postId: String, selectedPost: Bloop) {
        self._viewModel = StateObject(wrappedValue: DetailsViewModel(selectedPost: selectedPost))
        self.postId = postId
    }
    
    var body: some View {
        ZStack {
            // Gradient background matching login/register/homefeed
            LinearGradient(
                colors: [
                    Colors.styleBlue1,
                    Colors.styleBlue1.opacity(0.6),
                    Colors.styleBlue2.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Instagram-style post
                VStack(spacing: 0) {
                    // Post header
                    HStack {
                        HStack(spacing: 12) {
                            // User avatar
                            Circle()
                                .fill(Colors.babyPink.opacity(0.7))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text(String(viewModel.selectedPost.createdBy.username?.first ?? "U"))
                                        .font(.custom("LexendDeca-Bold", size: 16))
                                        .foregroundColor(.white)
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(viewModel.selectedPost.createdBy.username ?? "Unknown User")
                                    .font(.custom("LexendDeca-Medium", size: 16))
                                    .foregroundColor(.white)
                                
                                Text("Reality Check")
                                    .font(.custom("LexendDeca-Regular", size: 12))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        
                        Spacer()
                        
                        // More options
                        Image(systemName: "ellipsis")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    
                    // Full-width image
                    Image("example")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 400)
                        .clipped()
                    
                    // Post interactions (like Instagram)
                    VStack(spacing: 0) {
                        // Action buttons
                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                Image(systemName: "bubble.left")
                                    .font(.system(size: 22, weight: .regular))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                                
                                Text("\(viewModel.comments.count)")
                                    .font(.custom("LexendDeca-Medium", size: 16))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                            }
                            
                            Image(systemName: "heart")
                                .font(.system(size: 22, weight: .regular))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                            
                            Image(systemName: "paperplane")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                            
                            Spacer()
                            
                            Text("👀")
                                .font(.system(size: 20))
                                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        
                        // Post caption with white card background
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(viewModel.selectedPost.name)
                                        .font(.custom("LexendDeca-Bold", size: 16))
                                        .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                                    
                                    Spacer()
                                }
                                
                                HStack {
                                    Text(viewModel.selectedPost.description)
                                        .font(.custom("LexendDeca-Regular", size: 14))
                                        .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55).opacity(0.8))
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                            
                            // View all comments
                            if !viewModel.comments.isEmpty {
                                Button("View all \(viewModel.comments.count) comments") {
                                    navigationCoordinator.navigateToComments(postId: postId)
                                }
                                .font(.custom("LexendDeca-Regular", size: 14))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                            } else {
                                Button("Add a comment...") {
                                    navigationCoordinator.navigateToComments(postId: postId)
                                }
                                .font(.custom("LexendDeca-Regular", size: 14))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 16)
                    }
                }
                    
                // Comments section with white card background
                if !viewModel.comments.isEmpty {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Array(viewModel.comments.prefix(3)), id: \.commentID) { comment in
                                VStack(spacing: 0) {
                                    CommentRowView(
                                        comment: comment,
                                        canDelete: viewModel.canDeleteComment(comment),
                                        onDelete: { comment in
                                            selectedCommentForDeletion = comment
                                            viewModel.handleAction(.deleteComment(comment))
                                        }
                                    )
                                }
                            }
                            
                            if viewModel.comments.count > 3 {
                                Button("View more comments") {
                                    navigationCoordinator.navigateToComments(postId: postId)
                                }
                                .font(.custom("LexendDeca-Regular", size: 14))
                                .foregroundColor(Colors.styleBlue1)
                                .padding(.top, 8)
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 16)
                    }
                } else if viewModel.isLoading {
                    VStack(spacing: 8) {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.2)
                        Text("Loading comments...")
                            .font(.custom("LexendDeca-Regular", size: 14))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.vertical, 24)
                }
                
                Spacer()
            }
            
            // Loading overlay for comment operations
            if viewModel.deleteState != .idle {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.5)
                    Text("Deleting comment...")
                        .foregroundColor(.white)
                        .font(.custom("LexendDeca-Regular", size: 16))
                }
            }
        }
        .refreshable {
            viewModel.handleAction(.refresh)
        }
        .alert("Delete Comment", isPresented: $viewModel.showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                viewModel.resetStates()
            }
            Button("Delete", role: .destructive) {
                if let comment = selectedCommentForDeletion {
                    viewModel.confirmDelete(comment)
                }
            }
        } message: {
            Text("Are you sure you want to delete this comment?")
        }
        .alert("Error", isPresented: $viewModel.showingErrorAlert) {
            Button("OK") {
                viewModel.resetStates()
            }
        } message: {
            Text(viewModel.errorMessage)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Post Details")
        .onAppear {
            print("🎬 DetailsView appeared for post: \(postId)")
        }
    }
}

// MARK: - Comment Row View
struct CommentRowView: View {
    let comment: Comment
    let canDelete: Bool
    let onDelete: (Comment) -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // User avatar
            Circle()
                .fill(Colors.babyPink.opacity(0.7))
                .frame(width: 28, height: 28)
                .overlay(
                    Text(String(comment.user.username?.first ?? "U"))
                        .font(.custom("LexendDeca-Bold", size: 12))
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                // Username and comment text (Instagram style)
                HStack {
                    Text(comment.user.username ?? "Unknown User")
                        .font(.custom("LexendDeca-Medium", size: 14))
                        .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                    
                    Text(comment.text)
                        .font(.custom("LexendDeca-Regular", size: 14))
                        .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55).opacity(0.8))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                
                // Timestamp
                Text(comment.timestamp, style: .relative)
                    .font(.custom("LexendDeca-Regular", size: 12))
                    .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55).opacity(0.6))
            }
            
            // Delete button (only show for user's own comments)
            if canDelete {
                Button(action: {
                    onDelete(comment)
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55).opacity(0.7))
                        .font(.system(size: 12, weight: .medium))
                }
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Navigation Integration
extension DetailsView {
    static func create(postId: String, selectedPost: Bloop) -> some View {
        DetailsView(postId: postId, selectedPost: selectedPost)
    }
}

#Preview {
    // Preview with mock data
    let mockUser = UserDetails(username: "TestUser", userEmail: "test@example.com", uid: "123")
    let mockImage = UIImage(systemName: "photo") ?? UIImage()
    let mockPost = Bloop(
        images: mockImage,
        description: "bought from Amazon, 1 out of 5 stars. awful material. don't believe those fake bot reviews",
        name: "Amazon Marine Green Trousers",
        comments: [],
        createdBy: mockUser,
        postID: "sample-post-id"
    )
    
    return DetailsView(postId: "sample-post-id", selectedPost: mockPost)
        .environmentObject(NavigationCoordinator())
}
