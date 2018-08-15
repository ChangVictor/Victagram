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
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(photoImageView)
		photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
