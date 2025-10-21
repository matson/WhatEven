//
//  RegisterView.swift
//  WhatEven
//
//  SwiftUI Register View for MVVM architecture
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Gradient background matching LoginView
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
                
                VStack(alignment: .center, spacing: 0) {
                    // Top section with title
                    VStack(spacing: 8) {
                        Spacer()
                        
                        Text("Create Your Account")
                            .font(.custom("LexendDeca-Bold", size: 42))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 1)
                        
                        Spacer()
                    }
                    .frame(height: geometry.size.height * 0.25)
                    .padding(.bottom, 15)

                    // Middle section with form card
                    VStack(spacing: 0) {
                        VStack(spacing: 32) {
                            // Card title section
                            VStack(spacing: 8) {
                                Text("Join the Reality Check")
                                    .font(.custom("LexendDeca-Bold", size: 20))
                                    .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                                
                                Text("Start sharing your truth")
                                    .font(.custom("LexendDeca-Regular", size: 14))
                                    .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55).opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                            
                            // Form fields
                            VStack(spacing: 20) {
                                // Email field with title
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Your Email Address")
                                            .font(.custom("LexendDeca-Medium", size: 16))
                                            .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                                        Spacer()
                                    }
                                    
                                    TextField("email@example.com", text: $viewModel.credentials.email)
                                        .font(.custom("LexendDeca-Regular", size: 15))
                                        .foregroundColor(.primary)
                                        .textFieldStyle(RegisterTextFieldStyle())
                                        .autocapitalization(.none)
                                        .keyboardType(.emailAddress)
                                }
                                
                                // Password field with title
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Create a Secure Password")
                                            .font(.custom("LexendDeca-Medium", size: 16))
                                            .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                                        Spacer()
                                    }
                                    
                                    SecureField("password", text: $viewModel.credentials.password)
                                        .font(.custom("LexendDeca-Regular", size: 15))
                                        .foregroundColor(.primary)
                                        .textFieldStyle(RegisterTextFieldStyle())
                                }
                                
                                // Username field with title
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Pick Your Username")
                                            .font(.custom("LexendDeca-Medium", size: 16))
                                            .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                                        Spacer()
                                    }
                                    
                                    TextField("cooluser123", text: $viewModel.credentials.username)
                                        .font(.custom("LexendDeca-Regular", size: 15))
                                        .foregroundColor(.primary)
                                        .textFieldStyle(RegisterTextFieldStyle())
                                        .autocapitalization(.none)
                                }
                            }
                        }
                        .padding(.vertical, 24)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 26)
                    }
                    .frame(height: geometry.size.height * 0.45)
                    
                    // Bottom section with button
                    VStack(spacing: 16) {
                        Button("Register") {
                            viewModel.register()
                        }
                        .buttonStyle(RegisterButtonStyle())
                        .disabled(!viewModel.canRegister)
                        .padding(.horizontal, 26)
                        .padding(.top, 16)
                        
                        // Lightning bolt emoji
                        Text("⚡")
                            .font(.system(size: 24))
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
                        
                        // Loading indicator
                        VStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                                    .scaleEffect(1.2)
                            }
                        }
                        .frame(height: 30)
                        
                        Spacer()
                    }
                    .padding(.top, 20)
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
        .onChange(of: viewModel.registerState) { state in
            if case .success = state {
                // Handle successful registration navigation
                dismiss()
            }
        }
    }
}

struct RegisterTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 20)
            .frame(height: 40)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
    }
}

struct RegisterButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("LexendDeca-Regular", size: 25))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Colors.styleBlue1)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

#Preview {
    RegisterView()
}
