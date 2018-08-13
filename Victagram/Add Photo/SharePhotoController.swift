//
//  SharePhotoController.swift
//  Victagram
//
//  Created by Victor Chang on 13/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

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
		imageView.backgroundColor = .red
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
		print("Sharing photo")
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
}

