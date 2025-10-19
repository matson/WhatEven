//
//  AddBloopViewModel.swift
//  WhatEven
//
//  SwiftUI AddBloop ViewModel for MVVM architecture
//

import Foundation
import SwiftUI
import UIKit
import Firebase

class AddBloopViewModel: ObservableObject {
    @Published var addBloopState: AddBloopState = .idle
    @Published var formData = BloopFormData()
    @Published var showingErrorAlert = false
    @Published var showingSuccessAlert = false
    
    private let firebaseAPI = FirebaseAPI()
    private var currentUserID: String?
    
    let selectedImage: UIImage
    
    var isPosting: Bool {
        addBloopState == .posting
    }
    
    var canShare: Bool {
        formData.canSubmit && !isPosting
    }
    
    var errorMessage: String {
        switch addBloopState {
        case .error(let message):
            return message
        default:
            return ""
        }
    }
    
    init(selectedImage: UIImage) {
        self.selectedImage = selectedImage
        getCurrentUser()
    }
    
    // MARK: - Public Methods
    func handleAction(_ action: AddBloopAction) {
        switch action {
        case .updateItemName(let name):
            formData.itemName = name
        case .updateDescription(let description):
            formData.itemDescription = description
        case .validateAndPost:
            validateAndPost()
        case .reset:
            resetState()
        }
    }
    
    // MARK: - Private Methods
    private func getCurrentUser() {
        currentUserID = Auth.auth().currentUser?.uid
        print("👤 Current user UID for posting: \(currentUserID ?? "None")")
    }
    
    private func validateAndPost() {
        print("🔄 Validating form data...")
        
        // Validation
        guard !formData.itemName.isEmpty else {
            showValidationError(.emptyItemName)
            return
        }
        
        guard !formData.itemDescription.isEmpty else {
            showValidationError(.emptyDescription)
            return
        }
        
        guard formData.itemDescription.count > 50 else {
            showValidationError(.descriptionTooShort)
            return
        }
        
        guard let uid = currentUserID else {
            showError("User not authenticated")
            return
        }
        
        postBloop(uid: uid)
    }
    
    private func postBloop(uid: String) {
        print("🔄 Posting bloop...")
        print("📝 Item: \(formData.itemName)")
        print("📝 Description: \(formData.itemDescription.prefix(50))...")
        
        addBloopState = .posting
        
        firebaseAPI.postItemToFirestore(
            name: formData.itemName,
            description: formData.itemDescription,
            image: selectedImage,
            uid: uid
        ) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Failed to post bloop: \(error.localizedDescription)")
                    self?.addBloopState = .error("Failed posting item: \(error.localizedDescription)")
                    self?.showingErrorAlert = true
                } else {
                    print("✅ Bloop posted successfully!")
                    self?.addBloopState = .success
                    self?.showingSuccessAlert = true
                }
            }
        }
    }
    
    private func showValidationError(_ error: BloopValidationError) {
        print("⚠️ Validation error: \(error.localizedDescription)")
        addBloopState = .error(error.localizedDescription)
        showingErrorAlert = true
    }
    
    private func showError(_ message: String) {
        print("❌ Error: \(message)")
        addBloopState = .error(message)
        showingErrorAlert = true
    }
    
    private func resetState() {
        print("🔄 Resetting add bloop state")
        addBloopState = .idle
        formData = BloopFormData()
        showingErrorAlert = false
        showingSuccessAlert = false
    }
    
    func resetStates() {
        showingErrorAlert = false
        showingSuccessAlert = false
        if case .error = addBloopState {
            addBloopState = .idle
        }
    }
}