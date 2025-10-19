//
//  PostViewModel.swift
//  WhatEven
//
//  SwiftUI Post ViewModel for MVVM architecture
//

import Foundation
import SwiftUI
import UIKit

class PostViewModel: ObservableObject {
    @Published var postState: PostState = .idle
    @Published var imagePickerState: ImagePickerState = .inactive
    @Published var showingImagePicker = false
    @Published var showingCameraSourceAlert = false
    @Published var showingErrorAlert = false
    
    var selectedImage: UIImage? {
        switch postState {
        case .imageSelected(let image):
            return image
        default:
            return nil
        }
    }
    
    var errorMessage: String {
        switch postState {
        case .error(let message):
            return message
        default:
            return ""
        }
    }
    
    // MARK: - Public Methods
    func handleAction(_ action: PostAction) {
        switch action {
        case .pickPhoto:
            showImageSourceSelection()
        case .imageSelected(let image):
            handleImageSelection(image)
        case .proceedWithImage:
            // Handle navigation in the view
            print("📱 Proceeding with selected image")
        case .reset:
            resetState()
        }
    }
    
    func selectImageSource(_ source: ImagePickerState) {
        print("📸 Selected image source: \(source)")
        imagePickerState = source
        showingImagePicker = true
        showingCameraSourceAlert = false
    }
    
    // MARK: - Private Methods
    private func showImageSourceSelection() {
        print("🔄 Showing image source selection")
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showingCameraSourceAlert = true
        } else {
            // Only photo library available
            selectImageSource(.photoLibrary)
        }
    }
    
    private func handleImageSelection(_ image: UIImage) {
        print("✅ Image selected successfully")
        postState = .imageSelected(image)
        imagePickerState = .inactive
        showingImagePicker = false
    }
    
    private func resetState() {
        print("🔄 Resetting post state")
        postState = .idle
        imagePickerState = .inactive
        showingImagePicker = false
        showingCameraSourceAlert = false
        showingErrorAlert = false
    }
    
    func resetStates() {
        showingErrorAlert = false
        if case .error = postState {
            postState = .idle
        }
    }
}