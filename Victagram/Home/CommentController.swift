//
//  CommentController.swift
//  Victagram
//
//  Created by Victor Chang on 01/09/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class CommentController: UICollectionViewController {
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Comments"
		
		collectionView?.backgroundColor = .red
		
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		tabBarController?.tabBar.isHidden = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		tabBarController?.tabBar.isHidden = false

	}
	
	var containerView: UIView = {
		let containerView = UIView()
		containerView.backgroundColor = .white
		containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
		
		let submitButton = UIButton(type: .system)
		submitButton.setTitle("Submit", for: .normal)
		submitButton.setTitleColor(.black, for: .normal)
		submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
		containerView.addSubview(submitButton)
		submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
		
		let textField = UITextField()
		textField.placeholder = "Enter Comment"
		containerView.addSubview(textField)
		textField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12 , paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		
		return containerView

	 }()
	
	@objc fileprivate func handleSubmit() {
		print("Handling Submit...")
	}
	
	override var inputAccessoryView: UIView? {
		get {
			return containerView
		}
	}
	
	override var canBecomeFirstResponder: Bool {
		return true
	}
}
