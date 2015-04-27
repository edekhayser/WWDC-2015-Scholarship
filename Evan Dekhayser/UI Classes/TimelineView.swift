//
//  TimelineView.swift
//  Evan Dekhayser
//
//  Created by Evan Dekhayser on 7/25/14.
//  Copyright (c) 2014 Evan Dekhayser. All rights reserved.
//



// NOTE: This control is modified to not include any image-displaying capabilities



import UIKit

/**
Represents an instance in the Timeline. A Timeline is built using one or more of these TimeFrames.
*/
public struct TimeFrame: Equatable{
	/**
	A description of the event.
	*/
	let text: String
	/**
	The date that the event occured.
	*/
	let date: String
}

public func ==(lhs: TimeFrame, rhs: TimeFrame) -> Bool {
	return lhs.text == rhs.text && lhs.date == rhs.date
}

/**
The shape of a bullet that appears next to each event in the Timeline.
*/
public enum BulletType{
	/**
	Bullet shaped as a circle with no fill.
	*/
	case Circle
	/**
	Bullet shaped as a hexagon with no fill.
	*/
	case Hexagon
	/**
	Bullet shaped as a diamond with no fill.
	*/
	case Diamond
	/**
	Bullet shaped as a circle with no fill and a horizontal line connecting two vertices.
	*/
	case DiamondSlash
	/**
	Bullet shaped as a carrot facing inward toward the event.
	*/
	case Carrot
	/**
	Bullet shaped as an arrow pointing inward toward the event.
	*/
	case Arrow
}

/**
View that shows the given events in bullet form.
*/
public class TimelineView: UIView {
	
	//MARK: Public Properties
	
	public var shouldBeginTransparent = false{
		didSet{
			setupContent()
		}
	}
	
	/**
	The events shown in the Timeline
	*/
	public var timeFrames: [TimeFrame]{
		didSet{
			setupContent()
		}
	}
	
	/**
	The color of the bullets and the lines connecting them.
	*/
	public var lineColor: UIColor = UIColor.lightGrayColor(){
		didSet{
			setupContent()
		}
	}
	
	/**
	Color of the larger Date title label in each event.
	*/
	public var titleLabelColor: UIColor = UIColor(red: 0/255, green: 180/255, blue: 160/255, alpha: 1){
		didSet{
			setupContent()
		}
	}
	
	public var titleLabelFont: UIFont?{
		didSet{
			setupContent()
		}
	}
	
