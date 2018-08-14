//
//  Post.swift
//  Victagram
//
//  Created by Victor Chang on 14/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import Foundation

struct Post {
	let imageUrl: String
	
	init(dictionary: [String: Any]) {
		self.imageUrl = dictionary["imageUrl"] as? String ?? ""
	}
}
