//
//  SkinProtocol.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 10.10.2023.
//

import Foundation

protocol SkinProtocol {
    var type: SkinType { get }
    var isLocked: Bool { get set }
    var isSelected: Bool { get set }
    var record: Int { get set }
}
