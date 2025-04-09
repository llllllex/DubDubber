//
//  GlassEffectView.swift
//  Fancer
//
//  Created by Lex on 3/30/25.
//

import Foundation
import SwiftUI

struct GlassEffectView: View {
    
    let configuration: GlassEffectConfiguration
    
    let blackShadowColor: Color
    let whiteShadowColor: Color
    
    init(configuration: GlassEffectConfiguration) {
        self.configuration = configuration
        
        let blackShadowColor1Base = GlassEffectConfiguration.FillType.primary.firstColor
        let blackShadowColor1Mixed = blackShadowColor1Base.mix(with: configuration.fillType.firstColor, by: configuration.borderColorMixRatio)
        blackShadowColor = Color.blendedColor(foreground: Color.black, background: blackShadowColor1Mixed, alpha: 0.15)
        
        let whiteShadowColorBase = GlassEffectConfiguration.FillType.primary.lastColor
        let whiteShadowColorBackground = whiteShadowColorBase.mix(with: configuration.fillType.lastColor, by: configuration.borderColorMixRatio)
        whiteShadowColor = Color.blendedColor(
            foreground: Color.white,
            background: whiteShadowColorBackground,
            alpha: 0.33
        )
    }
    
    let linearGradient = LinearGradient(
        gradient: Gradient(colors: [Color(white: 0.3), Color(white: 0.1)]),
        startPoint: .top,
        endPoint: .bottomTrailing
    )
    
    @Environment(\.colorScheme) var colorScheme
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
        configuration.containerShape
            .fill(
                configuration.material
                
                    .shadow(
                        .inner(
                            color: whiteShadowColor,
                            radius: 1,
                            x: -configuration.thickness.innerShadowOffset,
                            y: -configuration.thickness.innerShadowOffset
                        )
                    )
                
                    .shadow(
                        .inner(
                            color: blackShadowColor,
                            radius: 1,
                            x: configuration.thickness.innerShadowOffset,
                            y: configuration.thickness.innerShadowOffset
                        )
                    )
            )
            .background(
                configuration.containerShape
                    .fill(AnyShapeStyle(configuration.fillType.fillShape))
            )
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
}


//MARK: - GlassEffectConfiguration

struct GlassEffectConfiguration {
    
    enum FillType {
        case solid(Color)
        /// temporarily limit parameters
        case linearGradient([Color])
        //TODO:
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
    
    var innerShadowOffset: CGFloat {
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
