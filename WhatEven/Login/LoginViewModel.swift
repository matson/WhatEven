//
//  LoginViewModel.swift
//  WhatEven
//
//  SwiftUI Login ViewModel for MVVM architecture
//

import Foundation
import SwiftUI
import Firebase

class LoginViewModel: ObservableObject {
    @Published var credentials = LoginCredentials()
    @Published var loginState: LoginState = .idle
    @Published var showingAlert = false
    
    var isLoading: Bool {
        loginState == .loading
    }
    
    var canLogin: Bool {
        credentials.isValid && !isLoading
    }
    
    var alertMessage: String {
        switch loginState {
        case .failure(let error):
            return error.localizedDescription
        default:
            return ""
        }
    }
    
    func login() {
        guard credentials.isValid else {
            loginState = .failure(.invalidCredentials)
            showingAlert = true
            return
        }
        
        loginState = .loading
        
        // Console logging for debugging
        print("🔄 Starting login process...")
        print("📧 Email: \(credentials.email)")
        
        Auth.auth().signIn(withEmail: credentials.email, password: credentials.password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Login failed: \(error.localizedDescription)")
                    self?.loginState = .failure(.unknown(error.localizedDescription))
                    self?.showingAlert = true
                } else {
                    print("✅ Login successful!")
                    print("👤 User UID: \(authResult?.user.uid ?? "Unknown")")
                    self?.loginState = .success
                }
            }
        }
    }
    
    func resetState() {
        loginState = .idle
        showingAlert = false
    }
}