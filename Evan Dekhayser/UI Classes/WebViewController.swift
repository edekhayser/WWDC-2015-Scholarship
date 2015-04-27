//
//  WebViewController.swift
//  Evan Dekhayser
//
//  Created by Evan Dekhayser on 4/14/15.
//  Copyright (c) 2015 Evan Dekhayser. All rights reserved.
//

import UIKit
import WebKit

// MARK: WebViewController

class WebViewController: UIViewController {
	
	// MARK: Properties
	
	var url: NSURL!
	
	// MARK: View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
		
		//View that the web page actually shows in
		let webView = WKWebView()
		webView.setTranslatesAutoresizingMaskIntoConstraints(false)
		webView.clipsToBounds = false
		view.addSubview(webView)
		view.addConstraints([
			NSLayoutConstraint(item: webView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: webView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: webView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: webView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0)
			])
		webView.loadRequest(NSURLRequest(URL: url))
		//Circular button on the bottom left that closes the webpage
		let circleView = UIView()
		circleView.setTranslatesAutoresizingMaskIntoConstraints(false)
		circleView.backgroundColor = UIColor.redColor()
		circleView.layer.cornerRadius = 30
		view.addSubview(circleView)
		view.addConstraints([
			NSLayoutConstraint(item: circleView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 60),
			NSLayoutConstraint(item: circleView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 60),
			NSLayoutConstraint(item: circleView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 20),
			NSLayoutConstraint(item: circleView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -20)
			])
		
		let x = UIImageView(image: UIImage(named: "x"))
		x.setTranslatesAutoresizingMaskIntoConstraints(false)
		circleView.addSubview(x)
		circleView.addConstraints([
			NSLayoutConstraint(item: x, attribute: .CenterX, relatedBy: .Equal, toItem: circleView, attribute: .CenterX, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: x, attribute: .CenterY, relatedBy: .Equal, toItem: circleView, attribute: .CenterY, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: x, attribute: .Width, relatedBy: .Equal, toItem: circleView, attribute: .Width, multiplier: 0.5, constant: 0),
			NSLayoutConstraint(item: x, attribute: .Height, relatedBy: .Equal, toItem: circleView, attribute: .Height, multiplier: 0.5, constant: 0)
			])
		circleView.layer.shadowOffset = CGSizeMake(0, 10)
		circleView.layer.shadowRadius = 5
		circleView.layer.shadowOpacity = 0.5
		let button = UIButton.buttonWithType(.System) as! UIButton
		button.setTranslatesAutoresizingMaskIntoConstraints(false)
		button.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
		circleView.addSubview(button)
		circleView.addConstraints([
			NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: circleView, attribute: .Left, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: circleView, attribute: .Right, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: circleView, attribute: .Top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: circleView, attribute: .Bottom, multiplier: 1.0, constant: 0)
			])
	}
	
	// MARK: Convenience Methods
	
	func dismiss(){
		dismissViewControllerAnimated(true, completion: nil)
		UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
	}
	
}
