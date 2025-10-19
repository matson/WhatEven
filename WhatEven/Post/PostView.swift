//
//  PostView.swift
//  WhatEven
//
//  SwiftUI Post View for MVVM architecture
//

import SwiftUI

struct PostView: View {
    @StateObject private var viewModel = PostViewModel()
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background matching UIKit version
                Colors.styleBlue1
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Main content (50% of height)
                    VStack(spacing: 20) {
                        Spacer()
                        
                        // Title
                        Text("Let's Talk Shit!")
                            .font(.custom("PTSans-Bold", size: 20))
                            .foregroundColor(.white)
                            .textAlignment(.center)
                        
                        // Subtitle
                        Text("Choose your item to cause chaos")
                            .font(.custom("PTSans-Bold", size: 20))
                            .foregroundColor(.white)
                            .textAlignment(.center)
                            .multilineTextAlignment(.center)
                        
                        // Pick button or selected image
                        if let selectedImage = viewModel.selectedImage {
                            VStack(spacing: 16) {
                                // Show selected image
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 200, maxHeight: 200)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                
                                HStack(spacing: 20) {
                                    // Continue button
                                    Button("Continue") {
                                        proceedWithImage(selectedImage)
                                    }
                                    .font(.custom("PTSans-Regular", size: 20))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(Colors.styleBlue2)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white, lineWidth: 1)
                                    )
                                    
                                    // Pick different image button
                                    Button("Change") {
                                        viewModel.handleAction(.pickPhoto)
                                    }
                                    .font(.custom("PTSans-Regular", size: 20))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(Colors.pink1)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white, lineWidth: 1)
                                    )
                                }
                            }
                        } else {
                            // Pick button
                            Button("Pick") {
                                viewModel.handleAction(.pickPhoto)
                            }
                            .font(.custom("PTSans-Regular", size: 45))
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                        }
                        
                        Spacer()
                    }
                    .frame(height: geometry.size.height * 0.50)
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(
                sourceType: viewModel.imagePickerState == .camera ? .camera : .photoLibrary,
                onImageSelected: { image in
                    viewModel.handleAction(.imageSelected(image))
                }
            )
        }
        .alert("Choose Image Source", isPresented: $viewModel.showingCameraSourceAlert) {
            Button("Camera") {
                viewModel.selectImageSource(.camera)
            }
            Button("Photo Library") {
                viewModel.selectImageSource(.photoLibrary)
            }
            Button("Cancel", role: .cancel) {
                viewModel.resetStates()
            }
        } message: {
            Text("How would you like to select your image?")
        }
        .alert("Error", isPresented: $viewModel.showingErrorAlert) {
            Button("OK") {
                viewModel.resetStates()
            }
        } message: {
            Text(viewModel.errorMessage)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Create Post")
        .onAppear {
            print("🎬 PostView appeared")
        }
    }
    
    private func proceedWithImage(_ image: UIImage) {
        print("📱 Proceeding to AddBloopView with selected image")
        // Navigate to AddBloopView with the selected image
        navigationCoordinator.navigateToAddBloop(with: image)
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    let onImageSelected: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImageSelected(image)
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    PostView()
        .environmentObject(NavigationCoordinator())
}