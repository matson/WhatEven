//
//  RegisterModel.swift
//  WhatEven
//
//  SwiftUI Register Model for MVVM architecture
//

import Foundation

struct RegisterCredentials {
    var email: String = ""
    var password: String = ""
    var username: String = ""
    
    var isValid: Bool {
        return !email.isEmpty && 
               !password.isEmpty && 
               !username.isEmpty && 
               isValidEmail(email) && 
               password.count >= 8
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

enum RegisterError: LocalizedError, Equatable {
    case emptyUsername
    case emptyPassword
    case emptyEmail
    case invalidEmail
    case passwordTooShort
    case networkError
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .emptyUsername:
            return "Please enter a username"
        case .emptyPassword:
            return "Please enter a password"
        case .emptyEmail:
            return "Please enter an email"
        case .invalidEmail:
            return "Please enter a valid email address"
        case .passwordTooShort:
            return "Password must be at least 8 characters long"
        case .networkError:
            return "Network connection error"
        case .unknown(let message):
            return message
        }
    }
}

enum RegisterState: Equatable {
    case idle
    case loading
    case success
    case failure(RegisterError)
}