//
//  NavigationRouter.swift
//  WhatEven
//
//  Router extensions and utilities for navigation
//

import SwiftUI

// MARK: - Login View Extensions
extension LoginView {
    func withNavigation() -> some View {
        NavigationAwareLoginView()
    }
}

struct NavigationAwareLoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient matching UIKit version
                LinearGradient(
                    colors: [Colors.styleBlue1, Colors.styleBlue2],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top section with title
                    VStack(spacing: 8) {
                        Spacer()
                        
                        Text("WhatEven!")
                            .font(.custom("PTSans-Bold", size: 50))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 6, x: 0, y: 2)
                        
                        Spacer()
                    }
                    .frame(height: geometry.size.height * 0.33)
                    
                    // Middle section with form
                    VStack(spacing: 0) {
                        // Container with pink background
                        VStack(spacing: 0) {
                            // "got stuff to say?" section
                            VStack {
                                Text("got stuff to say?")
                                    .font(.custom("PTSans-Regular", size: 20))
                                    .foregroundColor(.white)
                                    .shadow(color: .white, radius: 6, x: 0, y: 2)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: (geometry.size.height * 0.33) / 3)
                            
                            // Username field section
                            VStack {
                                TextField("username", text: $viewModel.credentials.email)
                                    .font(.custom("PTSans-Regular", size: 15))
                                    .foregroundColor(.white)
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
                                    .font(.custom("PTSans-Regular", size: 15))
                                    .foregroundColor(.white)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: (geometry.size.height * 0.33) / 3)
                            .padding(.horizontal, 20)
                        }
                        .background(Colors.pink1)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .shadow(color: .black, radius: 6, x: 0, y: 2)
                        .padding(.horizontal, 26)
                    }
                    .frame(height: geometry.size.height * 0.33)
                    
                    // Bottom section with buttons
                    VStack(spacing: 5) {
                        // Buttons
                        HStack(spacing: 0) {
                            Button("login") {
                                viewModel.login()
                            }
                            .buttonStyle(CustomButtonStyle())
                            .disabled(!viewModel.canLogin)
                            
                            Button("register") {
                                print("🔵 Register button tapped!")
                                print("🔵 Current auth path: \(navigationCoordinator.authPath)")
                                print("🔵 Current app state: \(navigationCoordinator.appState)")
                                navigationCoordinator.showRegister()
                                print("🔵 After showRegister - auth path: \(navigationCoordinator.authPath)")
                            }
                            .buttonStyle(CustomButtonStyle())
                            .onTapGesture {
                                print("🟡 Register button tap gesture detected!")
                            }
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
                        .frame(height: geometry.size.height * 0.10)
                        
                        Spacer()
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
                navigationCoordinator.handleLoginSuccess()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            print("🎬 NavigationAwareLoginView appeared")
            print("🎬 NavigationCoordinator available: \(navigationCoordinator)")
        }
    }
}

// MARK: - Register View Extensions
extension RegisterView {
    func withNavigation() -> some View {
        NavigationAwareRegisterView()
    }
}

struct NavigationAwareRegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    
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
                navigationCoordinator.handleRegistrationSuccess()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Register")
    }
}