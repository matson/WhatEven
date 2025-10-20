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
        ZStack {
            // Gradient background matching other views
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
            
            VStack(spacing: 40) {
                Spacer()
                
                // Main title
                VStack(spacing: 8) {
                    Text("Reality Check Time!")
                        .font(.custom("LexendDeca-Bold", size: 32))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 2)
                    
                    Text("Show the world what you really got")
                        .font(.custom("LexendDeca-Regular", size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                        .multilineTextAlignment(.center)
                }
                
                // Camera/Photo card
                VStack(spacing: 24) {
                    if let selectedImage = viewModel.selectedImage {
                        // Selected image display
                        VStack(spacing: 20) {
                            // Image preview
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 250, height: 250)
                                .clipped()
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Colors.babyPink, lineWidth: 3)
                                )
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            
                            // Action buttons
                            HStack(spacing: 16) {
                                Button("Continue") {
                                    proceedWithImage(selectedImage)
                                }
                                .font(.custom("LexendDeca-Medium", size: 18))
                                .foregroundColor(.white)
                                .frame(width: 120, height: 50)
                                .background(Colors.styleBlue2)
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                
                                Button("Change") {
                                    viewModel.handleAction(.pickPhoto)
                                }
                                .font(.custom("LexendDeca-Medium", size: 18))
                                .foregroundColor(.white)
                                .frame(width: 120, height: 50)
                                .background(Colors.babyPink)
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                            }
                        }
                    } else {
                        // Camera/Photo selection card
                        VStack(spacing: 24) {
                            // Camera icon
                            Image(systemName: "camera.fill")
                                .font(.system(size: 80, weight: .light))
                                .foregroundColor(Colors.babyPink)
                                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                            
                            VStack(spacing: 12) {
                                Text("Capture Your Truth")
                                    .font(.custom("LexendDeca-Bold", size: 20))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                                
                                Text("Take a photo or choose from library")
                                    .font(.custom("LexendDeca-Regular", size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                                    .multilineTextAlignment(.center)
                            }
                            
                            // Pick button
                            Button("Let's Go") {
                                viewModel.handleAction(.pickPhoto)
                            }
                            .font(.custom("LexendDeca-Bold", size: 22))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 60)
                            .background(Colors.styleBlue1)
                            .cornerRadius(30)
                            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
                        }
                        .padding(40)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
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
