//
//  FruitCat.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 28.09.2023.
//

import SpriteKit

enum Direction: Int {
    case left
    case right
}

class FruitCatNode: SKSpriteNode {
    init(_ fruitCat: FruitCat) {
        let texture = SKTexture(imageNamed: fruitCat.sprite)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        xScale = fruitCat.xScale
        yScale = fruitCat.yScale
        
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: size.height))
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategory.player
        physicsBody?.contactTestBitMask = PhysicsCategory.fruit | PhysicsCategory.heart
        physicsBody?.collisionBitMask = PhysicsCategory.none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func movePlayer(_ direction: Direction, sceneSize: CGSize) {
        let maxWidth = sceneSize.width / 2
        
        switch direction {
        case .left:
            if position.x <= -maxWidth + frame.width / 2 {
                return
            }
            
            let playerDirectionOfView = xScale > 0 ? -xScale : xScale
            xScale = playerDirectionOfView
            
            let actionMove = SKAction.moveTo(x: position.x - Constants.playerMoveDistance, duration: 0.04)
            run(actionMove)
        case .right:
            if position.x >= maxWidth - frame.width / 2 {
                return
            }
            
            let playerDirectionOfView = xScale < 0 ? -xScale : xScale
            xScale = playerDirectionOfView
            
            let actionMove = SKAction.moveTo(x: position.x + Constants.playerMoveDistance, duration: 0.04)
            run(actionMove)
        }
    }
}
