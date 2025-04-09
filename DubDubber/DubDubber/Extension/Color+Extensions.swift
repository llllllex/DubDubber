//
//  Color+Extensions.swift
//  Fancer
//
//  Created by Lex on 3/21/25.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

extension Color: @retroactive RawRepresentable {
    
    public typealias RawValue = String
    
    public init?(rawValue: RawValue) {
#if canImport(AppKit)
        let color = NSColor(hex: rawValue)
        self = Color(nsColor: color)
#elseif canImport(UIKit)
        let color = UIColor(hex: rawValue)
        self = Color(color.cgColor)
#else
        if let color = colorWithRGBAHexString(rawValue) {
            self = color
        }
#endif
    }
    
    public init(hex: RawValue) {
#if canImport(AppKit)
        let color = NSColor(hex: hex)
        self = Color(nsColor: color)
#elseif canImport(UIKit)
        let color = UIColor(hex: hex)
        self = Color(color.cgColor)
#else
        if let color = colorWithRGBAHexString(hex) {
            self = color
        } else {
            self = Color.primary
        }
#endif
    }
    
    public var rawValue: String {
#if canImport(AppKit)
        let color = NSColor(self)
        return color.hexString
#elseif canImport(UIKit)
        let color = UIColor(self)
        return color.hexString
#else
        
#endif
    }
}

extension Color {
    
    func rgba() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
#if canImport(AppKit)
        let color = NSColor(self)
        return color.rgba()
#elseif canImport(UIKit)
        let color = UIColor(self)
        return color.rgba()
#else
        
#endif
    }
    
    func hsba() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
#if canImport(AppKit)
        let color = NSColor(self)
        return color.hsba()
#elseif canImport(UIKit)
        let color = UIColor(self)
        return color.hsba()
#else
        
#endif
    }
    
    func wa() -> (CGFloat, CGFloat) {
#if canImport(AppKit)
        let color = NSColor(self)
        return color.wa()
#elseif canImport(UIKit)
        let color = UIColor(self)
        return color.wa()
#else
        
#endif
    }
}

extension Color {
    
    var lowdown: Color {
        self.brightness(ratio: 0.5)
    }
    
    func brightness(_ b: CGFloat) -> Color {
        let (h,s,_,a) = self.hsba()
        let newBrightness = max(0, min(1, b))
        return Color(
            hue: h,
            saturation: s,
            brightness: newBrightness,
            opacity: a
        )
    }
    
    func brightness(ratio: CGFloat) -> Color {
        let (h,s,b,a) = self.hsba()
        let newBrightness = max(0, min(1, b*ratio))
        return Color(
            hue: h,
            saturation: s,
            brightness: newBrightness,
            opacity: a
        )
    }
    
    func saturation(_ s: CGFloat) -> Color {
        let (h, _, b, a) = self.hsba()
        let newSaturation = max(0, min(1, s))
        return Color(
            hue: h,
            saturation: newSaturation,
            brightness: b,
            opacity: a
        )
    }
    
    func saturation(ratio: CGFloat) -> Color {
        let (h, s, b, a) = self.hsba()
        let newSaturation = max(0, min(1, s*ratio))
        return Color(
            hue: h,
            saturation: newSaturation,
            brightness: b,
            opacity: a
        )
    }
}

public extension SwiftUI.Color {
    
    func reversedGrayScale() -> Color {
        let (w, a) = self.wa()
        return Color(white: (1.0-w), opacity: a)
    }
}

extension SwiftUI.Color {
    
    static func systemBackground(_ colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? Color(hex: "000000") : Color(hex: "FFFFFF")
    }
    
    static func secondarySystemBackground(_ colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? Color(hex: "1C1C1E") : Color(hex: "F2F2F7")
    }
    
    static func tertiarySystemBackground(_ colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? Color(hex: "2C2C2E") : Color(hex: "EFEFF4")
    }
}

extension SwiftUI.Color {
    static func blendedColor(foreground: Color, background: Color, alpha: Double) -> Color {
        // 提取原始 UIColor 以访问 RGB
        let fg = UIColor(foreground)
        let bg = UIColor(background)

        var fr: CGFloat = 0, fgG: CGFloat = 0, fb: CGFloat = 0, fa: CGFloat = 0
        var br: CGFloat = 0, bgG2: CGFloat = 0, bb: CGFloat = 0, ba: CGFloat = 0

        fg.getRed(&fr, green: &fgG, blue: &fb, alpha: &fa)
        bg.getRed(&br, green: &bgG2, blue: &bb, alpha: &ba)

        let r = fr * alpha + br * (1 - alpha)
        let g = fgG * alpha + bgG2 * (1 - alpha)
        let b = fb * alpha + bb * (1 - alpha)

        return Color(red: Double(r), green: Double(g), blue: Double(b))
    }
    
    func blendedColor(foreground: Color, alpha: Double) -> Color {
        // 提取原始 UIColor 以访问 RGB
        let fg = UIColor(foreground)
        let bg = UIColor(self)

        var fr: CGFloat = 0, fgG: CGFloat = 0, fb: CGFloat = 0, fa: CGFloat = 0
        var br: CGFloat = 0, bgG2: CGFloat = 0, bb: CGFloat = 0, ba: CGFloat = 0

        fg.getRed(&fr, green: &fgG, blue: &fb, alpha: &fa)
        bg.getRed(&br, green: &bgG2, blue: &bb, alpha: &ba)

        let r = fr * alpha + br * (1 - alpha)
        let g = fgG * alpha + bgG2 * (1 - alpha)
        let b = fb * alpha + bb * (1 - alpha)

        return Color(red: Double(r), green: Double(g), blue: Double(b))
    }
}
