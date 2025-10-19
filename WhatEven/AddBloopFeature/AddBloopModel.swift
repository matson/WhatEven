//
//  AddBloopModel.swift
//  WhatEven
//
//  SwiftUI AddBloop Model for MVVM architecture
//

import Foundation
import SwiftUI
import UIKit

// MARK: - Add Bloop States
enum AddBloopState: Equatable {
    case idle
    case posting
    case success
    case error(String)
}

// MARK: - Form Data
struct BloopFormData {
    var itemName: String = ""
    var itemDescription: String = ""
    
    var isValid: Bool {
        return !itemName.isEmpty && 
               !itemDescription.isEmpty && 
               itemDescription.count > 50
    }
    
    var canSubmit: Bool {
        return !itemName.isEmpty && !itemDescription.isEmpty
    }
}

// MARK: - Validation Errors
enum BloopValidationError: LocalizedError, Equatable {
    case emptyItemName
    case emptyDescription
    case descriptionTooShort
    
    var errorDescription: String? {
        switch self {
        case .emptyItemName:
            return "Please enter an item name"
        case .emptyDescription:
            return "Please enter an item description"
        case .descriptionTooShort:
            return "Please enter an item description with more than 50 characters"
        }
    }
}

// MARK: - Add Bloop Actions
enum AddBloopAction {
    case updateItemName(String)
    case updateDescription(String)
    case validateAndPost
    case reset
}