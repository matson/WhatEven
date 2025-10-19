//
//  PostModel.swift
//  WhatEven
//
//  SwiftUI Post Model for MVVM architecture
//

import Foundation
import SwiftUI
import UIKit

// MARK: - Post States
enum PostState: Equatable {
    case idle
    case pickingImage
    case imageSelected(UIImage)
    case error(String)
}

// MARK: - Image Picker State
enum ImagePickerState {
    case camera
    case photoLibrary
    case inactive
}

// MARK: - Post Actions
enum PostAction {
    case pickPhoto
    case imageSelected(UIImage)
    case proceedWithImage
    case reset
}