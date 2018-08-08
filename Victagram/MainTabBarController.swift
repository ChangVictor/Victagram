//
//  MainTabBarController.swift
//  Victagram
//
//  Created by Victor Chang on 01/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if Auth.auth().currentUser == nil {
			DispatchQueue.main.async {
				let loginController = LoginController()
				let navController = UINavigationController(rootViewController: loginController)
				self.present(navController, animated: true, completion: nil)
			}
			
			return
		}
		
		setupViewController()
		
	}
	
	func setupViewController() {
		// home
		let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
		// search
		let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"))
		// plus
		let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
		// like
		let likeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
		// user profile
		let layout = UICollectionViewFlowLayout()
		let userProfileController = UserProfileController(collectionViewLayout: layout)
		
		let userProfileNavController = UINavigationController(rootViewController: userProfileController)
		
		userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
		userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
		tabBar.tintColor = .black
		
		viewControllers = [homeNavController,
						   searchNavController,
						   plusNavController,
						   likeNavController,
						   userProfileNavController]
		
		// modify tabBarItems insets
		guard let items = tabBar.items else { return }
		for item in items {
			item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
		}
	}
	
	private func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
		let viewController = rootViewController
		let navController = UINavigationController(rootViewController: viewController)
		navController.tabBarItem.image = unselectedImage
		navController.tabBarItem.selectedImage = selectedImage
		return navController
	}
}
