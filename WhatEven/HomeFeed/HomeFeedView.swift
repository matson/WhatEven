//
//  HomeFeedView.swift
//  WhatEven
//
//  SwiftUI HomeFeed View for MVVM architecture
//

import SwiftUI

struct HomeFeedView: View {
    @StateObject private var viewModel = HomeFeedViewModel()
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @State private var selectedPostForDeletion: Bloop?
    
    let columns = [
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3)
    ]
    
    var body: some View {
        ZStack {
            // Gradient background matching login/register
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
                // Custom toolbar
                HStack {
                    Button("Logout") {
                        viewModel.handleAction(.logout)
                    }
                    .foregroundColor(.white)
                    .font(.custom("LexendDeca-Regular", size: 16))
                    
                    Spacer()
                    
                    Text("WhatEven")
                        .font(.custom("LexendDeca-Bold", size: 22))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 1)
                    
                    Spacer()
                    
                    Button(action: {
                        navigationCoordinator.navigateToCreatePost()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    }
                }
                .padding()
                
                // Feed content
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.feedItems, id: \.id) { feedItem in
                            FeedItemView(
                                feedItem: feedItem,
                                onDelete: { bloop in
                                    selectedPostForDeletion = bloop
                                    viewModel.handleAction(.deletePost(bloop))
                                },
                                onTap: { bloop in
                                    navigationCoordinator.navigateToPostDetails(postId: bloop.postID, selectedPost: bloop)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
                
                // Loading indicator
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                        Text("Loading...")
                            .foregroundColor(.white)
                            .font(.custom("LexendDeca-Regular", size: 14))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .refreshable {
            viewModel.handleAction(.refresh)
        }
        .alert("Delete Post", isPresented: $viewModel.showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                viewModel.resetStates()
            }
            Button("Delete", role: .destructive) {
                if let post = selectedPostForDeletion {
                    viewModel.confirmDelete(post)
                }
            }
        } message: {
            Text("Are you sure you want to delete this post?")
        }
        .alert("Error", isPresented: $viewModel.showingErrorAlert) {
            Button("OK") {
                viewModel.resetStates()
            }
        } message: {
            Text(viewModel.errorMessage)
        }
        .onChange(of: viewModel.feedState) { state in
            // Handle logout navigation
            if case .error(let message) = state, message.contains("logout") {
                navigationCoordinator.logout()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            print("🎬 HomeFeedView appeared")
        }
    }
}

// MARK: - Feed Item View
struct FeedItemView: View {
    let feedItem: FeedItem
    let onDelete: (Bloop) -> Void
    let onTap: (Bloop) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Post card
            VStack(spacing: 12) {
                // Header with username and delete button
                HStack {
                    HStack(spacing: 8) {
                        // User avatar placeholder
                        Circle()
                            .fill(Colors.babyPink.opacity(0.7))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Text(String(feedItem.bloop.createdBy.username?.first ?? "U"))
                                    .font(.custom("LexendDeca-Bold", size: 14))
                                    .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                            )
                        
                        Text(feedItem.bloop.createdBy.username ?? "Unknown User")
                            .font(.custom("LexendDeca-Medium", size: 16))
                            .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                    }
                    
                    Spacer()
                    
                    // Delete button (only show for user's own posts)
                    if feedItem.canDelete {
                        Button(action: {
                            onDelete(feedItem.bloop)
                        }) {
                            Image(systemName: "ellipsis")
                                .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55).opacity(0.7))
                                .font(.system(size: 16, weight: .medium))
                        }
                    }
                }
                
                // Image
                Image(uiImage: feedItem.bloop.images)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                    .clipped()
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                // Post content
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(feedItem.bloop.name)
                            .font(.custom("LexendDeca-Bold", size: 16))
                            .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text(feedItem.bloop.description)
                            .font(.custom("LexendDeca-Regular", size: 14))
                            .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55).opacity(0.8))
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    
                    // Engagement section
                    HStack(spacing: 16) {
                        // Comments indicator
                        HStack(spacing: 4) {
                            Image(systemName: "bubble.left")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Colors.babyPink)
                            
                            Text("\(feedItem.bloop.comments.count)")
                                .font(.custom("LexendDeca-Regular", size: 12))
                                .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55).opacity(0.7))
                        }
                        
                        Spacer()
                        
                        // Reality check emoji
                        Text("👀")
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        }
        .onTapGesture {
            onTap(feedItem.bloop)
        }
    }
}

// MARK: - Navigation Integration
extension HomeFeedView {
    static func withNavigation() -> some View {
        NavigationAwareHomeFeedView()
    }
}

struct NavigationAwareHomeFeedView: View {
    @StateObject private var viewModel = HomeFeedViewModel()
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @State private var selectedPostForDeletion: Bloop?
    
    let columns = [
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3)
    ]
    
    var body: some View {
        ZStack {
            // Gradient background matching login/register
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
                // Custom toolbar
                HStack {
                    Button("Logout") {
                        print("🔄 Logout button tapped")
                        navigationCoordinator.logout()
                    }
                    .foregroundColor(.white)
                    .font(.custom("LexendDeca-Regular", size: 16))
                    
                    Spacer()
                    
                    Text("WhatEven")
                        .font(.custom("LexendDeca-Bold", size: 22))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 1)
                    
                    Spacer()
                    
                    Button(action: {
                        print("📱 Add post button tapped")
                        navigationCoordinator.navigateToCreatePost()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    }
                }
                .padding()
                
                // Feed content
                if viewModel.feedItems.isEmpty && !viewModel.isLoading {
                    VStack {
                        Spacer()
                        Text("No Reality Checks Yet!")
                            .font(.custom("LexendDeca-Bold", size: 24))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                        Text("Tap + to share your first truth")
                            .font(.custom("LexendDeca-Regular", size: 16))
                            .foregroundColor(.white.opacity(0.9))
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.feedItems, id: \.id) { feedItem in
                                FeedItemView(
                                    feedItem: feedItem,
                                    onDelete: { bloop in
                                        selectedPostForDeletion = bloop
                                        viewModel.handleAction(.deletePost(bloop))
                                    },
                                    onTap: { bloop in
                                        print("📱 Navigating to post details: \(bloop.postID)")
                                        navigationCoordinator.navigateToPostDetails(postId: bloop.postID, selectedPost: bloop)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                }
                
                // Loading indicator
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                        Text("Loading...")
                            .foregroundColor(.white)
                            .font(.custom("LexendDeca-Regular", size: 14))
                    }
                    .padding()
                }
            }
        }
        .refreshable {
            viewModel.handleAction(.refresh)
        }
        .alert("Delete Post", isPresented: $viewModel.showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                viewModel.resetStates()
            }
            Button("Delete", role: .destructive) {
                if let post = selectedPostForDeletion {
                    viewModel.confirmDelete(post)
                }
            }
        } message: {
            Text("Are you sure you want to delete this post?")
        }
        .alert("Error", isPresented: $viewModel.showingErrorAlert) {
            Button("OK") {
                viewModel.resetStates()
            }
        } message: {
            Text(viewModel.errorMessage)
        }
        .navigationBarHidden(true)
        .onAppear {
            print("🎬 NavigationAwareHomeFeedView appeared")
        }
    }
}

#Preview {
    NavigationAwareHomeFeedView()
        .environmentObject(NavigationCoordinator())
}