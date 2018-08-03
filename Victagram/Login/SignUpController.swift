//
//  ViewController.swift
//  Victagram
//
//  Created by Victor Chang on 30/07/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	let plusPhotoButton: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
		return button
	}()
	
	@objc func handlePlusPhoto() {
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		imagePickerController.allowsEditing = true
		present(imagePickerController, animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		
		if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
			plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
		} else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
			plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
		}
		
		plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
		plusPhotoButton.layer.masksToBounds = true
		plusPhotoButton.layer.borderColor = UIColor.black.cgColor
		plusPhotoButton.layer.borderWidth = 3
		dismiss(animated: true, completion: nil)
	}
	
	let emailTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Email"
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.borderStyle = .roundedRect
		textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
		textField.font = UIFont.systemFont(ofSize: 14)
		textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
		return textField
	}()
	let usernameTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Username"
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.borderStyle = .roundedRect
		textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
		textField.font = UIFont.systemFont(ofSize: 14)
		textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
		return textField
	}()
	let passwordTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Password"
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.borderStyle = .roundedRect
		textField.isSecureTextEntry = true
		textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
		textField.font = UIFont.systemFont(ofSize: 14)
		textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
		return textField
	}()
	
	@objc fileprivate func handleTextInputChange() {
		let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
		
		if isFormValid {
			signUpButton.isEnabled = true
			signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
		} else {
			signUpButton.isEnabled = false
			signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
		}
	}
	
	let signUpButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Sign Up", for: .normal)
		button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
		button.layer.cornerRadius = 5
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.setTitleColor(.white, for: .normal)
		button.addTarget(self  , action: #selector(handleSignUp), for: .touchUpInside)
		return button
	}()
	
	@objc func handleSignUp() {
		guard let email = emailTextField.text, email.count > 0 else { return }
		guard let username = usernameTextField.text, username.count > 0 else { return }
		guard let password = passwordTextField.text, password.count > 0 else { return }
		
		Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error: Error?) in
			
			if let err = error {
				print("Failed to create User:", err)
				return
			}
			
			print("Succesfully created user:", user?.user.uid ?? "")
			
			guard let image = self.plusPhotoButton.imageView?.image else { return }
			guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
			guard let filename = user?.user.uid else { return }
			Storage.storage().reference().child("profile_image").child(filename).putData(uploadData, metadata: nil, completion: { (metadata, err) in
				
				if let err = err {
					print("Failed to upload profile image:", err)
					return
				}
				// Firebase 5 Update: Must now retrieve downloadURL
				Storage.storage().reference().downloadURL(completion: { (downloadURL, err) in
					guard let profileImageUrl = downloadURL?.absoluteString else { return }
					
					print("Successfully uploaded profile image:", profileImageUrl)
					
					guard let uid = user?.user.uid else { return }
					
					let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
					let values = [uid: dictionaryValues]
					
					Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
						
						if let err = err {
							print("Failed to save user info into db:", err)
							return
						}
						
						print("Successfully saved user info to db")
						
						self.dismiss(animated: true, completion: nil)
						
					})
				})
			})
		})
	}
	
	

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .white

		view.addSubview(plusPhotoButton)
		plusPhotoButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
		plusPhotoButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
		plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		plusPhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
		
		setupInputFields()

	}
	
	fileprivate func setupInputFields() {
		
		let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
		
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fillEqually
		stackView.axis = .vertical
		stackView.spacing = 10
		
		view.addSubview(stackView)
		
		stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
	}
}


