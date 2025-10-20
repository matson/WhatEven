//
//  LoginView.swift
//  WhatEven
//
//  SwiftUI Login View for MVVM architecture
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Gradient background with current color and lower opacity
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
                    // Top section with title
                    VStack(spacing: 8) {
                        Spacer()
                        
                        Text("WhatEven!")
                            .font(.custom("LexendDeca-Bold", size: 50))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 1)
                        
                        Spacer()
                    }
                    .frame(height: geometry.size.height * 0.33)
                    
                    // Middle section with form
                    VStack(spacing: 0) {
                        // Container with pink background
                        VStack(spacing: 0) {
                            // Card title section
                            VStack(spacing: 8) {
                                Text("Reality Check Time")
                                    .font(.custom("LexendDeca-Bold", size: 22))
                                    .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                                
                                Text("Share your online vs reality fails")
                                    .font(.custom("LexendDeca-Regular", size: 14))
                                    .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55).opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: (geometry.size.height * 0.33) / 3)
                            
                            // Username field section
                            VStack {
                                TextField("username", text: $viewModel.credentials.email)
                                    .font(.custom("LexendDeca-Regular", size: 15))
                                    .foregroundColor(.primary)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: (geometry.size.height * 0.33) / 3)
                            .padding(.horizontal, 20)
                            
                            // Password field section
                            VStack {
                                SecureField("password", text: $viewModel.credentials.password)
                                    .font(.custom("LexendDeca-Regular", size: 15))
                                    .foregroundColor(.primary)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: (geometry.size.height * 0.33) / 3)
                            .padding(.horizontal, 20)
                        }
                        .background(Color.white)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 26)
                    }
                    .frame(height: geometry.size.height * 0.33)
                    
                    // Bottom section with buttons
                    VStack(spacing: 5) {
                        // Buttons
                        HStack(spacing: 12) {
                            Button("login") {
                                viewModel.login()
                            }
                            .buttonStyle(CustomButtonStyle(isDark: false))
                            .disabled(!viewModel.canLogin)
                            
                            Button("Sign Up") {
                                // Handle register navigation
                            }
                            .buttonStyle(CustomButtonStyle(isDark: true))
                        }
                        .frame(height: geometry.size.height * 0.10)
                        .padding(.horizontal, 24)
                        
                        // Loading indicator
                        VStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.blue)
                                    .scaleEffect(1.2)
                            }
                        }
                        .frame(height: geometry.size.height * 0.05)
                        
                        Spacer()
                        
                        // Sign up prompt
                        VStack {
                            Text("Don't have an account? Sign Up!")
                                .font(.custom("LexendDeca-Regular", size: 16))
                                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.3))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .alert("Error", isPresented: $viewModel.showingAlert) {
            Button("OK") {
                viewModel.resetState()
            }
        } message: {
            Text(viewModel.alertMessage)
        }
        .onChange(of: viewModel.loginState) { state in
            if case .success = state {
                // Handle successful login navigation
                dismiss()
            }
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 20)
            .frame(height: 40)
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Colors.babyPink.opacity(0.6), lineWidth: 2)
            )
            .shadow(color: Colors.babyPink.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

struct CustomButtonStyle: ButtonStyle {
    let isDark: Bool
    
    init(isDark: Bool = false) {
        self.isDark = isDark
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("LexendDeca-Regular", size: 25))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isDark ? Colors.styleBlue1 : Colors.styleBlue2)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .onChange(of: configuration.isPressed) { isPressed in
                if isPressed {
                    print("🎯 CustomButtonStyle: Button is being pressed")
                } else {
                    print("🎯 CustomButtonStyle: Button press released")
                }
            }
    }
}

#Preview {
    LoginView()
}