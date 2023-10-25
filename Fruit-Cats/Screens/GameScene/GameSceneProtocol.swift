//
//  GameSceneProtocol.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 05.10.2023.
//

import Foundation

protocol GameSceneProtocol: AnyObject {
    func updateScore(score: Int)
    func updateHearts(heart: HeartList, isSubtract: Bool)
    func updateLevel(level: Int)
    func pauseGame()
    func loadGameOverScene(score: Int)
}
