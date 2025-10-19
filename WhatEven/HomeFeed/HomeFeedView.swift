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
            // Background color matching UIKit version
            Colors.styleBlue2
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom toolbar
                HStack {
                    Button("Logout") {
                        viewModel.handleAction(.logout)
                    }
                    .foregroundColor(.white)
                    .font(.custom("PTSans-Regular", size: 16))
                    
                    Spacer()
                    
                    Text("WhatEven")
                        .font(.custom("PTSans-Bold", size: 20))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        navigationCoordinator.navigateToCreatePost()
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                }
                .padding()
                .background(Colors.styleBlue2)
                
                // Feed content
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 3) {
                        ForEach(viewModel.feedItems, id: \.id) { feedItem in
                            FeedItemView(
                                feedItem: feedItem,
                                onDelete: { bloop in
                                    selectedPostForDeletion = bloop
                                    viewModel.handleAction(.deletePost(bloop))
                                },
                                onTap: { bloop in
                                    navigationCoordinator.navigateToPostDetails(postId: bloop.postID)
                                }
                            )
                        }
                    }
                    .padding(3)
                }
                
                // Loading indicator
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                        Text("Loading...")
                            .foregroundColor(.white)
                            .font(.custom("PTSans-Regular", size: 14))
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
        ZStack(alignment: .center) {
            // Main content
            VStack(spacing: 2) {
                // Image
                Image(uiImage: feedItem.bloop.images)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: .infinity)
                    .clipped()
                
                // Label
                Text(feedItem.bloop.name)
                    .font(.custom("PTSans-Bold", size: 10))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .frame(height: 20)
            }
            
            // Delete button (only show for user's own posts)
            if feedItem.canDelete {
                Button(action: {
                    onDelete(feedItem.bloop)
                }) {
                    Image(systemName: "trash.circle")
                        .foregroundColor(.white)
                        .font(.title2)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
            }
        }
        .background(Colors.styleBlue2)
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
            // Background color matching UIKit version
            Colors.styleBlue2
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom toolbar
                HStack {
                    Button("Logout") {
                        print("🔄 Logout button tapped")
                        navigationCoordinator.logout()
                    }
                    .foregroundColor(.white)
                    .font(.custom("PTSans-Regular", size: 16))
                    
                    Spacer()
                    
                    Text("WhatEven")
                        .font(.custom("PTSans-Bold", size: 20))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        print("📱 Add post button tapped")
                        navigationCoordinator.navigateToCreatePost()
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                }
                .padding()
                .background(Colors.styleBlue2)
                
                // Feed content
                if viewModel.feedItems.isEmpty && !viewModel.isLoading {
                    VStack {
                        Spacer()
                        Text("No posts yet!")
                            .font(.custom("PTSans-Bold", size: 24))
                            .foregroundColor(.white)
                        Text("Tap + to add your first post")
                            .font(.custom("PTSans-Regular", size: 16))
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 3) {
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
                        .padding(3)
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
                            .font(.custom("PTSans-Regular", size: 14))
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