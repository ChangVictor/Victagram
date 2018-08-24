//
//  UserSearchCell.swift
//  Victagram
//
//  Created by Victor Chang on 24/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
	
	let profileImageView: CustomImageView = {
		let imageView = CustomImageView()
		imageView.backgroundColor = .red
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		
		return imageView
	}()
	
	let usernameLabel: UILabel = {
		let label = UILabel()
		label.text = "Username"
		label.font = UIFont.boldSystemFont(ofSize: 14)
		return label
	}()
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(profileImageView)
		addSubview(usernameLabel)
		
		profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 50, height: 50)
		profileImageView.layer.cornerRadius = 50 / 2
		profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		
		usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		
		let separatorView = UIView()
		separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
		addSubview(separatorView)
		separatorView.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
