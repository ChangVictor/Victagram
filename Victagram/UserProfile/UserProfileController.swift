//
//  UserProfileController.swift
//  Victagram
//
//  Created by Victor Chang on 01/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
	
	var isGridView = true
	let cellId = "cellId"
	let homePostCellId = "homePostCellId"
	var userId: String?
	
	func didChangeToGridView() {
		isGridView = true
		collectionView?.reloadData()
	}
	
	func didChangeToListView() {
		isGridView = false
		collectionView?.reloadData()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView?.backgroundColor = .white
		collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
		collectionView?.register(UserProfilePhotoCell.self , forCellWithReuseIdentifier: cellId)
		collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellId)
		
		setupLogOutButton()
		fetchUser()
//		fetchOrderedPosts()

		
	}
	
	
	var isFinishedPaging = false
	var posts = [Post]()
	
	fileprivate func paginatePost() {
		print("Start pagin for more posts...")
		
		guard let uid = self.user?.uid else { return }
		let ref = Database.database().reference().child("posts").child(uid)
		
		var query = ref.queryOrderedByKey()
		
		if posts.count > 0 {
			let value = posts.last?.id
			query = query.queryStarting(atValue: value)
		}
		
		query.queryLimited(toFirst: 4).observeSingleEvent(of: .value, with: { (snapshot) in

			guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
			
			if allObjects.count < 4 {
				self.isFinishedPaging = true
			}
			
			if self.posts.count > 0 {
				allObjects.removeFirst()
			}
			
			guard let user = self.user else { return }
			
			allObjects.forEach({ (snapshot) in

				guard let dictionary = snapshot.value as? [String: Any] else { return }
				var post = Post(user: user, dictionary: dictionary)
				post.id = snapshot.key
				
				self.posts.append(post)
//				print(snapshot.key)
			})
			
			self.posts.forEach({ (post) in
				print(post.id ?? "")
			})
			
			self.collectionView?.reloadData()
			
		}) { (error) in
			print("Failed to paginte posts: ", error)
		}
	}
	
	fileprivate func fetchOrderedPosts() {
		guard let uid = self.user?.uid else { return }
//		guard let uid = Auth.auth().currentUser?.uid else { return }
		let ref = Database.database().reference().child("posts").child(uid)
		
		ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
			
			guard let dictionary = snapshot.value as? [String: Any] else { return }
			guard let user = self.user else { return }
			let post = Post(user: user, dictionary: dictionary)
			self.posts.insert(post, at: 0)
			
			self.collectionView?.reloadData()

		}) { (error) in
			print("Failed to fetch ordered posts: ", error)
		}
		
	}
	
	fileprivate func setupLogOutButton() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
	}
	
	@objc func handleLogOut() {
		
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
			
			do {
				try Auth.auth().signOut()
				
				let loginController = LoginController()
				let navController = UINavigationController(rootViewController: loginController)
				self.present(navController, animated: true, completion: nil)
			} catch let signOutError {
				print("Faile to sign Out:", signOutError)
			}
			
		}))
		
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		present(alertController, animated: true, completion: nil)
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return posts.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if indexPath.item == self.posts.count - 1 && !isFinishedPaging {
			print("Paginating for posts...")
			paginatePost()
		}
		
		if isGridView {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
			cell.post = posts[indexPath.item]
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomePostCell
			cell.post = posts[indexPath.item]
			return cell
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		if isGridView {
			let width = (view.frame.width - 2) / 3
			return CGSize(width: width, height: width)
		} else {
			
			var height: CGFloat = 40 + 8 + 8 // username + userProfileImageView
			height += view.frame.width
			height += 50	// stackview
			height += 60 // captionLabel
			
			return CGSize(width: view.frame.width, height: height)		}
		
	}
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
		
		header.user = self.user
		header.delegate = self
		
		return header
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize(width: view.frame.width, height: 200)
	}
	
	var user: User?
	
	fileprivate func fetchUser() {
		
		let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
		
//		guard  let uid = Auth.auth().currentUser?.uid else { return }
		Database.fetchUserWithUID(uid: uid) { (user) in
			self.user = user
			self.navigationItem.title = self.user?.username
			self.collectionView?.reloadData()
			
			self.paginatePost()
		}
	}
}
