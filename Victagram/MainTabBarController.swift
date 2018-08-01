//
//  MainTabBarController.swift
//  Victagram
//
//  Created by Victor Chang on 01/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let layout = UICollectionViewFlowLayout()
		let userProfileController = UserProfileController(collectionViewLayout: layout)
		
		let navController = UINavigationController(rootViewController: userProfileController)
		
		navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
		navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
		tabBar.tintColor = .black
		
		viewControllers = [navController]
	}
}
