//
//  HomeController.swift
//  Victagram
//
//  Created by Victor Chang on 15/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	let cellId = "cellId"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView?.backgroundColor = .white
		collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
		
		setupNavigationItems()
		fetchPosts()
	}
	
	var posts = [Post]()
	
	fileprivate func fetchPosts() {
		
		guard let uid = Auth.auth().currentUser?.uid else { return }
		
		let ref = Database.database().reference().child("posts").child(uid)
		
		ref.observeSingleEvent(of: .value, with: { (snapshot) in
			
			guard let dictionaries = snapshot.value as? [String: Any] else { return }
			
			dictionaries.forEach({ (key, value) in
				guard let dictionary = value as? [String: Any] else { return }
				
				let post = Post(dictionary: dictionary)
				self.posts.append(post)
			})
			
			self.collectionView?.reloadData()
			
		}) { (error) in
			print("Failed to fetch posts: ", error)
		}
	}
	
	fileprivate func setupNavigationItems() {
		navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		var height: CGFloat = 40 + 8 + 8
		height += view.frame.width
		height += 50	// stackview
		height += 80 // captionLabel
		
		return CGSize(width: view.frame.width, height: height)
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return posts.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
		
		cell.post = posts[indexPath.item]
		
		return cell
	}
}