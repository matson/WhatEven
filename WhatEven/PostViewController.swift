//
//  PostViewController.swift
//  WhatEven
//
//  Created by Tracy Adams on 1/22/24.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class PostViewController: UIViewController {
    
    @IBOutlet weak var clothingName: UITextField!
    
    @IBOutlet weak var clothingDescrip: UITextField!
    
    //var posts: [Bloop] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   
    @IBAction func pickPhoto(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        
    }
    
}

//MARK: -- ImagePicker Delegate 

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            // Pass the selected image to the next view controller
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "AddBloop") as! AddBloopViewController
            nextViewController.imageSelected = selectedImage
            navigationController?.pushViewController(nextViewController, animated: true)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
