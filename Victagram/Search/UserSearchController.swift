//
//  UserSearchController.swift
//  Victagram
//
//  Created by Victor Chang on 24/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
	
	let cellId = "cellId"
		
	lazy var searchBar: UISearchBar = {
		let searchBar = UISearchBar()
		searchBar.placeholder = "Enter Username"
		searchBar.barTintColor = .gray
		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 240, green: 230, blue: 230)
		searchBar.delegate = self
		return searchBar
	}()
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

		if searchText.isEmpty {
			filteredUsers = users
		} else {
			filteredUsers = self.users.filter { (user) -> Bool in
				return user.username.lowercased().contains(searchText.lowercased())
			}
		}
		self.collectionView?.reloadData()
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView?.backgroundColor = .white
		
		let navBar = navigationController?.navigationBar
		navigationController?.navigationBar.addSubview(searchBar)
		searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
		
		collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
		collectionView?.alwaysBounceVertical = true
		collectionView?.keyboardDismissMode = .onDrag
		
		fetchUsers()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		searchBar.isHidden = false
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		searchBar.isHidden = true
		searchBar.resignFirstResponder()
		
		let user = filteredUsers[indexPath.item]
		print(user.username)
		
		let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
		userProfileController.userId = user.uid
		navigationController?.pushViewController(userProfileController, animated: true)
	}
	
	var filteredUsers = [User]()
	var users = [User]()
	
	fileprivate func fetchUsers() {

		let ref = Database.database().reference().child("users")
		ref.observeSingleEvent(of: .value, with: { (snapshot) in
			
			guard let dictionaries = snapshot.value as? [String: Any] else { return }
			
			dictionaries.forEach({ (key, value) in
				
				if key == Auth.auth().currentUser?.uid {
					print("Found myself, omit from list")
					return
				}
				
				guard let userDictionary = value as? [String: Any] else { return }
				let user = User(uid: key, dictionary: userDictionary)
				self.users.append(user)
			})
			
			self.users.sort(by: { (u1, u2) -> Bool in
				return u1.username.compare(u2.username) == .orderedAscending
			})
			
			self.filteredUsers = self.users
			self.collectionView?.reloadData()
			
		}) { (error) in
			print("Failed to fetch users for search: ", error )
		}

	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return filteredUsers.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
		
		cell.user = filteredUsers[indexPath.item]
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width, height: 66)
	}
}
