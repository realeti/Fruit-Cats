//
//  Fruit.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 29.09.2023.
//

import SpriteKit

class FruitNode: SKSpriteNode {
    init(_ fruit: Fruit, physic: Bool) {
        let texture = SKTexture(imageNamed: fruit.type)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        name = fruit.type
        xScale = fruit.xScale
        yScale = fruit.yScale
        
        if physic {
            physicsBody = SKPhysicsBody(rectangleOf: size)
            physicsBody?.usesPreciseCollisionDetection = true
            physicsBody?.isDynamic = true
            physicsBody?.categoryBitMask = PhysicsCategory.fruit
            physicsBody?.contactTestBitMask = PhysicsCategory.player
            physicsBody?.collisionBitMask = PhysicsCategory.none
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
