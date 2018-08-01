//
//  UserProfileHeader.swift
//  Victagram
//
//  Created by Victor Chang on 01/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
	
	let profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .red
		return imageView
	}()
	
	let gridButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
		
		return button
	}()
	
	let listButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
		button.tintColor = UIColor(white: 0, alpha: 0.2)

		return button
	}()
	
	let bookmarkButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
		button.tintColor = UIColor(white: 0, alpha: 0.2)
		return button
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(profileImageView)
		profileImageView.layer.cornerRadius = 80 / 2
		profileImageView.clipsToBounds = true
		profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
		
		setupBottomToolbar()
	}
	
	fileprivate func setupBottomToolbar() {
		let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
		
		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
		
		addSubview(stackView)
		stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor , paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
	}
	
	var user: User? {
		didSet {
			setupProfileImage()
		}
	}
	
	fileprivate func setupProfileImage() {
		
		guard let profileImageUrl = user?.profileImageUrl else { return }
		guard let url = URL(string: profileImageUrl) else { return }
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			// check for error and construct image using data
			if let error = error {
				print("Failed to fetch profile image", error)
			}
			
			guard let data = data else { return }
			
			let image = UIImage(data: data)
			DispatchQueue.main.async {
				self.profileImageView.image = image
			}
			
			}.resume()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
