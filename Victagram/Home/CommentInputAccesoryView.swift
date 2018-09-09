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
		commentTextView.text = nil
		commentTextView.showPlaceHolder()
	}
	
	fileprivate let commentTextView: CommentInputTextView = {
		let textView = CommentInputTextView()
//		textView.placeholder = "Enter Comment"
		textView.isScrollEnabled = false
		textView.font = UIFont.systemFont(ofSize: 18)
		return textView
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
		
		autoresizingMask = .flexibleHeight
		backgroundColor = .white
	
		addSubview(submitButton)
		submitButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
		addSubview(commentTextView)
		commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
		
		setUpLineSeparator()
		
	}
	
	override var intrinsicContentSize: CGSize {
		return .zero
	}
	
	fileprivate func setUpLineSeparator() {
		let lineSeparatorView = UIView()
		lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
		addSubview(lineSeparatorView)
		lineSeparatorView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
	}
	
	@objc func handleSubmit() {
		
		guard let commentText = commentTextView.text else { return }
		delegate?.didSubmit(for: commentText)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
