//
//  CommentController.swift
//  Victagram
//
//  Created by Victor Chang on 01/09/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import Firebase

class CommentController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CommentInputAccesoryViewDelegate {
	
	var post: Post?
	let cellId = "cellId"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Comments"
		
		collectionView?.backgroundColor = .white
		collectionView?.alwaysBounceVertical = true
		collectionView?.keyboardDismissMode = .interactive
		
		collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
		collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
		
		collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
		
		fetchComments()
	}
	
	var comments = [Comment]()
	
	fileprivate func fetchComments() {
		
		guard let postId = self.post?.id else { return }
		let ref = Database.database().reference().child("comments").child(postId)
		
		ref.observe(.childAdded, with: { (snapshot) in
			
			guard let dictionary = snapshot.value as? [String: Any] else { return }
			
			guard let uid = dictionary["uid"] as? String else { return }
			
			Database.fetchUserWithUID(uid: uid, completion: { (user) in
				
				let comment = Comment(user: user, dictionary: dictionary)
				self.comments.append(comment)
				self.collectionView?.reloadData()
				
			})

		}) { (error) in
			print("Failed to observe comments")
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return comments.count
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
		let dummyCell = CommentCell(frame: frame)
		dummyCell.comment = comments[indexPath.item]
		dummyCell.layoutIfNeeded()
		
		let targetSize = CGSize(width: view.frame.width, height: 1000)
		let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
		
		let height = max(40 + 8 + 8, estimatedSize.height)
		return CGSize(width: view.frame.width, height: height)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
		
		cell.comment = self.comments[indexPath.item]
		
		return cell
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		tabBarController?.tabBar.isHidden = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		tabBarController?.tabBar.isHidden = false

	}
	
	lazy var containerView: CommentInputAccesoryView = {
		let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
		let commentInputAccesoryView = CommentInputAccesoryView(frame: frame)
		commentInputAccesoryView.delegate = self
		
		return commentInputAccesoryView
	 }()
	
	func didSubmit(for comment: String) {
		print("Trying to insert comment into Firebase")
		print("Post Id: ", self.post?.id ?? "" )
		print("Insertin comment: ", comment)
		
		let postId = self.post?.id ?? ""
		guard let uid = Auth.auth().currentUser?.uid else { return }
		
		let values = ["text": comment,
					  "creationDate": Date().timeIntervalSince1970,
					  "uid": uid] as [String:Any]
		
		Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (error, reference) in
			
			if let error = error {
				print("Faile to insert comment: ", error)
				return
			}
			
			print("Succesfully Inserted comment.")
			self.containerView.clearCommentTextField()
		}
	}
	
//	let commentTextField: UITextField = {
//		let textField = UITextField()
//		textField.placeholder = "Enter Comment"
//		return textField
//	}()
	
//	@objc fileprivate func handleSubmit() {
//		
//		print("Post Id: ", self.post?.id ?? "" )
//		print("Insertin comment: ", commentTextField.text ?? "")
//		
//		let postId = self.post?.id ?? ""
//		guard let uid = Auth.auth().currentUser?.uid else { return }
//		
//		let values = ["text":commentTextField.text ?? "",
//					  "creationDate": Date().timeIntervalSince1970,
//					  "uid": uid] as [String:Any]
//		
//		Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (error, reference) in
//			
//			if let error = error {
//				print("Faile to insert comment: ", error)
//				return
//			}
//			
//			print("Succesfully Inserted comment.")
//			
//		}
//	}
	
	override var inputAccessoryView: UIView? {
		get {
			return containerView
		}
	}
	
	override var canBecomeFirstResponder: Bool {
		return true
	}
}
