//
//  CGFloat.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 09.10.2023.
//

import Foundation

extension CGFloat {
    func rounded(toPlaces places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}
