//
//  CommentView.swift
//  WhatEven
//
//  SwiftUI Comment View for MVVM architecture
//

import SwiftUI

struct CommentView: View {
    @StateObject private var viewModel: CommentViewModel
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @FocusState private var isTextFieldFocused: Bool
    
    let postId: String
    
    init(postId: String) {
        self.postId = postId
        self._viewModel = StateObject(wrappedValue: CommentViewModel(postId: postId))
    }
    
    var body: some View {
        ZStack {
            // Gradient background matching other views
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
                // Always show hardcoded comments with card background
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(getHardcodedComments(), id: \.commentID) { comment in
                            CommentItemView(comment: comment)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                            
                            // Divider between comments
                            if comment.commentID != getHardcodedComments().last?.commentID {
                                Divider()
                                    .background(Color(red: 0.4, green: 0.45, blue: 0.55).opacity(0.2))
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.vertical, 16)
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
                
                Spacer()
                
                // Comment Input Section with white card
                VStack(spacing: 0) {
                    VStack(spacing: 12) {
                        HStack {
                            Text("Share Your Thoughts")
                                .font(.custom("LexendDeca-Bold", size: 16))
                                .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                            Spacer()
                        }
                        
                        HStack(spacing: 12) {
                            // Comment text field with consistent styling
                            TextField("What do you think about this?", text: Binding(
                                get: { viewModel.formData.commentText },
                                set: { viewModel.handleAction(.updateCommentText($0)) }
                            ))
                            .font(.custom("LexendDeca-Regular", size: 15))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 20)
                            .frame(height: 45)
                            .background(Color.white)
                            .cornerRadius(22)
                            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                            .focused($isTextFieldFocused)
                            .onSubmit {
                                if viewModel.canPost {
                                    viewModel.handleAction(.postComment)
                                    isTextFieldFocused = false
                                }
                            }
                            
                            // Post button with consistent styling
                            Button(action: {
                                viewModel.handleAction(.postComment)
                                isTextFieldFocused = false
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(viewModel.canPost ? Colors.styleBlue1 : Colors.styleBlue1.opacity(0.6))
                                        .frame(width: 45, height: 45)
                                        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
                                    
                                    if viewModel.isPosting {
                                        ProgressView()
                                            .tint(.white)
                                            .scaleEffect(0.8)
                                    } else {
                                        Image(systemName: "paperplane.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size: 16, weight: .medium))
                                    }
                                }
                            }
                            .disabled(!viewModel.canPost)
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    .background(Color.white.opacity(0.7))
                    .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
                    .ignoresSafeArea(.all, edges: [.leading, .trailing, .bottom])
                }
            }
        }
        .refreshable {
            viewModel.handleAction(.refresh)
        }
        .alert("Error", isPresented: $viewModel.showingErrorAlert) {
            Button("OK") {
                viewModel.resetStates()
            }
        } message: {
            Text(viewModel.errorMessage)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Comments")
        .onAppear {
            print("🎬 CommentView appeared for post: \(postId)")
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isTextFieldFocused = false
                }
                .foregroundColor(Colors.styleBlue1)
                .font(.custom("LexendDeca-Medium", size: 16))
            }
        }
    }
    
    // Hardcoded comments function
    private func getHardcodedComments() -> [Comment] {
        let mockUser1 = UserDetails(username: "Sarah-bubbleGirl1", userEmail: "sarah@example.com", uid: "1")
        let mockUser2 = UserDetails(username: "michelleObama", userEmail: "mike@example.com", uid: "2")
        let mockUser3 = UserDetails(username: "Jessica_k12", userEmail: "jessica@example.com", uid: "3")
        let mockUser4 = UserDetails(username: "TechReviewer99", userEmail: "tech@example.com", uid: "4")
        
        return [
            Comment(
                user: mockUser1,
                postID: postId,
                text: "I bought the same thing! Totally agree - the quality was awful and nothing like the photos.",
                timestamp: Date().addingTimeInterval(-3600),
                commentID: "1"
            ),
            Comment(
                user: mockUser2,
                postID: postId,
                text: "Thanks for the honest review! Almost bought this myself. Saved me money!",
                timestamp: Date().addingTimeInterval(-1800),
                commentID: "2"
            ),
            Comment(
                user: mockUser3,
                postID: postId,
                text: "This is exactly why I love this app. Real reviews from real people! 👏",
                timestamp: Date().addingTimeInterval(-900),
                commentID: "3"
            ),
            Comment(
                user: mockUser4,
                postID: postId,
                text: "Wish I had seen this before ordering! The fabric feels like cheap polyester, not the 'premium cotton blend' they advertised 😤",
                timestamp: Date().addingTimeInterval(-300),
                commentID: "4"
            )
        ]
    }
}

// MARK: - Comment Item View
struct CommentItemView: View {
    let comment: Comment
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // User avatar with varied colors
            Circle()
                .fill(avatarColor(for: comment.user.uid ?? ""))
                .frame(width: 32, height: 32)
                .overlay(
                    Text(String(comment.user.username?.first ?? "U"))
                        .font(.custom("LexendDeca-Bold", size: 14))
                        .foregroundColor(textColor(for: comment.user.uid ?? ""))
                )
            
