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
                                // Handle register navigation
                            }
                            .buttonStyle(CustomButtonStyle())
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
            .background(Color.clear)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 2)
            )
            .shadow(color: .pink, radius: 9, x: 0, y: 2)
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("PTSans-Regular", size: 25))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Colors.styleBlue2)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white, lineWidth: 2)
            )
            .shadow(color: .black, radius: 6, x: 0, y: 2)
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