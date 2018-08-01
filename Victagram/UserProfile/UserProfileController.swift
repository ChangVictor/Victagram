//
//  UserProfileController.swift
//  Victagram
//
//  Created by Victor Chang on 01/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView?.backgroundColor = .white
		navigationItem.title = Auth.auth().currentUser?.displayName
		
		fetchUser()
		collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
	}
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
		
		
		
		return header
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize(width: view.frame.width, height: 200)
	}
	
	var user: User?
	
	fileprivate func fetchUser() {
		guard  let uid = Auth.auth().currentUser?.uid else { return }
		Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
			print(snapshot.value ?? "")
			
			guard let dictionary = snapshot.value as? [String: Any] else { return }
			
			self.user = User(dictionary: dictionary)
			
			self.navigationItem.title = self.user?.username
			
			self.collectionView?.reloadData()
			
		}) { (err) in
			print("Failed to fetch user:", err)
		}
	}
}

struct User {
	let username: String
	let profileImageUrl: String
	
	init(dictionary: [String: Any]) {
		self.username = dictionary["username"] as? String ?? ""
		self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
	}
}
