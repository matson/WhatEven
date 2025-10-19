//
//  AddBloopView.swift
//  WhatEven
//
//  SwiftUI AddBloop View for MVVM architecture
//

import SwiftUI

struct AddBloopView: View {
    @StateObject private var viewModel: AddBloopViewModel
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @FocusState private var focusedField: Field?
    
    enum Field {
        case itemName, description
    }
    
    init(selectedImage: UIImage) {
        self._viewModel = StateObject(wrappedValue: AddBloopViewModel(selectedImage: selectedImage))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background matching UIKit version
                Colors.styleBlue1
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Image section (40% of height)
                    VStack {
                        Image(uiImage: viewModel.selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                    }
                    .frame(height: geometry.size.height * 0.40)
                    
                    // Form section (25% of height)
                    VStack(spacing: 0) {
                        // Item name field
                        VStack {
                            TextField("item name", text: Binding(
                                get: { viewModel.formData.itemName },
                                set: { viewModel.handleAction(.updateItemName($0)) }
                            ))
                            .font(.custom("PTSans-Regular", size: 15))
                            .padding(.horizontal, 16)
                            .frame(height: 40)
                            .background(Color.white)
                            .cornerRadius(5)
                            .focused($focusedField, equals: .itemName)
                            .onSubmit {
                                focusedField = .description
                            }
                        }
                        .frame(height: geometry.size.height * 0.125)
                        .padding(.horizontal)
                        
                        // Description field
                        VStack {
                            TextField("item description", text: Binding(
                                get: { viewModel.formData.itemDescription },
                                set: { viewModel.handleAction(.updateDescription($0)) }
                            ), axis: .vertical)
                            .font(.custom("PTSans-Regular", size: 15))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .frame(minHeight: 40, maxHeight: 80)
                            .background(Color.white)
                            .cornerRadius(5)
                            .focused($focusedField, equals: .description)
                            .lineLimit(3...5)
                        }
                        .frame(height: geometry.size.height * 0.125)
                        .padding(.horizontal)
                    }
                    .frame(height: geometry.size.height * 0.25)
                    
                    // Share section (20% of height)
                    VStack(spacing: 0) {
                        // Share button
                        VStack {
                            Button("Share") {
                                viewModel.handleAction(.validateAndPost)
                            }
                            .font(.custom("PTSans-Regular", size: 25))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .disabled(!viewModel.canShare)
                            .opacity(viewModel.canShare ? 1.0 : 0.6)
                        }
                        .frame(height: geometry.size.height * 0.10)
                        
                        // Loading indicator
                        VStack {
                            if viewModel.isPosting {
                                ProgressView()
                                    .tint(.white)
                                    .scaleEffect(1.2)
                            }
                        }
                        .frame(height: geometry.size.height * 0.10)
                    }
                    .frame(height: geometry.size.height * 0.20)
                    
                    Spacer()
                }
                
                // Loading overlay
                if viewModel.isPosting {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    VStack {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                        Text("Posting...")
                            .foregroundColor(.white)
                            .font(.custom("PTSans-Regular", size: 16))
                            .padding(.top, 8)
                    }
                }
            }
        }
        .onTapGesture {
            focusedField = nil // Dismiss keyboard when tapping outside
        }
        .alert("Error", isPresented: $viewModel.showingErrorAlert) {
            Button("OK") {
                viewModel.resetStates()
            }
        } message: {
            Text(viewModel.errorMessage)
        }
        .alert("Success!", isPresented: $viewModel.showingSuccessAlert) {
            Button("OK") {
                navigationCoordinator.navigateToHome()
            }
        } message: {
            Text("Your post has been shared successfully!")
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Add Bloop")
        .onAppear {
            print("🎬 AddBloopView appeared")
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
                .foregroundColor(Colors.styleBlue1)
            }
        }
    }
}

// MARK: - Navigation Integration  
extension AddBloopView {
    static func create(with image: UIImage) -> some View {
        AddBloopView(selectedImage: image)
    }
}

#Preview {
    let mockImage = UIImage(systemName: "photo") ?? UIImage()
    return AddBloopView(selectedImage: mockImage)
        .environmentObject(NavigationCoordinator())
}