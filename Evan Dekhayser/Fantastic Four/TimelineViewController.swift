//
//  TimelineViewController.swift
//  Evan Dekhayser
//
//  Created by Evan Dekhayser on 4/15/15.
//  Copyright (c) 2015 Evan Dekhayser. All rights reserved.
//

import UIKit

// MARK: TimelineViewController

class TimelineViewController: UIViewController {
	
	// MARK: Properties
	
	@IBOutlet var scrollView: UIScrollView!
	
	let timeFrames = [
		TimeFrame(text: "Started learning Python to begin my journey into the world of code.", date: "October 2012"),
		TimeFrame(text: "Bought my first Mac Mini to start iOS development.", date: "June 2013"),
		TimeFrame(text: "Registered for the iOS Developer Program.", date: "September 2013"),
		TimeFrame(text: "Released my first app to the App Store.", date: "October 2013"),
		TimeFrame(text: "Joined the Tutorial Team at RayWenderlich.com.\n\nOn this team, I contribute by writing tutorials, working on books, and collaborating on other projects.", date: "April 2014"),
		TimeFrame(text: "Joined my school's first ever Code Club, which focuses on programming and hacking competitions.", date: "September 2014"),
		TimeFrame(text: "Published my first open-sourced controls to Github.", date: "August 2014"),
		TimeFrame(text: "Attended RWDevCon, where I learned a lot and met many great developers who have instructed and inspired me.", date: "February 2015"),
		TimeFrame(text: "Released my first WatchKit app to the App Store.", date: "April 2015"),
		TimeFrame(text: "I have great aspirations for the future, and hope to have much more to write about by next year!", date: "Beyond"),
	]
	
	var timeline: TimelineView!
	
	var timer: NSTimer!
	
	// MARK: View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//My custom TimelineView control, added to a scrollview
		//The bottom edge of the timeline is automatically made extremely long so it appears that the line does not end (it does in fact end if pulled up far enough)
		timeline = TimelineView(bulletType: BulletType.Circle, timeFrames: timeFrames)
		
		timeline.shouldBeginTransparent = true
		
		timeline.lineColor = UIColor.whiteColor()
		timeline.titleLabelColor = UIColor.whiteColor()
		timeline.detailLabelColor = UIColor.whiteColor()
		
		scrollView.addSubview(timeline)
		scrollView.addConstraints([
			NSLayoutConstraint(item: timeline, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: timeline, attribute: .Bottom, relatedBy: .Equal, toItem: scrollView, attribute: .Bottom, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: timeline, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: timeline, attribute: .Right, relatedBy: .Equal, toItem: scrollView, attribute: .Right, multiplier: 1.0, constant: 16),
			NSLayoutConstraint(item: timeline, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: -32)
			])
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		timeline.animateAlphaIn(durationForEachBlock: 0.5, timeBetweenBlocks: 0.2)
	}

}
