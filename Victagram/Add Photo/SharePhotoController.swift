//
//  SharePhotoController.swift
//  Victagram
//
//  Created by Victor Chang on 13/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
	
	var selectedImage: UIImage? {
		didSet {
			self.imageView.image = selectedImage
		}
	}
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
		
		setupImageAndTextView()
	}
	
	let imageView: UIImageView = {
		let imageView = UIImageView()
//		imageView.backgroundColor = .red
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()
	
	let textView: UITextView = {
		let textView = UITextView()
		textView.font = UIFont.systemFont(ofSize: 14)
		return textView
	}()
	
	fileprivate func setupImageAndTextView() {
		let containerView = UIView()
		containerView.backgroundColor = .white
		
		view.addSubview(containerView)
		containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
		
		containerView.addSubview(imageView)
		imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 84)
		
		containerView.addSubview(textView)
		textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
	}
	
	@objc func handleShare() {
		
		guard let caption = textView.text, caption.count  > 0 else { return }
		guard let image = selectedImage else { return }
		guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }
		
		navigationItem.rightBarButtonItem?.isEnabled = false
		
		let filename = NSUUID().uuidString
		
		let storageRef = Storage.storage().reference().child("posts").child(filename)
		storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
			
			if let error = error {
				self.navigationItem.rightBarButtonItem?.isEnabled = true
				print("Failed to upload post image:", error)
				return
			}
			
			storageRef.downloadURL(completion: { (downloadURL, error) in
				if let error = error {
					print("Failed to fetch downloadURL", error)
					return
				}
				guard let imageUrl = downloadURL?.absoluteString else { return }
				
				print("Succesfully uploaded post image:", imageUrl)
				
				self.saveToDatabaseWithImageUrl(imageUrl: imageUrl )
			})
		}
	}
	
	static let updateFeedNotificationName = NSNotification.Name(rawValue: "UptadeFeed")

	fileprivate func saveToDatabaseWithImageUrl(imageUrl: String ) {
		guard let postImage = selectedImage else { return }
		guard let caption = textView.text else { return }
		guard let uid = Auth.auth().currentUser?.uid else { return }
		
		let userPostRef = Database.database().reference().child("posts").child(uid)
		let ref = userPostRef.childByAutoId()
		
		let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970 ] as [String: Any]
		
		ref.updateChildValues(values) { (error, reference ) in
			if let error = error {
				self.navigationItem.rightBarButtonItem?.isEnabled = true
				print("Failed to save post to Database: ", error)
				return
			}
			print("Succesfully saved post to Database")
			self.dismiss(animated: true, completion: nil)
			
			NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
		}
		
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
}

