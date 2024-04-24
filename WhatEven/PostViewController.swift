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
    
    private let stackView1: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.backgroundColor = .clear
        return stack
        
    }()
    
    
    private let pickButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pickPhoto), for: .touchUpInside)
        button.setTitle("Pick", for: .normal)
        let buttonFont = UIFont(name: Constants.Attributes.regularFont, size: 25)
        let buttonColor = UIColor.white
        button.titleLabel?.font = buttonFont
        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonColor, for: .highlighted)
        button.setTitleColor(buttonColor, for: .disabled)
        button.setTitleColor(buttonColor, for: .selected)
        return button
        
    }()
    
    
    private let label1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Let's Talk Shit!"
        label.font = UIFont(name: Constants.Attributes.boldFont, size: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    
    private let label2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choose your item to cause chaos"
        label.font = UIFont(name: Constants.Attributes.boldFont, size: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        view.backgroundColor = Constants.Attributes.styleBlue1
        
    }
    
    @objc func pickPhoto(){
        
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
        //need to add camera if no simulator is detected
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
    
    func setUpLayout(){
        
        let yellowView = UIView()
        yellowView.backgroundColor = .green
        
        let greenView = UIView()
        greenView.backgroundColor = .blue
        
        let orangeView = UIView()
        greenView.backgroundColor = .orange
        
        view.addSubview(stackView1)
        stackView1.addArrangedSubview(label1)
        stackView1.addArrangedSubview(label2)
        stackView1.addArrangedSubview(pickButton)
        
        NSLayoutConstraint.activate([
            
            stackView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView1.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView1.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.50),
          
        
        
        ])
            
        
    }
}
