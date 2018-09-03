//
//  Comment.swift
//  Victagram
//
//  Created by Victor Chang on 03/09/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import Foundation

struct Comment {
	let text: String
	let uid: String
	
	init(dictionary: [String: Any]) {
		self.text = dictionary["text"] as? String ?? ""
		self.uid = dictionary["uid"] as? String ?? ""
	}
}
