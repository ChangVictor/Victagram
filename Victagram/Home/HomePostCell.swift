//
//  HomePostCell.swift
//  Victagram
//
//  Created by Victor Chang on 15/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class HomePostCell: UICollectionViewCell {
	
	var post: Post? {
		didSet {
			guard let postImageUrl = post?.imageUrl else { return }
			photoImageView.loadImage(urlString: postImageUrl)
		}
	}
	
	
	let photoImageView: CustomImageView = {
		let imageView = CustomImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()
	
	let userProfileImageView: CustomImageView = {
		let imageView = CustomImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.backgroundColor = .blue
		return imageView
	}()
	
	let usernameLabel: UILabel = {
		let label = UILabel()
		label.text = "Username"
		label.font = UIFont.boldSystemFont(ofSize: 14)
		return label
	}()
	
	let optionsButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("•••", for: .normal)
		button.setTitleColor(.black, for: .normal)
		
		return button
	}()
	
	let likeButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
		return button
	}()
	let commentButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
		return button
	}()
	let sendMessageButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
		return button
	}()
	
	let bookmarkButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
		return button
	}()
	
	let captionLabel: UILabel = {
		let label = UILabel()
		label.text = "Something something something"
		label.backgroundColor = .yellow
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .gray
		
		addSubview(userProfileImageView)
		addSubview(usernameLabel)
		addSubview(optionsButton)
		addSubview(photoImageView)
		addSubview(bookmarkButton)
		addSubview(captionLabel)
		
		photoImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
		
		userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
		userProfileImageView.layer.cornerRadius = 40 / 2
		
		optionsButton.anchor(top: topAnchor, left: nil, bottom: photoImageView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 44, height: 0)
		
		usernameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: photoImageView.topAnchor, right: optionsButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		bookmarkButton.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 50)
		
		setupActionButtons()

		
		captionLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		
	}
	
	fileprivate func setupActionButtons() {
		let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
		stackView.distribution = .fillEqually
		addSubview(stackView)
		stackView.anchor(top: photoImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}