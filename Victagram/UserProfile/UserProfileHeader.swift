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
	
	var user: User? {
		didSet {
			setupProfileImage()
			usernameLabel.text = user?.username
		}
	}
	
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
	
	let usernameLabel: UILabel = {
		let label = UILabel()
		label.text = "username"
		label.font = UIFont.boldSystemFont(ofSize: 14)
		return label
	}()
	
	let postsLabel: UILabel = {
		let label = UILabel()
		label.text = "11\nposts"
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	let followersLabel: UILabel = {
		let label = UILabel()
		label.text = "11\nposts"
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	let followingLabel: UILabel = {
		let label = UILabel()
		label.text = "11\nposts"
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	let editProfileButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Edit Profile", for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		return button
	}()
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(profileImageView)
		profileImageView.layer.cornerRadius = 80 / 2
		profileImageView.clipsToBounds = true
		profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
		
		setupBottomToolbar()
		setupUsername()
		setupStatsView()
		setupEditProfileButton()
	}
	
	fileprivate func setupEditProfileButton() {
		addSubview(editProfileButton)
		editProfileButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
	}
	
	fileprivate func setupStatsView() {
		let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
		stackView.distribution = .fillEqually
		stackView.axis = .horizontal
		addSubview(stackView)
		stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
	}
	
	fileprivate func setupUsername() {
		addSubview(usernameLabel)
		usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
	}
		
	fileprivate func setupBottomToolbar() {
		let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
		
		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
		
		addSubview(stackView)
		stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor , paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
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