//
//  RegisterView.swift
//  WhatEven
//
//  SwiftUI Register View for MVVM architecture
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background matching UIKit version
                Colors.styleBlue2
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top section with email and password (45% of height)
                    VStack(spacing: 0) {
                        // Email label section
                        VStack {
                            Text("email")
                                .font(.custom("PTSans-Bold", size: 25))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 6, x: 0, y: 2)
                        }
                        .frame(height: (geometry.size.height * 0.45) / 4)
                        
                        // Email field section
                        VStack {
                            TextField("email", text: $viewModel.credentials.email)
                                .font(.custom("PTSans-Regular", size: 15))
                                .foregroundColor(.white)
                                .textFieldStyle(CustomTextFieldStyle())
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                        }
                        .frame(height: (geometry.size.height * 0.45) / 4)
                        .padding(.horizontal, 20)
                        
                        // Password label section
                        VStack {
                            Text("password")
                                .font(.custom("PTSans-Bold", size: 25))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 6, x: 0, y: 2)
                        }
                        .frame(height: (geometry.size.height * 0.45) / 4)
                        
                        // Password field section
                        VStack {
                            SecureField("password", text: $viewModel.credentials.password)
                                .font(.custom("PTSans-Regular", size: 15))
                                .foregroundColor(.white)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        .frame(height: (geometry.size.height * 0.45) / 4)
                        .padding(.horizontal, 20)
                    }
                    .frame(height: geometry.size.height * 0.45)
                    
                    // Middle section with username (25% of height)
                    VStack(spacing: 0) {
                        // Username label section
                        VStack {
                            Text("create a cool username")
                                .font(.custom("PTSans-Bold", size: 25))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 6, x: 0, y: 2)
                                .multilineTextAlignment(.center)
                        }
                        .frame(height: (geometry.size.height * 0.25) / 2)
                        
                        // Username field section
                        VStack {
                            TextField("username", text: $viewModel.credentials.username)
                                .font(.custom("PTSans-Regular", size: 15))
                                .foregroundColor(.white)
                                .textFieldStyle(CustomTextFieldStyle())
                                .autocapitalization(.none)
                        }
                        .frame(height: (geometry.size.height * 0.25) / 2)
                        .padding(.horizontal, 20)
                    }
                    .frame(height: geometry.size.height * 0.25)
                    
                    // Bottom section with register button and indicator (15% of height)
                    VStack(spacing: 0) {
                        // Register button section
                        VStack {
                            Button("register") {
                                viewModel.register()
                            }
                            .font(.custom("PTSans-Bold", size: 25))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: (geometry.size.height * 0.15) * 0.75)
                            .disabled(!viewModel.canRegister)
                        }
                        .frame(height: (geometry.size.height * 0.15) / 2)
                        
                        // Loading indicator section
                        VStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.blue)
                                    .scaleEffect(1.2)
                            }
                        }
                        .frame(height: (geometry.size.height * 0.15) / 2)
                    }
                    .frame(height: geometry.size.height * 0.15)
                    
                    Spacer()
                }
                .padding(.top, 20)
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

#Preview {
    RegisterView()
}