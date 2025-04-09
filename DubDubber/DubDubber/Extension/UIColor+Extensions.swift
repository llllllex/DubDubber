//
//  UIColor+Extensions.swift
//  Fancer
//
//  Created by Lex on 3/21/25.
//

import Foundation
import SwiftUI

#if canImport(AppKit)

import AppKit

extension NSColor {
    func rgba() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r,g,b,a)
    }
    
    func hsba() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h,s,b,a)
    }
    
    func wa() -> (CGFloat, CGFloat) {
        var white: CGFloat = 0
        var alpha: CGFloat = 0
        self.getWhite(&white, alpha: &alpha)
        return (white, alpha)
    }
}

extension NSColor {
    
    convenience init(hex: String) {
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xFF0000) >> 16
        let g = (rgbValue & 0xFF00) >> 8
        let b = rgbValue & 0xFF
        
        self.init(
            red: CGFloat(r) / 0xFF,
            green: CGFloat(g) / 0xFF,
            blue: CGFloat(b) / 0xFF, alpha: 1
        )
    }
    
    var hexString: String {
//        var r: CGFloat = 0
//        var g: CGFloat = 0
//        var b: CGFloat = 0
//        var a: CGFloat = 0
//
//        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let (r,g,b,_) = self.rgba()
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xFF),
            Int(g * 0xFF),
            Int(b * 0xFF)
        )
    }
}

#elseif canImport(UIKit)

import UIKit

extension UIColor {
    
    func rgba() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r,g,b,a)
    }
    
    func hsba() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h,s,b,a)
    }
    
    func wa() -> (CGFloat, CGFloat) {
        var white: CGFloat = 0
        var alpha: CGFloat = 0
        self.getWhite(&white, alpha: &alpha)
        return (white, alpha)
    }
}

extension UIColor {
    
    convenience init(hex: String) {
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xFF0000) >> 16
        let g = (rgbValue & 0xFF00) >> 8
        let b = rgbValue & 0xFF
        
        self.init(
            red: CGFloat(r) / 0xFF,
            green: CGFloat(g) / 0xFF,
            blue: CGFloat(b) / 0xFF, alpha: 1
        )
    }
    
    var hexString: String {
//        var r: CGFloat = 0
//        var g: CGFloat = 0
//        var b: CGFloat = 0
//        var a: CGFloat = 0
//
//        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let (r,g,b,_) = self.rgba()
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xFF),
            Int(g * 0xFF),
            Int(b * 0xFF)
        )
    }
}

#else

#endif
