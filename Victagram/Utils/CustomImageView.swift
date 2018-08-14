//
//  CustomImageView.swift
//  Victagram
//
//  Created by Victor Chang on 14/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
	
	var lastUrlUsedToLoadImage: String?
	
	func loadImage(urlString: String) {

		lastUrlUsedToLoadImage = urlString
		guard let url = URL(string: urlString) else { return }
		
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let error = error {
				print("Failed to fetch post image: ", error)
				return
			}
			
			if url.absoluteString != self.lastUrlUsedToLoadImage {
				return
			}
			
			guard let imageData = data else { return }
			
			let photoImage = UIImage(data: imageData)
			
			DispatchQueue.main.async {
				self.image = photoImage
			}
			}.resume()
	}
	
}
