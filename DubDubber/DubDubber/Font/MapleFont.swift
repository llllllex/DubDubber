//
//  MapleFont.swift
//  Fancer
//
//  Created by Lex on 3/21/25.
//

import Foundation
import SwiftUI

enum MapleFont {
    
    private static let familyName = "MapleMono-NF-CN"
    
    static func font(weight: Font.Weight, isItalic: Bool, size: CGFloat, relativeTo fontStyle: Font.TextStyle) -> Font {
        var weightName = ""
        switch weight {
        case .ultraLight: weightName = "ExtraLight"
        case .thin: weightName = "Thin"
        case .light: weightName = "Light"
        case .regular: weightName = "Regular"
        case .medium: weightName = "Medium"
        case .semibold: weightName = "SemiBold"
        case .bold: weightName = "Bold"
        case .heavy, .black: fatalError()
        default: fatalError()
        }
        let name = familyName + "-" + weightName + (isItalic ? "Italic" : "")
        return Font.custom(name, size: size, relativeTo: fontStyle)
    }
}
