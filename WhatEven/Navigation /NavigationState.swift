//
//  NavigationState.swift
//  WhatEven
//
//  Navigation state management for SwiftUI app flow
//

import Foundation
import SwiftUI
import Firebase
import UIKit

// MARK: - App States
enum AppState {
    case launching
    case unauthenticated
    case authenticated
}

// MARK: - Authentication Flow
enum AuthenticationDestination {
    case login
    case register
}

// MARK: - Main App Flow  
enum MainDestination: Hashable {
    case home
    case createPost
    case postDetails(postId: String, selectedPost: Bloop)
    case comments(postId: String)
    case addBloop(selectedImage: UIImage)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .home:
            hasher.combine("home")
        case .createPost:
            hasher.combine("createPost")
        case .postDetails(let postId, let selectedPost):
            hasher.combine("postDetails")
            hasher.combine(postId)
            hasher.combine(selectedPost.postID)
        case .comments(let postId):
            hasher.combine("comments")
            hasher.combine(postId)
        case .addBloop(let selectedImage):
            hasher.combine("addBloop")
            hasher.combine(selectedImage.hashValue)
        }
    }
    
    static func == (lhs: MainDestination, rhs: MainDestination) -> Bool {
        switch (lhs, rhs) {
        case (.home, .home):
            return true
        case (.createPost, .createPost):
            return true
        case let (.postDetails(lhsId, lhsPost), .postDetails(rhsId, rhsPost)):
            return lhsId == rhsId && lhsPost.postID == rhsPost.postID
        case let (.comments(lhsId), .comments(rhsId)):
            return lhsId == rhsId
        case let (.addBloop(lhsImage), .addBloop(rhsImage)):
            return lhsImage == rhsImage
        default:
            return false
        }
    }
}

// MARK: - Navigation Coordinator
class NavigationCoordinator: ObservableObject {
    @Published var appState: AppState = .launching
    @Published var authPath = NavigationPath()
    @Published var mainPath = NavigationPath()
    @Published var currentAuthDestination: AuthenticationDestination = .login
    
    // MARK: - Authentication Navigation
    func showLogin() {
        currentAuthDestination = .login
        appState = .unauthenticated
    }
    
    func showRegister() {
        print("🟢 NavigationCoordinator.showRegister() called")
        print("🟢 Before append - auth path count: \(authPath.count)")
        authPath.append(AuthenticationDestination.register)
        print("🟢 After append - auth path count: \(authPath.count)")
        print("🟢 Auth path: \(authPath)")
    }
    
    func handleLoginSuccess() {
        appState = .authenticated
        authPath = NavigationPath() // Clear auth path
    }
    
    func handleRegistrationSuccess() {
        // Go back to login screen instead of directly to main app
        authPath = NavigationPath() // Clear auth path, goes back to login
        currentAuthDestination = .login
        print("📱 Registration successful - navigating back to login screen")
    }
    
    func logout() {
        appState = .unauthenticated
        currentAuthDestination = .login
        mainPath = NavigationPath() // Clear main path
        authPath = NavigationPath() // Clear auth path
    }
    
    // MARK: - Main App Navigation
    func navigateToHome() {
        mainPath = NavigationPath() // Clear path, go to root (Home)
    }
    
    func navigateToCreatePost() {
        mainPath.append(MainDestination.createPost)
    }
    
    func navigateToPostDetails(postId: String, selectedPost: Bloop) {
        mainPath.append(MainDestination.postDetails(postId: postId, selectedPost: selectedPost))
    }
    
    func navigateToComments(postId: String) {
        mainPath.append(MainDestination.comments(postId: postId))
    }
    
    func navigateToAddBloop(with image: UIImage) {
        mainPath.append(MainDestination.addBloop(selectedImage: image))
    }
    
    func goBack() {
        if !mainPath.isEmpty {
            mainPath.removeLast()
        } else if !authPath.isEmpty {
            authPath.removeLast()
        }
    }
    
    // MARK: - App Lifecycle
    func checkAuthenticationStatus() {
        print("🚀 Checking authentication status...")
        
        // Check if user is logged in (Firebase Auth state)
        if let currentUser = Auth.auth().currentUser {
            print("✅ User is already logged in!")
            print("👤 User UID: \(currentUser.uid)")
            print("📧 User Email: \(currentUser.email ?? "No email")")
            appState = .authenticated
        } else {
            print("🔓 No user logged in - showing login screen")
            appState = .unauthenticated
        }
    }
}