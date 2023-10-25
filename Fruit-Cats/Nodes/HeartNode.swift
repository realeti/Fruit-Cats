//
//  HeartNode.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 08.10.2023.
//

import SpriteKit

class HeartNode: SKSpriteNode {
    init(_ heart: Heart) {
        let texture = SKTexture(imageNamed: heart.sprite)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        name = heart.sprite
        xScale = heart.xScale
        yScale = heart.yScale
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategory.heart
        physicsBody?.contactTestBitMask = PhysicsCategory.player
        physicsBody?.collisionBitMask = PhysicsCategory.none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
