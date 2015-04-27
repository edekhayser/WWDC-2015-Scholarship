//
//  GameScene.swift
//  Evan Dekhayser
//
//  Created by Evan Dekhayser on 4/18/15.
//  Copyright (c) 2015 Evan Dekhayser. All rights reserved.
//


import SpriteKit
import AVFoundation

// MARK: Enum Definition

enum PhysicsCategory: UInt32 {
    case Paddle = 0b1
    case Puck = 0b10
    case Wall = 0b100
}

// MARK: GameScene

class GameScene: SKScene {

    // MARK: Properties

    var label: SKNode!

    var opponentPaddle: SKShapeNode!
    var playerPaddle: SKShapeNode!
    var puck: SKShapeNode!

    var lastUpdateTime: CFTimeInterval?

    var destX: CGFloat!

    var opponentScore: Int = 0 {
        didSet {
            opponentScoreDisplay.text = "\(opponentScore)"
        }
    }
    var opponentScoreDisplay: SKLabelNode = SKLabelNode(text: "0")
    var playerScore: Int = 0 {
        didSet {
            playerScoreDisplay.text = "\(playerScore)"
        }
    }
    var playerScoreDisplay: SKLabelNode = SKLabelNode(text: "0")

    var lastPaddleBeepTime = NSDate()

    let coinSound = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
    let beepSound = SKAction.playSoundFileNamed("beep.wav", waitForCompletion: false)

    // MARK: Initialization

