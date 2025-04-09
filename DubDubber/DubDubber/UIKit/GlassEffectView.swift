//
//  GlassEffectView.swift
//  Fancer
//
//  Created by Lex on 3/30/25.
//

import Foundation
import SwiftUI

struct GlassEffectView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let configuration: GlassEffectConfiguration
}

extension GlassEffectView {
    
    @ViewBuilder
    var body: some View {
        if colorScheme == .light {
            lightEffect
        } else {
            darkEffect
        }
    }
    
    var lightEffect: some View {
        ZStack {
            configuration.containerShape
                .fill(
                    configuration.material
                    
//                        .shadow(
//                            .inner(
//                                color: .white.opacity(0.33),
//                                radius: 1,
//                                x: -3,
//                                y: -3
//                            )
//                        )
//                        .shadow(
//                            .inner(
//                                color: .white.opacity(0.33),
//                                radius: thickness.innerWhiteShadowRadius,
//                                x: -thickness.innerWhiteShadowOffset,
//                                y: -thickness.innerWhiteShadowOffset
//                            )
//                        )
//
//                        .shadow(
//                            .inner(
//                                color: .black.opacity(0.15),
//                                radius: 2,
//                                x: thickness.innerBlackShadowOffset,
//                                y: thickness.innerBlackShadowOffset
//                            )
//                        )
//                        .shadow(
//                            .inner(
//                                color: .black.opacity(0.1),
//                                radius: 2.0 * thickness.innerBlackShadowRadius,
//                                x: thickness.innerBlackShadowOffset,
//                                y: thickness.innerBlackShadowOffset
//                            )
//                        )
                        .shadow(
                            .inner(
                                color: whiteShadowColor,
                                radius: 1,
                                x: -3,
                                y: -3
                            )
                        )
                        .shadow(
                            .inner(
                                color: whiteShadowColor,
                                radius: configuration.thickness.innerWhiteShadowRadius,
                                x: -configuration.thickness.innerWhiteShadowOffset,
                                y: -configuration.thickness.innerWhiteShadowOffset
                            )
                        )
                    
                        .shadow(
                            .inner(
                                color: blackShadowColor1,
                                radius: 2,
                                x: configuration.thickness.innerBlackShadowOffset,
                                y: configuration.thickness.innerBlackShadowOffset
                            )
                        )
                        .shadow(
                            .inner(
                                color: blackShadowColor2,
                                radius: 2.0 * configuration.thickness.innerBlackShadowRadius,
                                x: configuration.thickness.innerBlackShadowOffset,
                                y: configuration.thickness.innerBlackShadowOffset
                            )
                        )
                )
                .background(
                    configuration.containerShape
                        .fill(AnyShapeStyle(configuration.fillType.fillShape))
                )
            
        // 投影
//            .shadow(
//                color: .purple
//                    .mix(with: .blue, by: 0.5)
//                    .mix(with: .black, by: 0.5)
//                    .opacity(0.1),
//                radius: 4,
//                x: 4,
//                y: 4
//            )
            
            strokeBorder
        }
    }
    
    @ViewBuilder
    var strokeBorder: some View {
        if self.configuration.shapeStyle == GlassEffectConfiguration.Shapes.rectangle {
            configuration.containerShape
                .stroke(
                    Color(white: 0.9175),
                    lineWidth: configuration.thickness.strockWidth)
                .offset(x: -configuration.thickness.strockOffset, y: -configuration.thickness.strockOffset)
                .clipShape(configuration.containerShape)
        } else {
            configuration.containerShape
                .stroke(
                    Color(white: 0.96),
                    lineWidth: configuration.thickness.strockWidth)
                .offset(x: -configuration.thickness.strockOffset, y: -configuration.thickness.strockOffset)
                .clipShape(configuration.containerShape)
        }
    }
    
    var darkEffect: some View {
        
        ZStack {
            configuration.containerShape
                .fill(
                    configuration.material
                )
            configuration.containerShape
                .stroke(
                    linearGradient,
                    lineWidth: configuration.thickness.darkStrokeWidth)
        }
    }
    
