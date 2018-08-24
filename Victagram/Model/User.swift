//
//  User.swift
//  Victagram
//
//  Created by Victor Chang on 24/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import Foundation


struct User {
	let username: String
	let profileImageUrl: String
	
	init(dictionary: [String: Any]) {
		self.username = dictionary["username"] as? String ?? ""
		self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
	}
}
