//
//  Settings.swift
//  PMRL
//
//  Created by Nicholas Wang on 2021-08-02.
//

import SpriteKit

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
