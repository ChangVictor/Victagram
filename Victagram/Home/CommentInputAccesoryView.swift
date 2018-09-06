//
//  CommentInputAccesoryView.swift
//  Victagram
//
//  Created by Victor Chang on 06/09/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

protocol CommentInputAccesoryViewDelegate {
	func didSubmit(for comment: String)
}

class CommentInputAccesoryView: UIView {
	
	var delegate: CommentInputAccesoryViewDelegate?
	
	func clearCommentTextField() {
		commentTextField.text = nil
	}
	
	fileprivate let commentTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter Comment"
		return textField
	}()
	
	fileprivate let submitButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Submit", for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
		return button
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		
//		backgroundColor = .red
	
		addSubview(submitButton)
		submitButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
		addSubview(commentTextField)
		commentTextField.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		
		setUpLineSeparator()
		
	}
	
	fileprivate func setUpLineSeparator() {
		let lineSeparatorView = UIView()
		lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
		addSubview(lineSeparatorView)
		lineSeparatorView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
	}
	
	@objc func handleSubmit() {
		
		guard let commentText = commentTextField.text else { return }
		delegate?.didSubmit(for: commentText)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
