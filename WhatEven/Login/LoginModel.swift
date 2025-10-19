//
//  LoginModel.swift
//  WhatEven
//
//  SwiftUI Login Model for MVVM architecture
//

import Foundation

struct LoginCredentials {
    var email: String = ""
    var password: String = ""
    
    var isValid: Bool {
        return !email.isEmpty && !password.isEmpty && email.contains("@")
    }
}

enum LoginError: LocalizedError, Equatable {
    case invalidCredentials
    case networkError
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkError:
            return "Network connection error"
        case .unknown(let message):
            return message
        }
    }
}

enum LoginState: Equatable {
    case idle
    case loading
    case success
    case failure(LoginError)
}