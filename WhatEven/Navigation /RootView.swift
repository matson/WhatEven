//
//  RootView.swift
//  WhatEven
//
//  Root view that manages the entire app navigation flow
//

import SwiftUI

struct RootView: View {
    @StateObject private var navigationCoordinator = NavigationCoordinator()
    
    var body: some View {
        Group {
            switch navigationCoordinator.appState {
            case .launching:
                LaunchView()
            case .unauthenticated:
                AuthenticationFlow()
            case .authenticated:
                MainAppFlow()
            }
        }
        .environmentObject(navigationCoordinator)
        .onAppear {
            navigationCoordinator.checkAuthenticationStatus()
        }
    }
}

// MARK: - Launch Screen
struct LaunchView: View {
    var body: some View {
        ZStack {
            Colors.styleBlue1
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("WhatEven!")
                    .font(.custom("PTSans-Bold", size: 50))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 6, x: 0, y: 2)
                
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
    }
}

// MARK: - Authentication Flow
struct AuthenticationFlow: View {
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    
    var body: some View {
        NavigationStack(path: $navigationCoordinator.authPath) {
            // Root auth view
            LoginView()
                .environmentObject(navigationCoordinator)
                .navigationDestination(for: AuthenticationDestination.self) { destination in
                    switch destination {
                    case .login:
                        LoginView()
                            .environmentObject(navigationCoordinator)
                    case .register:
                        RegisterView()
                            .environmentObject(navigationCoordinator)
                    }
                }
        }
    }
}

// MARK: - Main App Flow
struct MainAppFlow: View {
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    
    var body: some View {
        NavigationStack(path: $navigationCoordinator.mainPath) {
            // Root main view - Home/Feed
            NavigationAwareHomeFeedView()
                .navigationDestination(for: MainDestination.self) { destination in
                    switch destination {
                    case .home:
                        NavigationAwareHomeFeedView()
                    case .createPost:
                        PostView()
                    case .postDetails(let postId, let selectedPost):
                        DetailsView(postId: postId, selectedPost: selectedPost)
                    case .comments(let postId):
                        CommentView(postId: postId)
                            .environmentObject(navigationCoordinator)
                    case .addBloop(let selectedImage):
                        AddBloopView(selectedImage: selectedImage)
                    }
                }
        }
    }
}


#Preview {
    RootView()
}