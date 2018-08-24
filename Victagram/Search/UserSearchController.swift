//
//  UserSearchController.swift
//  Victagram
//
//  Created by Victor Chang on 24/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	let cellId = "cellId"
	
	let searchBar: UISearchBar = {
		let searchBar = UISearchBar()
		searchBar.placeholder = "Enter Username"
		searchBar.barTintColor = .gray
		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 240, green: 230, blue: 230)
		return searchBar
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView?.backgroundColor = .white
		
		let navBar = navigationController?.navigationBar
		navigationController?.navigationBar.addSubview(searchBar)
		searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
		
		collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
		collectionView?.alwaysBounceVertical = true
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width, height: 66)
	}
}
