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
        GeometryReader { geometry in
            ZStack {
                // Background matching UIKit version
                Colors.styleBlue1
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Image section (45% of height)
                    VStack {
                        Image(uiImage: viewModel.selectedPost.images)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                    }
                    .frame(height: geometry.size.height * 0.45)
                    
                    // Info section (10% of height)
                    VStack(spacing: 4) {
                        // Title
                        HStack {
                            Text(viewModel.selectedPost.name)
                                .font(.custom("PTSans-Bold", size: 20))
                                .foregroundColor(.white)
                                .textAlignment(.leading)
                            Spacer()
                        }
                        
                        // Description
                        HStack {
                            Text(viewModel.selectedPost.description)
                                .font(.custom("PTSans-Bold", size: 10))
                                .foregroundColor(.white)
                                .textAlignment(.leading)
                                .lineLimit(3)
                            Spacer()
                        }
                        
                        // Add comment button
                        HStack {
                            Button("add a comment") {
                                navigationCoordinator.navigateToComments(postId: postId)
                            }
                            .font(.custom("PTSans-Regular", size: 15))
                            .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: geometry.size.height * 0.10)
                    
                    // Comments section (remaining height)
                    VStack {
                        if viewModel.isLoading && viewModel.comments.isEmpty {
                            VStack {
                                ProgressView()
                                    .tint(.white)
                                    .scaleEffect(1.2)
                                Text("Loading comments...")
                                    .foregroundColor(.white)
                                    .font(.custom("PTSans-Regular", size: 14))
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if viewModel.comments.isEmpty {
                            VStack {
                                Text("No comments yet")
                                    .font(.custom("PTSans-Bold", size: 16))
                                    .foregroundColor(.white)
                                Text("Be the first to add a comment!")
                                    .font(.custom("PTSans-Regular", size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            List(viewModel.comments, id: \.commentID) { comment in
                                CommentRowView(
                                    comment: comment,
                                    canDelete: viewModel.canDeleteComment(comment),
                                    onDelete: { comment in
                                        selectedCommentForDeletion = comment
                                        viewModel.handleAction(.deleteComment(comment))
                                    }
                                )
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.visible, edges: .all)
                            }
                            .listStyle(PlainListStyle())
                            .background(Color.clear)
                        }
                    }
                    .frame(maxHeight: .infinity)
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
                            .font(.custom("PTSans-Regular", size: 16))
                    }
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
            VStack(alignment: .leading, spacing: 4) {
                // Username
                Text(comment.user.username)
                    .font(.custom("PTSans-Bold", size: 14))
                    .foregroundColor(.white)
                
                // Comment text
                Text(comment.text)
                    .font(.custom("PTSans-Regular", size: 12))
                    .foregroundColor(.white.opacity(0.9))
                
                // Timestamp
                Text(comment.timestamp, style: .relative)
                    .font(.custom("PTSans-Regular", size: 10))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            // Delete button (only show for user's own comments)
            if canDelete {
                Button(action: {
                    onDelete(comment)
                }) {
                    Image(systemName: "trash.circle")
                        .foregroundColor(.white)
                        .font(.title3)
                }
            }
        }
        .padding(.vertical, 8)
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
        description: "Sample description for preview",
        name: "Sample Post",
        comments: [],
        createdBy: mockUser,
        postID: "sample-post-id"
    )
    
    return DetailsView(postId: "sample-post-id", selectedPost: mockPost)
        .environmentObject(NavigationCoordinator())
}