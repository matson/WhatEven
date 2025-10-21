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
                // Gradient background matching login/register/details
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
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Title outside the card
                        HStack {
                            Spacer()
                            Text("Your Evidence")
                                .font(.custom("LexendDeca-Bold", size: 22))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                            
                            Text("👚")
                                .font(.system(size: 18))
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 8)
                        
                        // Image section with translucent card
                        VStack {
                            HStack {
                                Spacer()
                                Image("blueDress")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 200)
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                                Spacer()
                            }
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        
                        // Form section with white card
                        VStack(spacing: 24) {
                            VStack(spacing: 8) {
                                Text("Tell Your Story")
                                    .font(.custom("LexendDeca-Bold", size: 18))
                                    .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                                
                                Text("Share the real experience behind the product")
                                    .font(.custom("LexendDeca-Regular", size: 14))
                                    .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55).opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                            
                            VStack(spacing: 20) {
                                // Item name field
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Product Name")
                                            .font(.custom("LexendDeca-Medium", size: 16))
                                            .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                                        Spacer()
                                    }
                                    
                                    TextField("What did you buy?", text: Binding(
                                        get: { viewModel.formData.itemName },
                                        set: { viewModel.handleAction(.updateItemName($0)) }
                                    ))
                                    .font(.custom("LexendDeca-Regular", size: 15))
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 20)
                                    .frame(height: 45)
                                    .background(Color.white)
                                    .cornerRadius(22)
                                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                                    .focused($focusedField, equals: .itemName)
                                    .onSubmit {
                                        focusedField = .description
                                    }
                                }
                                
                                // Description field
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Your Honest Review")
                                            .font(.custom("LexendDeca-Medium", size: 16))
                                            .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                                        Spacer()
                                    }
                                    
                                    ZStack(alignment: .topLeading) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                                            .frame(minHeight: 100)
                                        
                                        TextField("Share your honest experience... What was wrong? How did it differ from expectations?", text: Binding(
                                            get: { viewModel.formData.itemDescription },
                                            set: { viewModel.handleAction(.updateDescription($0)) }
                                        ), axis: .vertical)
                                        .font(.custom("LexendDeca-Regular", size: 15))
                                        .foregroundColor(.primary)
                                        .padding(16)
                                        .focused($focusedField, equals: .description)
                                        .lineLimit(3...8)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 24)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                        
                        // Share button section
                        VStack(spacing: 16) {
                            Button("Share Your Item") {
                                viewModel.handleAction(.validateAndPost)
                            }
                            .font(.custom("LexendDeca-Bold", size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(viewModel.canShare ? Colors.styleBlue1 : Colors.styleBlue1.opacity(0.6))
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
                            .disabled(!viewModel.canShare)
                            .padding(.horizontal, 20)
                            
                            // Loading indicator
                            if viewModel.isPosting {
                                VStack(spacing: 8) {
                                    ProgressView()
                                        .tint(.white)
                                        .scaleEffect(1.2)
                                    Text("Sharing your truth...")
                                        .font(.custom("LexendDeca-Regular", size: 14))
                                        .foregroundColor(.white.opacity(0.9))
                                }
                            }
                        }
                        .padding(.bottom, 40)
                    }
                }
                
                // Loading overlay
                if viewModel.isPosting {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 12) {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                        Text("Sharing your reality check...")
                            .foregroundColor(.white)
                            .font(.custom("LexendDeca-Regular", size: 16))
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
        .alert("Reality Check Shared!", isPresented: $viewModel.showingSuccessAlert) {
            Button("OK") {
                navigationCoordinator.navigateToHome()
            }
        } message: {
            Text("Your reality check has been shared successfully!")
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Share Reality")
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
                .font(.custom("LexendDeca-Medium", size: 16))
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