    override init(size: CGSize) {
        destX = size.width / 2

        var hexagonPath = UIBezierPath()
        hexagonPath.moveToPoint(CGPointMake(0, -45))
        hexagonPath.addLineToPoint(CGPointMake(38.97, -22.5))
        hexagonPath.addLineToPoint(CGPointMake(38.97, 22.5))
        hexagonPath.addLineToPoint(CGPointMake(0, 45))
        hexagonPath.addLineToPoint(CGPointMake(-38.97, 22.5))
        hexagonPath.addLineToPoint(CGPointMake(-38.97, -22.5))
        hexagonPath.closePath()

        opponentPaddle = SKShapeNode(path: hexagonPath.CGPath)
        opponentPaddle.strokeColor = SKColor(red:1, green:0.24, blue:0.69, alpha:1)
        opponentPaddle.lineWidth = 8
        opponentPaddle.position = CGPoint(x: size.width / 2.0, y: size.height - 100)
        opponentPaddle.physicsBody = SKPhysicsBody(polygonFromPath: opponentPaddle.path)
        opponentPaddle.physicsBody!.categoryBitMask = PhysicsCategory.Paddle.rawValue
        opponentPaddle.physicsBody!.contactTestBitMask = PhysicsCategory.Puck.rawValue
        opponentPaddle.physicsBody!.collisionBitMask = PhysicsCategory.Puck.rawValue
        opponentPaddle.physicsBody!.dynamic = false

        opponentScoreDisplay.fontSize = 48
        opponentScoreDisplay.position = CGPoint(x: 0, y: -18)
        opponentPaddle.addChild(opponentScoreDisplay)

        playerPaddle = SKShapeNode(circleOfRadius: 45)
        playerPaddle.strokeColor = SKColor(red:0.01, green:0.53, blue:1, alpha:1)
        playerPaddle.lineWidth = 8
        playerPaddle.position = CGPoint(x: size.width / 2.0, y: 100)
        playerPaddle.physicsBody = SKPhysicsBody(polygonFromPath: playerPaddle.path)
        playerPaddle.physicsBody!.categoryBitMask = PhysicsCategory.Paddle.rawValue
        playerPaddle.physicsBody!.contactTestBitMask = PhysicsCategory.Puck.rawValue
        playerPaddle.physicsBody!.collisionBitMask = PhysicsCategory.Puck.rawValue
        playerPaddle.physicsBody!.dynamic = false

        playerScoreDisplay.fontSize = 48
        playerScoreDisplay.position = CGPoint(x: 0, y: -18)
        playerPaddle.addChild(playerScoreDisplay)

		var trianglePath = UIBezierPath()
		trianglePath.moveToPoint(CGPointMake(-0.5, -17))
		trianglePath.addLineToPoint(CGPointMake(14.66, 9.25))
		trianglePath.addLineToPoint(CGPointMake(-15.66, 9.25))
		trianglePath.closePath()

        puck = SKShapeNode(path: trianglePath.CGPath)
        puck.lineWidth = 6
        puck.strokeColor = SKColor.whiteColor()
        puck.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        puck.physicsBody = SKPhysicsBody(polygonFromPath: trianglePath.CGPath)
        puck.physicsBody!.categoryBitMask = PhysicsCategory.Puck.rawValue
        puck.physicsBody!.collisionBitMask = PhysicsCategory.Paddle.rawValue | PhysicsCategory.Wall.rawValue
        puck.physicsBody!.contactTestBitMask = PhysicsCategory.Paddle.rawValue | PhysicsCategory.Wall.rawValue
        puck.physicsBody!.dynamic = true
        puck.physicsBody!.restitution = 1
        puck.physicsBody!.allowsRotation = true
        puck.physicsBody!.linearDamping = 0
        puck.physicsBody!.angularDamping = 0
        puck.physicsBody!.friction = 0
        puck.physicsBody!.affectedByGravity = true
        puck.physicsBody!.usesPreciseCollisionDetection = true

        super.init(size: size)

        let emitter = SKEmitterNode(fileNamed: "Particle.sks")
        emitter.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(emitter)

        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zeroVector
        physicsWorld.speed = 0

        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody!.categoryBitMask = PhysicsCategory.Wall.rawValue

        addChild(opponentPaddle)
        addChild(playerPaddle)
        addChild(puck)

        backgroundColor = SKColor.blackColor()

        resetPuck()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Touch Responses

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            destX = touch.locationInNode(self).x
        }
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            destX = touch.locationInNode(self).x
        }
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        destX = playerPaddle.position.x
    }

    // MARK: Game Cycle

    func resetPuck() {
        let shouldGoToPlayer = arc4random() % 2 == 0
        let vector = CGVector(dx: shouldGoToPlayer ? playerPaddle.position.x - size.width / 2.0 : opponentPaddle.position.x - size.width / 2.0, dy: shouldGoToPlayer ? playerPaddle.position.y - size.height / 2.0 : opponentPaddle.position.y - size.height / 2.0)
        puck.physicsBody!.velocity = vector
        puck.physicsBody!.angularVelocity = CGFloat(arc4random()) % CGFloat(2 * M_PI)
        let moveAction = SKAction.moveTo(CGPoint(x: size.width / 2.0, y: size.height / 2.0), duration: 0)
        puck.runAction(SKAction.sequence([moveAction]))
    }

    func startGame() {
        physicsWorld.speed = 1
    }

    func stopGame() {
        physicsWorld.speed = 0
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

        puck.physicsBody!.angularVelocity = puck.physicsBody!.angularVelocity % (8 * CGFloat(M_PI))

        let pV = puck.physicsBody!.velocity
        let puckVelocity = sqrt(pV.dx * pV.dx + pV.dy * pV.dy)
        puck.physicsBody!.velocity = CGVector(dx: (pV.dx / puckVelocity) * 400, dy: (pV.dy / puckVelocity) * 400)

        if let lastUpdateTime = lastUpdateTime {
            let deltaTime = CGFloat(currentTime - lastUpdateTime)

            //Move Player Paddle
            let distance = playerPaddle.position.x - destX
            if distance > 10 {
                playerPaddle.position = CGPoint(x: max(50, playerPaddle.position.x - CGFloat(deltaTime) * 600), y: playerPaddle.position.y)
            } else if distance < -1 {
                playerPaddle.position = CGPoint(x: min(size.width - 50, playerPaddle.position.x + CGFloat(deltaTime) * 600), y: playerPaddle.position.y)
            }

            //Move Opponent Paddle
            if puck.position.x - opponentPaddle.position.x > 15 {
                opponentPaddle.position = CGPoint(x: opponentPaddle.position.x + deltaTime * 250.0, y: opponentPaddle.position.y)
                if opponentPaddle.position.x > size.width - 59 {
                    opponentPaddle.position = CGPoint(x: size.width - 50, y: opponentPaddle.position.y)
                }
            } else if puck.position.x - opponentPaddle.position.x < -15 {
                opponentPaddle.position = CGPoint(x: opponentPaddle.position.x - deltaTime * 250.0, y: opponentPaddle.position.y)
                if opponentPaddle.position.x < 50 {
                    opponentPaddle.position = CGPoint(x: 50, y: opponentPaddle.position.y)
                }
            }
			
			if puck.position.x > size.width + 100 || puck.position.x < -100{
				resetPuck()
			}
			
        }
        lastUpdateTime = currentTime
    }
}

// MARK: GameScene + SKPhysicsContactDelegate

extension GameScene: SKPhysicsContactDelegate {

    func didBeginContact(contact: SKPhysicsContact) {
        let categories: [UInt32] = [contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask]
        if contains(categories, PhysicsCategory.Paddle.rawValue) {
            if NSDate().timeIntervalSinceDate(lastPaddleBeepTime) > 0.5 {
                runAction(beepSound)
                lastPaddleBeepTime = NSDate()
            }
        } else if contains(categories, PhysicsCategory.Wall.rawValue) {
            if puck.position.y < 50 {
                //Point Opponent
                opponentScore++
                resetPuck()
                runAction(coinSound)
            } else if puck.position.y > size.height - 50 {
                //Point Player
                playerScore++
                resetPuck()
                runAction(coinSound)
            }
        }
    }

}
