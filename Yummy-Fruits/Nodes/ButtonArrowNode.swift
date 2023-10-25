//
//  ButtonArrowNode.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 02.10.2023.
//

import SpriteKit

class ButtonArrowNode: SKSpriteNode {
    init(_ buttonArrow: ButtonArrow) {
        let texture = SKTexture(imageNamed: buttonArrow.sprite)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        xScale = buttonArrow.xScale
        yScale = buttonArrow.yScale
        alpha = 0.75
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
