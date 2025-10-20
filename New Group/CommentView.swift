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
        VStack(spacing: 0) {
            // Comments List
            if viewModel.isLoading && viewModel.comments.isEmpty {
                VStack {
                    Spacer()
                    ProgressView()
                        .tint(Colors.styleBlue1)
                        .scaleEffect(1.2)
                    Text("Loading comments...")
                        .foregroundColor(Colors.styleBlue1)
                        .font(.custom("PTSans-Regular", size: 14))
                    Spacer()
                }
            } else if viewModel.comments.isEmpty {
                VStack {
                    Spacer()
                    Text("No comments yet")
                        .font(.custom("PTSans-Bold", size: 18))
                        .foregroundColor(.gray)
                    Text("Be the first to comment!")
                        .font(.custom("PTSans-Regular", size: 14))
                        .foregroundColor(.gray.opacity(0.8))
                    Spacer()
                }
            } else {
                List(viewModel.comments, id: \.commentID) { comment in
                    CommentItemView(comment: comment)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.visible, edges: .all)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                .listStyle(PlainListStyle())
                .background(Color.white)
            }
            
            // Comment Input Section
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    // Comment text field
                    TextField("speak your mind", text: Binding(
                        get: { viewModel.formData.commentText },
                        set: { viewModel.handleAction(.updateCommentText($0)) }
                    ))
                    .font(.custom("PTSans-Regular", size: 15))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(10)
                    .focused($isTextFieldFocused)
                    .onSubmit {
                        if viewModel.canPost {
                            viewModel.handleAction(.postComment)
                            isTextFieldFocused = false
                        }
                    }
                    
                    // Post button
                    Button(action: {
                        viewModel.handleAction(.postComment)
                        isTextFieldFocused = false
                    }) {
                        if viewModel.isPosting {
                            ProgressView()
                                .tint(.white)
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "paperplane")
                                .foregroundColor(.white)
                                .font(.title3)
                        }
                    }
                    .frame(width: 44, height: 44)
                    .disabled(!viewModel.canPost)
                    .opacity(viewModel.canPost ? 1.0 : 0.5)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Colors.styleBlue1)
            }
        }
        .background(Color.white)
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
            }
        }
    }
}

// MARK: - Comment Item View
struct CommentItemView: View {
    let comment: Comment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Username
            Text(comment.user.username)
                .font(.custom("PTSans-Bold", size: 16))
                .foregroundColor(.black)
            
            // Comment text
            Text(comment.text)
                .font(.custom("PTSans-Regular", size: 14))
                .foregroundColor(.black.opacity(0.8))
                .lineLimit(nil)
            
            // Timestamp
            Text(comment.timestamp, style: .relative)
                .font(.custom("PTSans-Regular", size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
    }
}

// MARK: - Navigation Integration
extension CommentView {
    static func create(postId: String) -> some View {
        CommentView(postId: postId)
    }
}

#Preview {
    CommentView(postId: "sample-post-id")
        .environmentObject(NavigationCoordinator())
}