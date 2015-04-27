//
//  GameViewController.swift
//  Evan Dekhayser
//
//  Created by Evan Dekhayser on 4/18/15.
//  Copyright (c) 2015 Evan Dekhayser. All rights reserved.
//

import UIKit
import SpriteKit

// MARK: GameViewController

class GameViewController: UIViewController {
	
	// MARK: Properties
	
	@IBOutlet weak var gameView: SKView!
	@IBOutlet weak var overlayView: UIView!
	
	// MARK: View Lifecycyle
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		//The overlay view with directions is presented on top of the scene
		//When a tap occurs, this view is sent to the back and the game scene is shown to the user
		overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "startGame"))
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		//Create the game scene
		let scene = GameScene(size: gameView.frame.size)
		scene.scaleMode = SKSceneScaleMode.AspectFit
		
		gameView.presentScene(scene)
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		//Whenever this VC is hidden, bring the instructions back to the front of the UI
		view.bringSubviewToFront(overlayView)
		if let scene = gameView.scene as? GameScene {
			scene.stopGame()
		}
	}
	
	// MARK: Game Control
	
	func startGame() {
		if let scene = gameView.scene as? GameScene {
			scene.startGame()
		}
		view.bringSubviewToFront(gameView)
	}
	
	
	
}