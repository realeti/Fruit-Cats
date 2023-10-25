//
//  Extensions.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 06.10.2023.
//

import UIKit

enum StrokeColor {
    case orange
    case blue
    case gray
    case none
}

struct GameText {
    static func getAttributedText(for text: String, size: CGFloat, strokeWidth: CGFloat, strokeColor color: StrokeColor) -> NSAttributedString {
        let strokeColor: UIColor
        
        switch color {
        case .orange:
            strokeColor = UIColor(red: 1.0, green: 123.0/255.0, blue: 0.0, alpha: 1.0)
        case .blue:
            strokeColor = UIColor(red: 0.0, green: 11.0/255.0, blue: 1.0, alpha: 1.0)
        case .gray:
            strokeColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0)
        case .none:
            strokeColor = .clear
        }
        
        let attrText = NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.strokeColor: strokeColor,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.strokeWidth: strokeWidth,
                NSAttributedString.Key.font: UIFont(name: Constants.fontName, size: size) ?? UIFont.systemFont(ofSize: size)
            ]
        )
        
        return attrText
    }
}
