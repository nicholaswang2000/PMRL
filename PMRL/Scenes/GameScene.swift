//
//  GameScene.swift
//  PMRL
//
//  Created by Nicholas Wang on 2021-08-02.
//

import SpriteKit

class GameScene: SKScene {
    
    var bottomRectangle: SKShapeNode!
    var topRectangle: SKShapeNode!
    var soccerBall: SKShapeNode!
    var topCutoff: CGFloat!
    var bottomCutoff: CGFloat!
    var topScoreLabel = SKLabelNode(text: "0")
    var bottomScoreLabel = SKLabelNode(text: "0")
    var pauseButton: SKSpriteNode!
    var settingsButton: SKSpriteNode!
    var pauseScene: SKSpriteNode!
    var playButton: SKSpriteNode!
    var topScore = 0
    var bottomScore = 0
    var topBallsLeft = VariableValues.startBalls
    var bottomBallsLeft = VariableValues.startBalls
    var timerTop = Timer()
    var timerBottom = Timer()
    
    
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
        
        pauseButton = SKSpriteNode(imageNamed: "pause")
        pauseButton.size = CGSize(width: Positions.pauseButtonSize, height: Positions.pauseButtonSize)
        pauseButton.zRotation = -.pi/2
        pauseButton.zPosition = ZPositions.label
        pauseButton.color = Colors.lineColor
        pauseButton.colorBlendFactor = 1.0
        pauseButton.name = "Pause"
        pauseButton.position = CGPoint(x: Positions.pauseButtonX, y: Positions.pauseButtonY)
        addChild(pauseButton)
        
        settingsButton = SKSpriteNode(imageNamed: "settings")
        settingsButton.size = CGSize(width: Positions.settingsButtonSize, height: Positions.settingsButtonSize)
        settingsButton.zRotation = -.pi/2
        settingsButton.zPosition = ZPositions.label
        settingsButton.color = Colors.lineColor
        settingsButton.colorBlendFactor = 1.0
        settingsButton.name = "Settings"
        settingsButton.position = CGPoint(x: Positions.settingsButtonX, y: Positions.settingsButtonY)
        addChild(settingsButton)
        
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

        topScoreLabel.fontName = "AvenirNext-Bold"
        topScoreLabel.fontSize = Positions.fontSize
        topScoreLabel.fontColor = Colors.lineColor
        topScoreLabel.position = Positions.topScoreLabelPosition
        topScoreLabel.zRotation = Positions.fontRotation
        topScoreLabel.zPosition = ZPositions.label
        addChild(topScoreLabel)
        bottomScoreLabel.fontName = "AvenirNext-Bold"
        bottomScoreLabel.fontSize = Positions.fontSize
        bottomScoreLabel.fontColor = Colors.lineColor
        bottomScoreLabel.position = Positions.bottomScoreLabelPosition
        bottomScoreLabel.zRotation = Positions.fontRotation
        bottomScoreLabel.zPosition = ZPositions.label
        addChild(bottomScoreLabel)
        
        
        
        scheduledAddToTop()
        scheduledAddToBottom()
    }
    
    func scheduledAddToTop() {
        timerTop = Timer.scheduledTimer(timeInterval: VariableValues.regen, target: self, selector: #selector(addTop), userInfo: nil, repeats: true)
    }
    
    @objc func addTop() {
        if topBallsLeft >= VariableValues.maxBalls {
            return
        }
        topBallsLeft += 1
    }
    
    func scheduledAddToBottom() {
        timerBottom = Timer.scheduledTimer(timeInterval: VariableValues.regen, target: self, selector: #selector(addBottom), userInfo: nil, repeats: true)
    }
    
    @objc func addBottom() {
        if bottomBallsLeft >= VariableValues.maxBalls {
            return
        }
        bottomBallsLeft += 1
    }
    
    func pauseGame() {
        pauseScene = SKSpriteNode(color: UIColor.black, size: frame.size)
        pauseScene.alpha = 0.75
        pauseScene.name = "Paused Scene"
        pauseScene.zPosition = 100
        pauseScene.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(pauseScene)
        
        playButton = SKSpriteNode(imageNamed: "play")
        playButton.size = CGSize(width: Positions.playButtonSize, height: Positions.playButtonSize)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        playButton.zPosition = 101
        addChild(playButton)
        
        self.scene?.isPaused = true
    }
    
    func resumeGame() {
        pauseScene.removeFromParent()
        playButton.removeFromParent()
        self.scene?.isPaused = false
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
        
        let touchedNodes = nodes(at: touchLocation)
        for node in touchedNodes {
            if node.name == "Pause" {
                timerTop.invalidate()
                timerBottom.invalidate()
                pauseGame()
            }
            if node.name == "Paused Scene" {
                timerTop = Timer.scheduledTimer(timeInterval: VariableValues.regen, target: self, selector: #selector(addTop), userInfo: nil, repeats: true)
                timerBottom = Timer.scheduledTimer(timeInterval: VariableValues.regen, target: self, selector: #selector(addBottom), userInfo: nil, repeats: true)
                resumeGame()
            }
        }
        
        if touchLocation.y < bottomCutoff {
            dy = VariableValues.ballSpeedY
            if topBallsLeft == 0 {
                return
            }
            topBallsLeft -= 1
        } else if touchLocation.y > topCutoff {
            dy = -VariableValues.ballSpeedY
            if bottomBallsLeft == 0 {
                return
            }
            bottomBallsLeft -= 1
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
        
        ball.run(SKAction.sequence([SKAction.wait(forDuration: VariableValues.ballDuration), SKAction.fadeAlpha(to: 0, duration: 1), SKAction.removeFromParent()]))
    }
    
    func updateScoreLabel(_ winner: Players) {
        if winner == Players.top {
            topScore += 1
            topScoreLabel.text = "\(topScore)"
            //topScoreLabel.run(SKAction.sequence([SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY-Positions.rectangleHeight/4), duration: 0.0), SKAction.wait(forDuration: 1.0), SKAction.move(to: Positions.topScoreLabelPosition, duration: 1.0)]))
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
            timerTop.invalidate()
            timerBottom.invalidate()
            topBallsLeft = VariableValues.startBalls
            bottomBallsLeft = VariableValues.startBalls
            removeAllChildren()
            setupField()
            setupPhysics()
        }
    }
}
