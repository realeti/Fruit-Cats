//
//  SkinsMock.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 10.10.2023.
//

import Foundation

final class SkinsMock {
    static var getSkinsMock: [SkinProtocol] {
        var resultArr: [SkinProtocol] = []
        
        SkinType.allCases.forEach { skin in
            resultArr.append(Skin(
                type: skin,
                isLocked: (skin == .banana) ? false : true,
                isSelected: (skin == .banana) ? true : false,
                record: 0)
            )
        }
        return resultArr
    }
}