    var linearGradient: some ShapeStyle {
        LinearGradient(
            gradient: Gradient(colors: [Color(white: 0.3), Color(white: 0.1)]),
            startPoint: .top,
            endPoint: .bottomTrailing
        )
    }
    
    var blackShadowColor2: Color {
//        Color.blendedColor(foreground: Color.black, background: configuration.firstColor, alpha: 0.1)
        let base = GlassEffectConfiguration.FillType.primary.firstColor
        let mixed = base.mix(with: configuration.fillType.firstColor, by: configuration.borderColorMixRatio)
        return Color.blendedColor(foreground: Color.black, background: mixed, alpha: 0.1)
    }
    
    var blackShadowColor1: Color {
//        Color.blendedColor(foreground: Color.black, background: configuration.firstColor, alpha: 0.15)
        let base = GlassEffectConfiguration.FillType.primary.firstColor
        let mixed = base.mix(with: configuration.fillType.firstColor, by: configuration.borderColorMixRatio)
        return Color.blendedColor(foreground: Color.black, background: mixed, alpha: 0.15)
    }
    
    var whiteShadowColor: Color {
//        Color.blendedColor(foreground: Color.white, background: configuration.lastColor, alpha: 0.33)
        let base = GlassEffectConfiguration.FillType.primary.lastColor
        let mixed = base.mix(with: configuration.fillType.lastColor, by: configuration.borderColorMixRatio)
        return Color.blendedColor(
            foreground: Color.white,
            background: mixed,
            alpha: 0.33
        )
    }
}


//MARK: - Transient

private extension GlassEffectView {
    
    var shadowOpacity: CGFloat {
        colorScheme == .light ? 0.1 : 0
    }
    
    var shadowRadius: CGFloat {
        colorScheme == .light ? 4 : 0
    }
    
    var innerShadowColor: Color {
        colorScheme == .light ? .white : .black
    }
    
    var innerShadowColor2: Color {
        colorScheme == .light ? .black : .white
    }
}


//MARK: - GlassEffectConfiguration

struct GlassEffectConfiguration {
    
    /// 填充类型
    enum FillType {
        case solid(Color)
        /// 暂时固定角度
        case linearGradient([Color])
        //TODO: 暂时不支持，短期内无使用需求
//        case radialGradient(RadialGradient)
//        case image(Image)
//        case custom((CGSize) -> any View)
//        case none
    }
    
    struct CustomShapeWrapper: Equatable {
        let id: UUID
        let shape: any Shape
        
        // Make sure the `Shape` conforms to Equatable (if necessary)
        static func ==(lhs: CustomShapeWrapper, rhs: CustomShapeWrapper) -> Bool {
            return lhs.id == rhs.id // Compare by `id`
        }
    }
    
    /// 形状
    enum Shapes: Equatable {
        
        static func ==(lhs: GlassEffectConfiguration.Shapes, rhs: GlassEffectConfiguration.Shapes) -> Bool {
                switch (lhs, rhs) {
                case (.capsule, .capsule):
                    return true
                case (.rectangle, .rectangle):
                    return true
                case (.roundedRectangle(let lhsRadius, let lhsType), .roundedRectangle(let rhsRadius, let rhsType)):
                    return lhsRadius == rhsRadius && lhsType == rhsType
                case (.custom(let lhsShape), .custom(let rhsShape)):
                    // Since `Shape` itself is not Equatable, you may need to compare its properties or use a custom equality check.
                    // If you want to compare them exactly, you would have to define how to compare `Shape` objects.
                    return lhsShape == rhsShape  // Example: use an `id` or another property of the shape to compare
                default:
                    return false
                }
            }
        
        case capsule
        case rectangle
        case roundedRectangle(radius: CGFloat, type: RoundedCornerStyle)
        case custom(shape: CustomShapeWrapper)
    }
    
    /// 厚度
    enum Thickness {
        case ultraThin
        case thin
        case regular
        case thick
    }
    
