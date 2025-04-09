//
//  View+Extensions.swift
//  Fancer
//
//  Created by Lex on 3/21/25.
//

import Foundation
import SwiftUI

extension SwiftUI.View {
    
    func mapleFont(
        weight: Font.Weight = .regular,
        isItalic: Bool = false,
        size: CGFloat,
        relativeTo textStyle: Font.TextStyle = .body
    ) -> some View {
        self.font(
            MapleFont
                .font(
                    weight: weight,
                    isItalic: isItalic,
                    size: size,
                    relativeTo: textStyle
                )
        )
    }
    
    func mapleFont(
        weight: Font.Weight = .regular,
        isItalic: Bool = false,
        textStyle: Font.TextStyle = .body
    ) -> some View {
        self.mapleFont(
            weight: weight,
            isItalic: isItalic,
            size: textStyle.defaultPointSize,
            relativeTo: textStyle
        )
    }
    
    func mapleFont(
        _ weight: Font.Weight = .regular
    ) -> some View {
        self.mapleFont(
            weight: weight,
            isItalic: false,
            size: Font.TextStyle.body.defaultPointSize,
            relativeTo: .body
        )
    }
    
    func mapleFont(
        weight: Font.Weight = .regular,
        textStyle: Font.TextStyle = .body
    ) -> some View {
        self.mapleFont(
            weight: weight,
            isItalic: false,
            size: textStyle.defaultPointSize,
            relativeTo: textStyle
        )
    }
    
    func mapleFont(
        _ textStyle: Font.TextStyle = .body
    ) -> some View {
        self.mapleFont(
            weight: .regular,
            isItalic: false,
            size: textStyle.defaultPointSize,
            relativeTo: textStyle
        )
    }
    
    func mapleFont() -> some View {
        self.mapleFont(
            weight: .regular,
            isItalic: false,
            size: Font.TextStyle.body.defaultPointSize,
            relativeTo: .body
        )
    }
}

extension SwiftUI.Font.TextStyle {
    var defaultPointSize: CGFloat {
        switch self {
        case .largeTitle:
            return 34
        case .title:
            return 28
        case .title2:
            return 22
        case .title3:
            return 20
        case .headline:
            return 17
        case .body:
            return 17
        case .callout:
            return 16
        case .subheadline:
            return 15
        case .footnote:
            return 13
        case .caption:
            return 12
        case .caption2:
            return 11
        @unknown default:
            fatalError()
        }
    }
}

//@MainActor
//var fontCompare: some View {
//    VStack {
//        HStack {
//            Text("HeadLine")
//                .mapleFont(textStyle: .headline)
//            Text("HeadLine")
//                .font(.headline)
//        }
//        HStack {
//            Text("Body")
//                .mapleFont(textStyle: .body)
//            Text("Body")
//                .font(.body)
//        }
//        HStack {
//            Text("Caption2")
//                .mapleFont(textStyle: .caption2)
//            Text("Caption2")
//                .font(.caption2)
//        }
//        HStack {
//            Text("LargeTitle")
//                .mapleFont(textStyle: .largeTitle)
//            Text("LargeTitle")
//                .font(.largeTitle)
//        }
//        HStack {
//            Text("Footnote")
//                .mapleFont(textStyle: .footnote)
//            Text("Footnote")
//                .font(.footnote)
//        }
//        HStack {
//            Text("subHeadline")
//                .mapleFont(textStyle: .subheadline)
//            Text("subHeadline")
//                .font(.subheadline)
//        }
//        HStack {
//            Text("Caption")
//                .mapleFont(textStyle: .caption)
//            Text("Caption")
//                .font(.caption)
//        }
//    }
//}
