//
//  MeViewController.swift
//  Evan Dekhayser
//
//  Created by Evan Dekhayser on 4/14/15.
//  Copyright (c) 2015 Evan Dekhayser. All rights reserved.
//

import UIKit

// MARK: MeViewController

class MeViewController: UIViewController {
	
	// MARK: Properties
	
	@IBOutlet weak var scrollView: UIScrollView!

	@IBOutlet weak var circleView: UIView!
	@IBOutlet weak var photoView: UIImageView!
	@IBOutlet weak var header: UILabel!
	@IBOutlet weak var body: UILabel!
	@IBOutlet weak var twitter: UIButton!
	@IBOutlet weak var website: UIButton!
	
	@IBOutlet weak var circleConstraint: NSLayoutConstraint!
	@IBOutlet weak var headerConstraint: NSLayoutConstraint!
	@IBOutlet weak var bodyConstraint: NSLayoutConstraint!
	
	var hasShownBefore = false
	
	// MARK: View Lifecycle

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		if !hasShownBefore {
			circleConstraint.constant = scrollView.bounds.origin.y - 150
			headerConstraint.constant = scrollView.frame.size.height + 150
			bodyConstraint.constant = scrollView.frame.size.height + 150
			circleView.alpha = 0
            photoView.alpha = 0
            header.alpha = 0
            body.alpha = 0
            twitter.alpha = 0
            website.alpha = 0

		}
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		if !hasShownBefore {
			hasShownBefore = true
			//Animates the alpha so the content fades in
			UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .AllowUserInteraction, animations: { () -> Void in
				self.circleConstraint.constant = 16
				self.view.layoutIfNeeded()
				self.circleView.alpha = 1
				self.photoView.alpha = 1
			}, completion: nil)
			UIView.animateWithDuration(4.5, delay: 0.5, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: .AllowUserInteraction, animations: { () -> Void in
				self.headerConstraint.constant = 16
				self.view.layoutIfNeeded()
				self.header.alpha = 1
				}, completion: nil)
			UIView.animateWithDuration(4.5, delay: 1.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: .AllowUserInteraction, animations: { () -> Void in
				self.bodyConstraint.constant = 16
				self.view.layoutIfNeeded()
				self.body.alpha = 1
				self.twitter.alpha = 1
				self.website.alpha = 1
				}, completion: nil)
		}
	}
	
	// MARK: Button Actions
	
	@IBAction func openTwitterAccount() {
		let webVC = WebViewController()
		webVC.url = NSURL(string: "http://twitter.com/ERDekhayser")
		presentViewController(webVC, animated: true, completion: nil)
	}
	
	@IBAction func openMyWebsite() {
		let webVC = WebViewController()
		webVC.url = NSURL(string: "http://www.evandekhayser.com")
		presentViewController(webVC, animated: true, completion: nil)
	}
	
}
