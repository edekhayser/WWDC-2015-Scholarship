//
//  ProjectsViewController.swift
//  Evan Dekhayser
//
//  Created by Evan Dekhayser on 4/14/15.
//  Copyright (c) 2015 Evan Dekhayser. All rights reserved.
//

import UIKit
import StoreKit

// MARK: Data Containment Stucts

struct Project {
	let name: String
	let detail: String
	let link: NSURL?
	let productIdentifier: NSNumber?
	
	init(name: String, detail: String, link: String) {
		self.name = name
		self.detail = detail
		self.link = NSURL(string: link)
		self.productIdentifier = nil
	}

	init(name: String, detail: String, productID: NSNumber) {
		self.name = name
		self.detail = detail
		self.link = nil
		self.productIdentifier = productID
	}
}

struct Section {
	let title: String
	let data: [Project]
}

// MARK: ProjectsViewController 

class ProjectsViewController: UIViewController {
	
	var bottomCellHasAnimated = false
	
	let data = [
		Section(title: "Apps", data: [
			Project(name: "Contact Switcher", detail: "Allows the user to easily flip the first and last names of contacts.", productID: 720432428),
			Project(name: "Contact Archiver", detail: "Stores unwanted contacts in iCloud and makes deleting many contacts at a time easier.", productID: 733594022),
			Project(name: "Chute-Out", detail: "Parachuting to the ground is easy – unless the birds get in the way.", productID: 889715449),
			Project(name: "Pitch X", detail: "A convenient pitch counter on the phone and the watch for coaches and parents.", productID: 973210199)
			]),
		Section(title: "Tutorials", data: [
			Project(name: "Address Book API Tutorial", detail: "In this Address Book Tutorial in iOS, learn how to add and edit contacts in a fun app about pets.", link: "http://www.raywenderlich.com/63885/address-book-tutorial-in-ios"),
			Project(name: "Top iOS 7 Animations", detail: "A collection of the best animations since the launch of iOS 7 at WWDC 2013.", link: "http://www.raywenderlich.com/73286/top-5-ios-7-animations"),
			Project(name: "Subscripting in Swift Tutorial", detail: "Learn how to add subscripting to your own custom types while creating a simple Checkers game.", link: "http://www.raywenderlich.com/79764/custom-subscripting-swift-tutorial"),
			Project(name: "Google Glass App Tutorial", detail: "In this Google Glass app tutorial, you will learn how to make a simple shopping list app!", link: "http://www.raywenderlich.com/92840/google-glass-app-tutorial"),
			]),
		Section(title: "Controls", data: [
			Project(name: "TimelineView", detail: "Shows information in a chronological order: shown in the Notable Events tab.", link: "https://github.com/edekhayser/Timeline"),
			Project(name: "FrostedSidebar", detail: "Animated sidebar control based off of Ryan Nystrom's RNFrostedSidebar.", link: "https://github.com/edekhayser/FrostedSidebar"),
			Project(name: "LoadingView", detail: "Overlay progress view based off of Monument Valley's rotating cube.", link: "https://github.com/edekhayser/LoadingView"),
			])
	]
}

// MARK: ProjectsViewController + UITableViewDataSource

extension ProjectsViewController: UITableViewDataSource{
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return count(data)
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return count(data[section].data)
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return data[section].title
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! UITableViewCell

		cell.textLabel?.text = data[indexPath.section].data[indexPath.row].name
		cell.detailTextLabel?.text = data[indexPath.section].data[indexPath.row].detail
		
		return cell
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 100.0
	}
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30
	}
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let container = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
		let label = UILabel()
		label.setTranslatesAutoresizingMaskIntoConstraints(false)
		label.font = UIFont(name: "Avenir-Book", size: 22)
		label.textColor = UIColor.whiteColor()
		label.text = self.tableView(tableView, titleForHeaderInSection: section)!
		container.addSubview(label)
		container.addConstraints([
			NSLayoutConstraint(item: label, attribute: .Left, relatedBy: .Equal, toItem: container, attribute: .Left, multiplier: 1.0, constant: 8),
			NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: container, attribute: .Top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: container, attribute: .Bottom, multiplier: 1.0, constant: 0)
			])
		return container
	}
	
}

// MARK: ProjectsViewController + UITableViewDelegate

extension ProjectsViewController: UITableViewDelegate{
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		if let productID = data[indexPath.section].data[indexPath.row].productIdentifier {
			//Opening the in-app App Store
			if UIDevice.currentDevice().model != "iPhone Simulator"{
				let vc = SKStoreProductViewController()
				vc.delegate = self
				vc.loadProductWithParameters([SKStoreProductParameterITunesItemIdentifier:productID], completionBlock:nil)
				presentViewController(vc, animated: true, completion: nil)
			} else {
				let alertController = UIAlertController(title: "Cannot Open Store", message: "This device does not support opening the store.", preferredStyle: .Alert)
				alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
				presentViewController(alertController, animated: true, completion: nil)
			}
		} else if let url = data[indexPath.section].data[indexPath.row].link {
			//Opens a web view controller to present the webpage
			let webVC = WebViewController()
			webVC.url = url
			presentViewController(webVC, animated: true, completion: nil)
		}
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		cell.backgroundColor = UIColor.clearColor()
		if !bottomCellHasAnimated {
			cell.layer.transform = CATransform3DMakeTranslation(cell.layer.frame.size.width, 0, 0)
			UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 4, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
				cell.layer.transform = CATransform3DIdentity
			}, completion: nil)
		}
		if indexPath.section + 1 == tableView.numberOfSections() && indexPath.row + 1 == tableView.numberOfRowsInSection(indexPath.section) {
			bottomCellHasAnimated = true
		}
	}
	
	func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		if !bottomCellHasAnimated {
			view.layer.transform = CATransform3DMakeTranslation(view.layer.frame.size.width, 0, 0)
			UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 4, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
				view.layer.transform = CATransform3DIdentity
			}, completion: nil)
		}
	}
	
}

// MARK: ProjectsViewController + SKStoreProductViewControllerDelegate

extension ProjectsViewController: SKStoreProductViewControllerDelegate{
	func productViewControllerDidFinish(viewController: SKStoreProductViewController!) {
		dismissViewControllerAnimated(true, completion: nil)
	}
}
