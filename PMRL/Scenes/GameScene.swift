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
        physicsBody = Positions.physicsBody
    }
    
    func setupField() {
        backgroundColor = Colors.topColor
        
        bottomRectangle = Positions.bottomRectangle
        bottomRectangle.name = "Bottom Cannons"
        bottomRectangle.fillColor = Colors.bottomColor
        bottomRectangle.strokeColor = Colors.bottomColor
        bottomRectangle.position = Positions.bottomRectanglePosition
        bottomRectangle.physicsBody = Positions.bottomRectanglePhysicsBody
        bottomRectangle.physicsBody?.isDynamic = false
        bottomRectangle.physicsBody?.categoryBitMask = PhysicsCategories.wall
        bottomRectangle.physicsBody?.affectedByGravity = false
        bottomRectangle.zPosition = ZPositions.wall
        bottomCutoff = Positions.bottomCutoff
        addChild(bottomRectangle)
        
        topRectangle = Positions.topRectangle
        topRectangle.name = "Top Cannons"
        topRectangle.fillColor = Colors.topColor
        topRectangle.strokeColor = Colors.topColor
        topRectangle.position = Positions.topRectanglePosition
        topRectangle.physicsBody = Positions.topRectanglePhysicsBody
        topRectangle.physicsBody?.isDynamic = false
        topRectangle.physicsBody?.categoryBitMask = PhysicsCategories.wall
        topRectangle.physicsBody?.affectedByGravity = false
        topRectangle.zPosition = ZPositions.wall
        topCutoff = Positions.topCutoff
        addChild(topRectangle)
        
        let field = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height-bottomRectangle.frame.height*2))
        field.name = "Field"
        field.fillColor = Colors.backgroundColor
        field.strokeColor = Colors.backgroundColor
        field.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(field)
        
        soccerBall = SKShapeNode(circleOfRadius: Positions.soccerBallRadius)
        soccerBall.name = "Soccer Ball"
        soccerBall.fillColor = Colors.ballColor
        soccerBall.strokeColor = Colors.ballColor
        soccerBall.position = CGPoint(x: frame.midX, y: frame.midY)
        soccerBall.physicsBody = SKPhysicsBody(circleOfRadius: Positions.soccerBallRadius)
        soccerBall.physicsBody?.isDynamic = true
        soccerBall.physicsBody?.categoryBitMask = PhysicsCategories.soccerBall
        soccerBall.physicsBody?.contactTestBitMask = PhysicsCategories.wall
        soccerBall.physicsBody?.affectedByGravity = false
        soccerBall.physicsBody?.linearDamping = VariableValues.soccerBallLinearDamping
        soccerBall.physicsBody?.mass = VariableValues.soccerBallMass
        soccerBall.zPosition = ZPositions.ball
        addChild(soccerBall)
        
        let yourline = SKShapeNode()
        let pathToDraw = CGMutablePath()
        pathToDraw.move(to: CGPoint(x: frame.width, y: Positions.fieldLineY))
        pathToDraw.addLine(to: CGPoint(x: 0, y: Positions.fieldLineY))
        yourline.path = pathToDraw
        yourline.strokeColor = Colors.lineColor
        yourline.zPosition = ZPositions.line
        addChild(yourline)
        print(frame.width, frame.height)

        topScoreLabel.fontName = "AvenirNext-Bold"
        topScoreLabel.fontSize = Positions.fontSize
        topScoreLabel.fontColor = Colors.lineColor
        topScoreLabel.position = CGPoint(x: frame.maxX-Positions.fontSize, y: frame.midY-Positions.fontSize)
        topScoreLabel.zRotation = Positions.fontRotation
        topScoreLabel.zPosition = ZPositions.label
        addChild(topScoreLabel)
        bottomScoreLabel.fontName = "AvenirNext-Bold"
        bottomScoreLabel.fontSize = Positions.fontSize
        bottomScoreLabel.fontColor = Colors.lineColor
        bottomScoreLabel.position = CGPoint(x: frame.maxX-Positions.fontSize, y: frame.midY+Positions.fontSize)
        bottomScoreLabel.zRotation = Positions.fontRotation
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
            dy = VariableValues.ballSpeedY
        } else if touchLocation.y > topCutoff {
            dy = -VariableValues.ballSpeedY
            color = Colors.topColor
            cutoff = topCutoff
        } else {
            return
        }
        
        let ball = SKShapeNode(circleOfRadius: VariableValues.ballRadius)
        ball.fillColor = color
        ball.strokeColor = color
        ball.position = CGPoint(x: touchLocation.x, y: cutoff!)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: VariableValues.ballRadius)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.categoryBitMask = PhysicsCategories.shootBall
        ball.physicsBody?.collisionBitMask = PhysicsCategories.soccerBall|PhysicsCategories.shootBall
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.velocity = CGVector(dx: VariableValues.ballSpeedX, dy: dy)
        ball.zPosition = ZPositions.ball
        
        addChild(ball)
        
        let removeDynamic = SKAction.customAction(withDuration: 0) {
            node, elapsedTime in
            
            if let node = node as? SKSpriteNode {
                node.physicsBody?.isDynamic = false
            }
        }
        
        ball.run(SKAction.sequence([SKAction.wait(forDuration: VariableValues.ballDuration), removeDynamic, SKAction.fadeAlpha(to: 0, duration: 1), SKAction.removeFromParent()]))
    }
    
    func updateScoreLabel(_ winner: Players) {
        if winner == Players.top {
            topScore += 1
            topScoreLabel.text = "\(topScore)"
        } else {
            bottomScore += 1
            bottomScoreLabel.text = "\(bottomScore)"
        }
    }
}


extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if contactMask == PhysicsCategories.soccerBall | PhysicsCategories.wall {
            if contact.bodyA.node!.position.y > frame.height/2 {
                updateScoreLabel(Players.top)
            } else {
                updateScoreLabel(Players.bottom)
            }
            removeAllChildren()
            setupField()
            setupPhysics()
        }
    }
}