	/**
	Color of the smaller Text detail label in each event.
	*/
	public var detailLabelColor: UIColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1){
		didSet{
			setupContent()
		}
	}
	
	public var detailLabelFont: UIFont?{
		didSet{
			setupContent()
		}
	}
	
	/**
	The type of bullet shown next to each element.
	*/
	public var bulletType: BulletType = BulletType.Diamond{
		didSet{
			setupContent()
		}
	}
	
	//MARK: Private Variables
	
	private var blocks: [UIView] = []

	//MARK: Public Methods
	
	/**
	Note that the timeFrames cannot be set by this method. Further setup is required once this initalization occurs.
	
	May require more work to allow this to work with restoration.
	
	@param coder An unarchiver object.
	*/
	required public init(coder aDecoder: NSCoder) {
		timeFrames = []
		super.init(coder: aDecoder)
	}
	
	/**
	Initializes the timeline with all information needed for a complete setup.
	
	@param bulletType The type of bullet shown next to each element.
	
	@param timeFrames The events shown in the Timeline
	*/
	public init(bulletType: BulletType, timeFrames: [TimeFrame]){
		self.timeFrames = timeFrames
		self.bulletType = bulletType
		super.init(frame: CGRect.zeroRect)
		
		setTranslatesAutoresizingMaskIntoConstraints(false)
		
		setupContent()
	}
	
	public func animateAlphaIn(durationForEachBlock duration: NSTimeInterval, timeBetweenBlocks: NSTimeInterval){
		if !shouldBeginTransparent {
			return
		}
		for (index, block) in enumerate(blocks){
			UIView.animateWithDuration(duration, delay: timeBetweenBlocks * NSTimeInterval(index), options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
				block.alpha = 1
			}, completion: nil)
		}
	}
	
	//MARK: Private Methods
	
	private func setupContent(){
		for v in subviews{
			v.removeFromSuperview()
		}
		
		let guideView = UIView()
		guideView.setTranslatesAutoresizingMaskIntoConstraints(false)
		addSubview(guideView)
		addConstraints([
			NSLayoutConstraint(item: guideView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 24),
			NSLayoutConstraint(item: guideView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: guideView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: guideView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0)
			])
		
		var i = 0
		
		var viewFromAbove = guideView
		
		blocks = []
		
		for element in timeFrames{
			let v = blockForTimeFrame(element, imageTag: i)
			blocks.append(v)
			addSubview(v)
			addConstraints([
				NSLayoutConstraint(item: v, attribute: .Top, relatedBy: .Equal, toItem: viewFromAbove, attribute: .Bottom, multiplier: 1.0, constant: 0),
				NSLayoutConstraint(item: v, attribute: .Left, relatedBy: .Equal, toItem: viewFromAbove, attribute: .Left, multiplier: 1.0, constant: 0),
				NSLayoutConstraint(item: v, attribute: .Width, relatedBy: .Equal, toItem: viewFromAbove, attribute: .Width, multiplier: 1.0, constant: 0),
				])
			if shouldBeginTransparent {
				v.alpha = 0
			}
			viewFromAbove = v
			i++
		}
		
		let extraSpace: CGFloat = 2000
		
		let line = UIView()
		line.setTranslatesAutoresizingMaskIntoConstraints(false)
		line.backgroundColor = lineColor
		addSubview(line)
		sendSubviewToBack(line)
		addConstraints([
			NSLayoutConstraint(item: line, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 16.5),
			NSLayoutConstraint(item: line, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 1),
			NSLayoutConstraint(item: line, attribute: .Top, relatedBy: .Equal, toItem: viewFromAbove, attribute: .Bottom, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: line, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: extraSpace)
			])
		blocks.append(line)
		if shouldBeginTransparent {
			line.alpha = 0
		}
		
		
		addConstraint(NSLayoutConstraint(item: viewFromAbove, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0))
	}
	
	private func bulletView(size: CGSize, bulletType: BulletType) -> UIView {
		var path: UIBezierPath
		switch bulletType {
		case .Circle:
			path = UIBezierPath(ovalOfSize: size)
		case .Diamond:
			path = UIBezierPath(diamondOfSize: size)
		case .DiamondSlash:
			path = UIBezierPath(diamondSlashOfSize: size)
		case .Hexagon:
			path = UIBezierPath(hexagonOfSize: size)
		case .Carrot:
			path = UIBezierPath(carrotOfSize: size)
		case .Arrow:
			path = UIBezierPath(arrowOfSize: size)
		}
		
		let shapeLayer = CAShapeLayer()
		shapeLayer.fillColor = UIColor.clearColor().CGColor
		shapeLayer.strokeColor = lineColor.CGColor
		shapeLayer.path = path.CGPath
		
		let v = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.width))
		v.setTranslatesAutoresizingMaskIntoConstraints(false)
		v.layer.addSublayer(shapeLayer)
		return v
	}
	
	private func blockForTimeFrame(element: TimeFrame, imageTag: Int) -> UIView{
		let v = UIView()
		v.setTranslatesAutoresizingMaskIntoConstraints(false)
		
		//bullet
		let s = CGSize(width: 14, height: 14)
		var bullet: UIView = bulletView(s, bulletType: bulletType)
		v.addSubview(bullet)
		v.addConstraints([
			NSLayoutConstraint(item: bullet, attribute: .Left, relatedBy: .Equal, toItem: v, attribute: .Left, multiplier: 1.0, constant: 10),
			NSLayoutConstraint(item: bullet, attribute: .Top, relatedBy: .Equal, toItem: v, attribute: .Top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: bullet, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 14),
			NSLayoutConstraint(item: bullet, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 14)
			])
		
		let y = 145.0 as CGFloat
		
		let titleLabel = UILabel()
		titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
		titleLabel.font =  titleLabelFont ?? UIFont(name: "Avenir-Book", size: 24)
		titleLabel.textColor = titleLabelColor
		titleLabel.text = element.date
		titleLabel.numberOfLines = 0
		titleLabel.layer.masksToBounds = false
		v.addSubview(titleLabel)
		v.addConstraints([
			NSLayoutConstraint(item: titleLabel, attribute: .Width, relatedBy: .Equal, toItem: v, attribute: .Width, multiplier: 1.0, constant: -40),
			NSLayoutConstraint(item: titleLabel, attribute: .Left, relatedBy: .Equal, toItem: v, attribute: .Left, multiplier: 1.0, constant: 40),
			NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: bullet, attribute: .CenterY, multiplier: 1.0, constant: 0)
			])
		
		let textLabel = UILabel()
		textLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
		textLabel.font = detailLabelFont ?? UIFont(name: "Avenir-Book", size: 20)
		textLabel.text = element.text
		textLabel.textColor = detailLabelColor
		textLabel.numberOfLines = 0
		textLabel.layer.masksToBounds = false
		v.addSubview(textLabel)
		v.addConstraints([
			NSLayoutConstraint(item: textLabel, attribute: .Width, relatedBy: .Equal, toItem: v, attribute: .Width, multiplier: 1.0, constant: -40),
			NSLayoutConstraint(item: textLabel, attribute: .Left, relatedBy: .Equal, toItem: v, attribute: .Left, multiplier: 1.0, constant: 40),
			NSLayoutConstraint(item: textLabel, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Bottom, multiplier: 1.0, constant: 5),
			NSLayoutConstraint(item: textLabel, attribute: .Bottom, relatedBy: .Equal, toItem: v, attribute: .Bottom, multiplier: 1.0, constant: -20)
			])

		//draw the line between the bullets
		let line = UIView()
		line.setTranslatesAutoresizingMaskIntoConstraints(false)
		line.backgroundColor = lineColor
		v.addSubview(line)
		sendSubviewToBack(line)
		v.addConstraints([
			NSLayoutConstraint(item: line, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 1),
			NSLayoutConstraint(item: line, attribute: .Left, relatedBy: .Equal, toItem: v, attribute: .Left, multiplier: 1.0, constant: 16.5),
			NSLayoutConstraint(item: line, attribute: .Top, relatedBy: .Equal, toItem: v, attribute: .Top, multiplier: 1.0, constant: 14),
			NSLayoutConstraint(item: line, attribute: .Height, relatedBy: .Equal, toItem: v, attribute: .Height, multiplier: 1.0, constant: -14)
			])

		return v
	}
}