            VStack(alignment: .leading, spacing: 6) {
                // Username with consistent styling
                Text(comment.user.username ?? "Unknown User")
                    .font(.custom("LexendDeca-Medium", size: 15))
                    .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                
                // Comment text with consistent styling
                Text(comment.text)
                    .font(.custom("LexendDeca-Regular", size: 14))
                    .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55).opacity(0.8))
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                
                // Timestamp with consistent styling
                Text(comment.timestamp, style: .relative)
                    .font(.custom("LexendDeca-Regular", size: 12))
                    .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55).opacity(0.6))
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // Helper function to assign colors based on user ID
    private func avatarColor(for uid: String) -> Color {
        let colors = [Colors.babyPink, Colors.babyBlue, Colors.lavender, Colors.cookieDough.opacity(0.9)]
        let index = abs(uid.hashValue) % colors.count
        return colors[index].opacity(0.7)
    }
    
    // Helper function to assign text colors based on background
    private func textColor(for uid: String) -> Color {
        let index = abs(uid.hashValue) % 4
        // Use lighter bluish gray for cookieDough background, white for others
        return index == 3 ? Color(red: 0.5, green: 0.55, blue: 0.65) : .white
    }
}

// MARK: - Navigation Integration
extension CommentView {
    static func create(postId: String) -> some View {
        CommentView(postId: postId)
    }
}

#Preview {
    // Create a static preview of the UI with mock comments
    let mockUser1 = UserDetails(username: "Sarah-bubbleGirl1", userEmail: "sarah@example.com", uid: "1")
    let mockUser2 = UserDetails(username: "michelleObama", userEmail: "mike@example.com", uid: "2")
    let mockUser3 = UserDetails(username: "Jessica_k12", userEmail: "jessica@example.com", uid: "3")
    let mockUser4 = UserDetails(username: "TechReviewer99", userEmail: "tech@example.com", uid: "4")
    
    let mockComments = [
        Comment(
            user: mockUser1,
            postID: "sample-post-id",
            text: "I bought the same thing! Totally agree - the quality was awful and nothing like the photos.",
            timestamp: Date().addingTimeInterval(-3600),
            commentID: "1"
        ),
        Comment(
            user: mockUser2,
            postID: "sample-post-id", 
            text: "Thanks for the honest review! Almost bought this myself. Saved me money!",
            timestamp: Date().addingTimeInterval(-1800),
            commentID: "2"
        ),
        Comment(
            user: mockUser3,
            postID: "sample-post-id",
            text: "This is exactly why I love this app. Real reviews from real people! 👏",
            timestamp: Date().addingTimeInterval(-900),
            commentID: "3"
        ),
        Comment(
            user: mockUser4,
            postID: "sample-post-id",
            text: "Wish I had seen this before ordering! The fabric feels like cheap polyester, not the 'premium cotton blend' they advertised 😤",
            timestamp: Date().addingTimeInterval(-300),
            commentID: "4"
        )
    ]
    
    // Create static preview UI
    ZStack {
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
            // Comments list with mock data
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(mockComments.enumerated()), id: \.element.commentID) { index, comment in
                        PreviewCommentItemView(comment: comment, colorIndex: index)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                        
                        if comment.commentID != mockComments.last?.commentID {
                            Divider()
                                .background(Color(red: 0.4, green: 0.45, blue: 0.55).opacity(0.2))
                                .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.vertical, 16)
                .background(Color.white.opacity(0.95))
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            
            Spacer()
            
            // Comment input section
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    HStack {
                        Text("Share Your Thoughts")
                            .font(.custom("LexendDeca-Bold", size: 16))
                            .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                        Spacer()
                    }
                    
                    HStack(spacing: 12) {
                        TextField("What do you think about this?", text: .constant(""))
                            .font(.custom("LexendDeca-Regular", size: 15))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 20)
                            .frame(height: 45)
                            .background(Color.white)
                            .cornerRadius(22)
                            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                        
                        Button(action: {}) {
                            ZStack {
                                Circle()
                                    .fill(Colors.styleBlue1)
                                    .frame(width: 45, height: 45)
                                    .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
                                
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium))
                            }
                        }
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 20)
                .background(Color.white.opacity(0.7))
                .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
                .ignoresSafeArea(.all, edges: [.leading, .trailing, .bottom])
            }
        }
    }
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle("Comments")
}

// Preview-only CommentItemView with specific color assignment
struct PreviewCommentItemView: View {
    let comment: Comment
    let colorIndex: Int
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // User avatar with specific color for each user
            Circle()
                .fill(previewAvatarColor(for: colorIndex))
                .frame(width: 32, height: 32)
                .overlay(
                    Text(String(comment.user.username?.first ?? "U"))
                        .font(.custom("LexendDeca-Bold", size: 14))
                        .foregroundColor(previewTextColor(for: colorIndex))
                )
            
            VStack(alignment: .leading, spacing: 6) {
                // Username with consistent styling
                Text(comment.user.username ?? "Unknown User")
                    .font(.custom("LexendDeca-Medium", size: 15))
                    .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                
                // Comment text with consistent styling
                Text(comment.text)
                    .font(.custom("LexendDeca-Regular", size: 14))
                    .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55).opacity(0.8))
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                
                // Timestamp with consistent styling
                Text(comment.timestamp, style: .relative)
                    .font(.custom("LexendDeca-Regular", size: 12))
                    .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55).opacity(0.6))
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // Assign specific colors for preview users
    private func previewAvatarColor(for index: Int) -> Color {
        let colors = [Colors.babyPink.opacity(0.7), Colors.babyBlue.opacity(0.7), Colors.lavender.opacity(0.7), Colors.cookieDough.opacity(0.9)]
        return colors[index % colors.count]
    }
    
    // Assign text colors for preview users
    private func previewTextColor(for index: Int) -> Color {
        // Use lighter bluish gray for cookieDough background (index 3), white for others
        return index == 3 ? Color(red: 0.5, green: 0.55, blue: 0.65) : .white
    }
}

