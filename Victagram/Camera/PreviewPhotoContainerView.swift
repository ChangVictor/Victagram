//
//  PreviewPhotoContainerView.swift
//  Victagram
//
//  Created by Victor Chang on 30/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
	
	let previewImageView: UIImageView = {
		let imageView = UIImageView()
		return imageView
	}()
	
	let cancelButton: UIButton = {
		let button = UIButton()
		button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
		return button
	}()
	
	let saveButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
		return button
	}()
	
	@objc fileprivate func handleSave() {
		
		print("Handling Save...")
		guard let previewImage = previewImageView.image else { return }
		let library = PHPhotoLibrary.shared()
		
		library.performChanges({
			
			PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
			
		}) { (succes, error) in
			if let error = error {
				print("Failed to save image to Photo Library: ", error)
				return
			}
			
			print("Succesfully saved image to Library")
			DispatchQueue.main.async {
				let savedLabel = UILabel()
				savedLabel.numberOfLines = 0
				savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
				savedLabel.text =  "Saved Succesfully"
				savedLabel.textColor = .white
				savedLabel.textAlignment = .center
				savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
				savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
				savedLabel.center = self.center
				
				self.addSubview(savedLabel)
				
				savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
				
				UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
					savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
				}, completion: { (completed) in
					//completed
					UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
						
						savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
						
					}, completion: { (_) in
						
						savedLabel.removeFromSuperview()
						
					})
					
				})
			}
			
		}
	}
	
	@objc fileprivate func handleCancel() {
		self.removeFromSuperview()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .yellow
		
		addSubview(previewImageView)
		previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		
		addSubview(cancelButton)
		cancelButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
		
		addSubview(saveButton)
		saveButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 24, paddingBottom: 24, paddingRight: 24, width: 50, height: 50)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
