//
//  RareFruitsMock.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 03.10.2023.
//

import Foundation

final class RareFruitMock {
    static var getMockRareFruits: [RareFruitProtocol] {
        var resultArr: [RareFruitProtocol] = []
        
        RareFruitsType.allCases.forEach { rareFruit in
            resultArr.append(RareFruit(type: rareFruit, collected: 0))
        }
        
        return resultArr
    }
}
