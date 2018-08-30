//
//  PreviewPhotoContainerView.swift
//  Victagram
//
//  Created by Victor Chang on 30/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

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
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
