//
//  GameScene.swift
//  PMRL
//
//  Created by Nicholas Wang on 2021-08-02.
//

import SpriteKit

enum PlayerColors {
    static let colors = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
}

class GameScene: SKScene {
    
    var bottomRectangle: SKShapeNode!
    var topRectangle: SKShapeNode!
    var soccerBall: SKShapeNode!
    var topCutoff: CGFloat!
    var bottomCutoff: CGFloat!
    var topScoreLabel = SKLabelNode(text: "0")
    var bottomScoreLabel = SKLabelNode(text: "0")
    var topScore = 0
    var bottomScore = 0
    
    
    override func didMove(to view: SKView) {
        setupField()
        setupPhysics()
    }
    
    func setupPhysics() {
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: -1000, width: frame.width, height: frame.height+2000))
    }
    
    func setupField() {
        backgroundColor = Colors.topColor
        
        bottomRectangle = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height/15))
        bottomRectangle.name = "Bottom Cannons"
        bottomRectangle.fillColor = Colors.bottomColor
        bottomRectangle.strokeColor = Colors.bottomColor
        bottomRectangle.position = CGPoint(x: frame.midX, y: frame.minY + frame.height/15)
        bottomRectangle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: frame.height/15))
        bottomRectangle.physicsBody?.isDynamic = false
        bottomRectangle.physicsBody?.categoryBitMask = PhysicsCategories.wall
        bottomRectangle.physicsBody?.affectedByGravity = false
        bottomRectangle.zPosition = ZPositions.wall
        bottomCutoff = frame.minY + frame.height/15 + frame.height/30
        addChild(bottomRectangle)
        
        topRectangle = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height/15))
        topRectangle.name = "Top Cannons"
        topRectangle.fillColor = Colors.topColor
        topRectangle.strokeColor = Colors.topColor
        topRectangle.position = CGPoint(x: frame.midX, y: frame.maxY - frame.height/15)
        topRectangle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: frame.height/15))
        topRectangle.physicsBody?.isDynamic = false
        topRectangle.physicsBody?.categoryBitMask = PhysicsCategories.wall
        topRectangle.physicsBody?.affectedByGravity = false
        topRectangle.zPosition = ZPositions.wall
        topCutoff = frame.maxY - frame.height/15 - frame.height/30
        addChild(topRectangle)
        
        let field = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height-bottomRectangle.frame.height*2))
        field.name = "Field"
        field.fillColor = Colors.backgroundColor
        field.strokeColor = Colors.backgroundColor
        field.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(field)
        
        soccerBall = SKShapeNode(circleOfRadius: frame.width/20)
        soccerBall.name = "Soccer Ball"
        soccerBall.fillColor = Colors.ballColor
        soccerBall.strokeColor = Colors.ballColor
        soccerBall.position = CGPoint(x: frame.midX, y: frame.midY)
        
        soccerBall.physicsBody = SKPhysicsBody(circleOfRadius: frame.width/20)
        soccerBall.physicsBody?.isDynamic = true
        soccerBall.physicsBody?.categoryBitMask = PhysicsCategories.soccerBall
        soccerBall.physicsBody?.contactTestBitMask = PhysicsCategories.wall
        soccerBall.physicsBody?.affectedByGravity = false
        soccerBall.physicsBody?.linearDamping = 2
        soccerBall.physicsBody?.mass = 0.001
        soccerBall.zPosition = ZPositions.ball
        
        addChild(soccerBall)
        
        
        let yourline = SKShapeNode()
        let pathToDraw = CGMutablePath()
        pathToDraw.move(to: CGPoint(x: frame.width, y: frame.height/2))
        pathToDraw.addLine(to: CGPoint(x: 0, y: frame.height/2))
        yourline.path = pathToDraw
        yourline.strokeColor = Colors.lineColor
        yourline.zPosition = ZPositions.line
        addChild(yourline)
        
        
        topScoreLabel.fontName = "AvenirNext-Bold"
        topScoreLabel.fontSize = 50.0
        topScoreLabel.fontColor = Colors.lineColor
        topScoreLabel.position = CGPoint(x: frame.maxX-50, y: frame.midY-40)
        topScoreLabel.zRotation = -.pi/2
        topScoreLabel.zPosition = ZPositions.label
        addChild(topScoreLabel)
        bottomScoreLabel.fontName = "AvenirNext-Bold"
        bottomScoreLabel.fontSize = 50.0
        bottomScoreLabel.fontColor = Colors.lineColor
        bottomScoreLabel.position = CGPoint(x: frame.maxX-50, y: frame.midY+40)
        bottomScoreLabel.zRotation = -.pi/2
        bottomScoreLabel.zPosition = ZPositions.label
        addChild(bottomScoreLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        // Play audio
        
        let touchLocation = touch.location(in: self)
        var dy = 0
        var color = Colors.bottomColor
        var cutoff = bottomCutoff
        
        if touchLocation.y < bottomCutoff {
            dy = 500
        } else if touchLocation.y > topCutoff {
            dy = -500
            color = Colors.topColor
            cutoff = topCutoff
        } else {
            return
        }
        
        let ball = SKShapeNode(circleOfRadius: frame.size.width/50)
        ball.fillColor = color
        ball.strokeColor = color
        ball.position = CGPoint(x: touchLocation.x, y: cutoff!)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: frame.size.width/50)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.categoryBitMask = PhysicsCategories.shootBall
        ball.physicsBody?.collisionBitMask = PhysicsCategories.soccerBall|PhysicsCategories.shootBall
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: dy)
        ball.zPosition = ZPositions.ball
        
        addChild(ball)
        
        ball.run(SKAction.sequence([SKAction.wait(forDuration: 2.5), SKAction.fadeAlpha(to: 0, duration: 1), SKAction.removeFromParent()]))
    }
    
    func updateScoreLabel() {
        topScoreLabel.text = "\(topScore)"
        bottomScoreLabel.text = "\(bottomScore)"
    }
    
}


extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if contactMask == PhysicsCategories.soccerBall | PhysicsCategories.wall {
            if contact.bodyA.node!.position.y > frame.height/2 {
                bottomScore += 1
                
            } else {
                topScore += 1
            }
            removeAllChildren()
            updateScoreLabel()
            setupField()
            setupPhysics()
        }
        
    }
    
}
