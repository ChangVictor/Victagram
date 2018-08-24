//
//  Post.swift
//  Victagram
//
//  Created by Victor Chang on 14/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import Foundation

struct Post {
	
	let user: User
	let imageUrl: String
	let caption: String
	
	init(user: User, dictionary: [String: Any]) {
		self.user = user
		self.imageUrl = dictionary["imageUrl"] as? String ?? ""
		self.caption = dictionary["caption"] as? String ?? ""
	}
}
