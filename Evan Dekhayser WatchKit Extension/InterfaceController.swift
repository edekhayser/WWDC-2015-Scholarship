//
//  InterfaceController.swift
//  Evan Dekhayser WatchKit Extension
//
//  Created by Evan Dekhayser on 4/14/15.
//  Copyright (c) 2015 Evan Dekhayser. All rights reserved.
//

import WatchKit

class InterfaceController: WKInterfaceController {
	
	@IBOutlet weak var timer: WKInterfaceTimer!
	
	override func awakeWithContext(context: AnyObject?) {
		super.awakeWithContext(context)
		
		// Configure interface objects here.
		let dateString = "2015 June 08 10:00:00 Pacific Daylight Time"
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy MM dd HH:mm:ss zzzz"
		timer.setDate(dateFormatter.dateFromString(dateString)!)
		timer.start()
	}
	
	override func willActivate() {
		// This method is called when watch view controller is about to be visible to user
		super.willActivate()
	}
	
	override func didDeactivate() {
		// This method is called when watch view controller is no longer visible
		super.didDeactivate()
	}
	
}
