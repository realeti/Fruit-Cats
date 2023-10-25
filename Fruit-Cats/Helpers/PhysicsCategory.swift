//
//  PhysicsCategory.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 29.09.2023.
//

import Foundation

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let all: UInt32 = .max
    static let fruit: UInt32 = 0b1 // 1
    static let heart: UInt32 = 0b10 // 2
    static let player: UInt32 = 0b11 // 3
    static let grass: UInt32 = 0b100 // 4
}
