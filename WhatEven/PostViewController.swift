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
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var pickButton: UIButton!
    
    @IBOutlet weak var midLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttributes()
        
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
            let storyboard: UIStoryboard = UIStoryboard(name: Constants.Attributes.mainStoryboardName, bundle: nil)
            // Pass the selected image to the next view controller
            let nextViewController = storyboard.instantiateViewController(withIdentifier: Constants.Attributes.addBloop) as! AddBloopViewController
            nextViewController.imageSelected = selectedImage
            navigationController?.pushViewController(nextViewController, animated: true)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func setAttributes(){
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Attributes.styleBlue1
        pickButton.translatesAutoresizingMaskIntoConstraints = false
        midLabel.translatesAutoresizingMaskIntoConstraints = false
        
        pickButton.titleLabel?.font = UIFont(name: Constants.Attributes.boldFont, size: 24)
        
        NSLayoutConstraint.activate([
            
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 142),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -142),
            
            pickButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pickButton.heightAnchor.constraint(equalToConstant:  60 ),
            pickButton.widthAnchor.constraint(equalToConstant: 80),
            
            midLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 149),
            midLabel.leadingAnchor.constraint(equalTo:
                view.leadingAnchor, constant: 85),
            midLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -85)
            
            
        
        
        ])
            
        
    }
}
