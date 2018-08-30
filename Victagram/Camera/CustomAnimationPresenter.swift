//
//  CustomAnimationPresenter.swift
//  Victagram
//
//  Created by Victor Chang on 30/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class CustomAnimationPresenter: NSObject, UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.5
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		// Custom transition animation code logic
	}
}


