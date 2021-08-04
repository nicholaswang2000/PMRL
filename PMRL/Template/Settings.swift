//
//  Settings.swift
//  PMRL
//
//  Created by Nicholas Wang on 2021-08-02.
//

import SpriteKit
import Foundation

enum PhysicsCategories {
    static let none: UInt32 = 0
    static let shootBall: UInt32 = 0x1
    static let soccerBall: UInt32 = 0x1 << 1
    static let wall: UInt32 = 0x1 << 2
}

enum ZPositions {
    static let line: CGFloat = 0
    static let ball: CGFloat = 1
    static let label: CGFloat = 2
    static let wall: CGFloat = 3
}

enum Colors {
    static let topColor: SKColor = SKColor(red: 0.80, green: 0.75, blue: 0.83, alpha: 1.00)
    static let bottomColor: SKColor = SKColor(red: 0.80, green: 0.75, blue: 0.83, alpha: 1.00)
    static let backgroundColor: SKColor = SKColor(red: 1.00, green: 0.92, blue: 0.98, alpha: 1.00)
    static let ballColor: SKColor = SKColor(red: 0.51, green: 0.55, blue: 0.62, alpha: 1.00)
    static let lineColor: SKColor = SKColor(red: 0.56, green: 0.60, blue: 0.69, alpha: 1.00)
}

enum Players {
    case top
    case bottom
}


enum Positions {
    static let physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: -1000, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+2000))
    
    // Variables
    static let rectangleHeight = UIScreen.main.bounds.height/15
    static let rectangleWidth = UIScreen.main.bounds.width
    
    // Bottom Rectangle
    static let bottomRectangle = SKShapeNode(rectOf: CGSize(width: rectangleWidth, height: rectangleHeight))
    static let bottomRectanglePosition = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.minY + rectangleHeight)
    static let bottomRectanglePhysicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rectangleWidth, height: rectangleHeight))
    static let bottomCutoff = UIScreen.main.bounds.minY + rectangleHeight + rectangleHeight/2
    
    // Top Rectangle
    static let topRectangle = SKShapeNode(rectOf: CGSize(width: rectangleWidth, height: rectangleHeight))
    static let topRectanglePosition = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY - rectangleHeight)
    static let topRectanglePhysicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rectangleWidth, height: rectangleHeight))
    static let topCutoff = UIScreen.main.bounds.maxY - rectangleHeight - rectangleHeight/2
    
    // Soccer Ball
    static let soccerBallRadius = UIScreen.main.bounds.width/20
    
    // Labels
    static let topScoreLabelPosition = CGPoint(x: UIScreen.main.bounds.maxX-Positions.fontSize, y: UIScreen.main.bounds.midY-Positions.fontSize)
    static let bottomScoreLabelPosition = CGPoint(x: UIScreen.main.bounds.maxX-Positions.fontSize, y: UIScreen.main.bounds.midY+Positions.fontSize)
    
    // Field line
    static let fieldLineY = UIScreen.main.bounds.height/2
    
    // Label font
    static let fontSize = UIScreen.main.bounds.width * 0.1282
    static let fontRotation: CGFloat = CGFloat(-Double.pi/2)
}

enum VariableValues {
    static let soccerBallLinearDamping: CGFloat = 2.0
    static let soccerBallMass: CGFloat = 0.001
    
    static let ballDuration: TimeInterval = 2.5
    static let ballSpeedX: Int = 0
    static let ballSpeedY: Int = 500
    static let ballRadius =  UIScreen.main.bounds.size.width/50
    
    static let regen: TimeInterval = 0.8
    
    static let maxBalls = 20
    static let startBalls = 10
}