extension UIBezierPath {
	
	convenience init(hexagonOfSize size: CGSize) {
		self.init()
		moveToPoint(CGPoint(x: size.width / 2, y: 0))
		addLineToPoint(CGPoint(x: size.width, y: size.height / 3))
		addLineToPoint(CGPoint(x: size.width, y: size.height * 2 / 3))
		addLineToPoint(CGPoint(x: size.width / 2, y: size.height))
		addLineToPoint(CGPoint(x: 0, y: size.height * 2 / 3))
		addLineToPoint(CGPoint(x: 0, y: size.height / 3))
		closePath()
	}
	
	convenience init(diamondOfSize size: CGSize) {
		self.init()
		moveToPoint(CGPoint(x: size.width / 2, y: 0))
		addLineToPoint(CGPoint(x: size.width, y: size.height / 2))
		addLineToPoint(CGPoint(x: size.width / 2, y: size.height))
		addLineToPoint(CGPoint(x: 0, y: size.width / 2))
		closePath()
	}
	
	convenience init(diamondSlashOfSize size: CGSize) {
		self.init(diamondOfSize: size)
		moveToPoint(CGPoint(x: 0, y: size.height/2))
		addLineToPoint(CGPoint(x: size.width, y: size.height / 2))
	}
	
	convenience init(ovalOfSize size: CGSize) {
		self.init(ovalInRect: CGRect(origin: CGPointZero, size: size))
	}
	
	convenience init(carrotOfSize size: CGSize) {
		self.init()
		moveToPoint(CGPoint(x: size.width/2, y: 0))
		addLineToPoint(CGPoint(x: size.width, y: size.height / 2))
		addLineToPoint(CGPoint(x: size.width / 2, y: size.height))
	}
	
	convenience init(arrowOfSize size: CGSize) {
		self.init(carrotOfSize: size)
		moveToPoint(CGPoint(x: 0, y: size.height/2))
		addLineToPoint(CGPoint(x: size.width, y: size.height / 2))
	}
}
