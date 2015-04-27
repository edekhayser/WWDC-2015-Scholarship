//
//  SlideTabBarController.swift
//  Evan Dekhayser
//
//  Created by Evan Dekhayser on 4/16/15.
//  Copyright (c) 2015 Evan Dekhayser. All rights reserved.
//

import UIKit

// MARK: SlideTabBarController

class SlideTabBarController: UITabBarController, UITabBarControllerDelegate {

	// MARK: Animation Controller Setup
	
	func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return self
	}
	
	// MARK: View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		delegate = self
		tabBar.tintColor = UIColor.whiteColor()
	}
	
	// MARK: Orientation and Status Bar Preferences
	
	override func supportedInterfaceOrientations() -> Int {
		//Make sure that the game scene is always in Portrait
		if selectedIndex == 3 {
			return Int(UIInterfaceOrientationMask.Portrait.rawValue | UIInterfaceOrientationMask.PortraitUpsideDown.rawValue)
		}
		return Int(UIInterfaceOrientationMask.All.rawValue)
	}
	
	override func shouldAutorotate() -> Bool {
		if selectedIndex == 3 {
			return false
		}
		return true
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
	
	override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
		if (tabBar.items! as NSArray).indexOfObject(item) == 3 && (UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight) {
			let value = UIInterfaceOrientation.Portrait.rawValue
			UIDevice.currentDevice().setValue(value, forKey: "orientation")
		}
	}
	
}

// MARK: SlideTabBarController + UIViewControllerAnimatedTransitioning

extension SlideTabBarController: UIViewControllerAnimatedTransitioning{
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
		return 0.5
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		
		//Produces the sliding animation that is seen in the app when the tab changes
		
		let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
		fromViewController.view.clipsToBounds = true
		let mainFrame = fromViewController.view.frame
		
		let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
		transitionContext.containerView().addSubview(toViewController.view)
		toViewController.view.clipsToBounds = true
		toViewController.view.transform = CGAffineTransformMakeScale(0, 0)
		let toViewIsOnTheLeft = find(viewControllers as! [UIViewController], toViewController) < find(viewControllers as! [UIViewController], fromViewController)
		
		toViewController.view.center = CGPoint(x: toViewIsOnTheLeft ? 0 : mainFrame.size.width, y: mainFrame.size.height / 2)

		UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseIn, animations: { () -> Void in
			toViewController.view.transform = CGAffineTransformMakeScale(1, 1)
			toViewController.view.center = fromViewController.view.center
		}) { (finished) -> Void in
			transitionContext.completeTransition(finished)
		}
	}
}
