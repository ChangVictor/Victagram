//
//  UserProfilePhotoCell.swift
//  Victagram
//
//  Created by Victor Chang on 14/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
	
	var post: Post? {
		didSet {
			guard let imageUrl = post?.imageUrl else { return }
			guard let url = URL(string: imageUrl) else { return }
			
			URLSession.shared.dataTask(with: url) { (data, response, error) in
				if let error = error {
					print("Failed to fetch post image: ", error)
					return
				}
				guard let imageData = data else { return }
				
				let photoImage = UIImage(data: imageData)
				
				DispatchQueue.main.async {
					self.photoImageView.image = photoImage
				}
			}.resume()
		}
	}
	
	let photoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .red
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
