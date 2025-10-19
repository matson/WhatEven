//
//  RegisterViewModel.swift
//  WhatEven
//
//  SwiftUI Register ViewModel for MVVM architecture
//

import Foundation
import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published var credentials = RegisterCredentials()
    @Published var registerState: RegisterState = .idle
    @Published var showingAlert = false
    
    private let firebaseAPI = FirebaseAPI()
    
    var isLoading: Bool {
        registerState == .loading
    }
    
    var canRegister: Bool {
        credentials.isValid && !isLoading
    }
    
    var alertMessage: String {
        switch registerState {
        case .failure(let error):
            return error.localizedDescription
        default:
            return ""
        }
    }
    
    func register() {
        // Validate individual fields
        guard !credentials.username.isEmpty else {
            registerState = .failure(.emptyUsername)
            showingAlert = true
            return
        }
        
        guard !credentials.password.isEmpty else {
            registerState = .failure(.emptyPassword)
            showingAlert = true
            return
        }
        
        guard !credentials.email.isEmpty else {
            registerState = .failure(.emptyEmail)
            showingAlert = true
            return
        }
        
        guard credentials.password.count >= 8 else {
            registerState = .failure(.passwordTooShort)
            showingAlert = true
            return
        }
        
        guard isValidEmail(credentials.email) else {
            registerState = .failure(.invalidEmail)
            showingAlert = true
            return
        }
        
        registerState = .loading
        
        // Console logging for debugging
        print("🔄 Starting registration process...")
        print("📧 Email: \(credentials.email)")
        print("👤 Username: \(credentials.username)")
        
        firebaseAPI.createUser(
            withEmail: credentials.email,
            password: credentials.password,
            username: credentials.username
        ) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Registration failed: \(error.localizedDescription)")
                    self?.registerState = .failure(.unknown(error.localizedDescription))
                    self?.showingAlert = true
                } else {
                    print("✅ Registration successful!")
                    print("📧 Registered email: \(self?.credentials.email ?? "")")
                    print("👤 Registered username: \(self?.credentials.username ?? "")")
                    self?.registerState = .success
                }
            }
        }
    }
    
    func resetState() {
        registerState = .idle
        showingAlert = false
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}