    let fillType: FillType
    let borderColorMixRatio: CGFloat
    let shapeStyle: Shapes
    let thickness: Thickness
    let material: Material
    
    init(
        fillType: FillType,
        borderColorMixRatio: CGFloat = 0.2,
        shapeStyle: Shapes,
        thickness: Thickness,
        material: Material
    ) {
        self.fillType = fillType
        self.borderColorMixRatio = borderColorMixRatio
        self.shapeStyle = shapeStyle
        self.thickness = thickness
        self.material = material
    }
}

extension GlassEffectConfiguration {
    
    var containerShape: some Shape {
        switch shapeStyle {
        case .capsule:
            AnyShape(Capsule())
        case .rectangle:
            AnyShape(Rectangle())
        case .roundedRectangle(let radius, let type):
            AnyShape(RoundedRectangle(cornerRadius: radius, style: type))
        case .custom(shape: let s):
            AnyShape(s.shape)
        }
    }
}


//MARK: - FillType

extension GlassEffectConfiguration.FillType {
    
    var fillShape: any ShapeStyle {
        switch self {
        case .solid(let color):
            return color
        case .linearGradient(let colors):
            return  LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: .top,
                endPoint: .bottomTrailing
            )
        }
    }
    
    var firstColor: Color {
        switch self {
        case .solid(let color):
            return color
        case .linearGradient(let colors):
            return colors.first!
        }
    }
    
    var lastColor: Color {
        switch self {
        case .solid(let color):
            return color
        case .linearGradient(let colors):
            return colors.last!
        }
    }
}

extension GlassEffectConfiguration.FillType {
    var fillView: some View {
        Rectangle()
            .fill(AnyShapeStyle(fillShape))
    }
}

extension GlassEffectConfiguration.FillType {
    
    static let primary = GlassEffectConfiguration.FillType.linearGradient([
        .white,
//        Color(red: 0.95, green: 0.96, blue: 1.0)
    ])
    
    static let blue: GlassEffectConfiguration.FillType = .linearGradient([
        Color.blue.mix(with: Color.white, by: 0.35),
//        Color.primary.reversedGrayScale().brightness(0.92)
        .white
    ])
    
    static let rainbow: GlassEffectConfiguration.FillType = .linearGradient([
        Color.purple,
        Color.blue.mix(with: Color.white, by: 0.6),
        Color.white
    ])
}


//MARK: - THickness

extension GlassEffectConfiguration.Thickness {
    
    @MainActor
    var strockWidth: CGFloat {
//        switch self {
//        case .ultraThin:
//            return 0
//        case .thin:
//            return 1
//        case .regular:
//            return 1.5
//        case .thick:
//            return 2
//        }
        
        1.0 / UIScreen.main.scale
    }
    
    var darkStrokeWidth: CGFloat {
        switch self {
        case .ultraThin:
            return 1
        case .thin:
            return 2
        case .regular:
            return 3
        case .thick:
            return 4
        }
    }
    
    var strockOffset: CGFloat {
        switch self {
        case .ultraThin:
            return 0
        case .thin:
            return 2
        case .regular:
            return 3
        case .thick:
            return 4
        }
    }
    
    var innerWhiteShadowOffset: CGFloat {
        switch self {
        case .ultraThin:
            return 1
        case .thin:
            return 2
        case .regular:
            return 3
        case .thick:
            return 4
        }
    }
    
    var innerWhiteShadowRadius: CGFloat {
        switch self {
        case .ultraThin:
            return 1
        case .thin:
            return 2
        case .regular:
            return 3
        case .thick:
            return 4
        }
    }
    
    var innerBlackShadowOffset: CGFloat {
        switch self {
        case .ultraThin:
            return 1
        case .thin:
            return 2
        case .regular:
            return 3
        case .thick:
            return 4
        }
    }
    
    var innerBlackShadowRadius: CGFloat {
        switch self {
        case .ultraThin:
            return 1
        case .thin:
            return 2
        case .regular:
            return 3
        case .thick:
            return 4
        }
    }
}
