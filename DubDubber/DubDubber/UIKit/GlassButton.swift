//
//  GlassButton.swift
//  Fancer
//
//  Created by Lex on 3/26/25.
//

import Foundation
import SwiftUI

struct GlassButton: View {
    
    enum Style {
        case roundedRectagle(cornerRadius: CGFloat, cornerStyle: RoundedCornerStyle)
        case capsule
        case square
    }
    
    enum Size {
        case mini
        case small
        case regular
        case large
        case extraLarge
        case custom(height: CGFloat)
        
        var point: CGFloat {
            switch self {
            case .mini: return 28
            case .small: return 32
            case .regular: return 44
            case .large: return 52
            case .extraLarge: return 64
            case .custom(let height): return height
            }
        }
    }
    
    typealias Thickness = GlassEffectConfiguration.Thickness
    
    typealias FillType = GlassEffectConfiguration.FillType
    
    let style: Style
    let size: Size
    let thickness: Thickness
    let title: String
    let systemImage: String
    let automaticallyExpand: Bool
    @Binding var onlyShowIcon: Bool
    let fillType: FillType
    let onTapped: (() -> Void)?
    
    init(
        style: Style,
        thickness: Thickness,
        size: Size,
        title: String,
        systemImage: String,
        automaticallyExpand: Bool,
        onlyShowIcon: Binding<Bool>,
        fillType: FillType,
        onTapped: (() -> Void)?
    ) {
        self.style = style
        self.thickness = thickness
        self.size = size
        self.title = title
        self.systemImage = systemImage
        self.automaticallyExpand = automaticallyExpand
        _onlyShowIcon = onlyShowIcon
        self.fillType = fillType
        self.onTapped = onTapped
    }
    
    @State private var isHovering: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
}

extension GlassButton {
    
    var background: some View {
        
        let material: Material = colorScheme == .dark ? .thin : .thin
        
        switch style {
        case .capsule:
            
            let configuration = GlassEffectConfiguration(fillType: fillType, shapeStyle: .capsule, thickness: thickness, material: material)
            return GlassEffectView(configuration: configuration)
        case .roundedRectagle(let cornerRadius, let cornerStyle):
            let configuration = GlassEffectConfiguration(
                fillType: fillType,
                shapeStyle: .roundedRectangle(
                    radius: cornerRadius,
                    type: cornerStyle
                ),
                thickness: thickness,
                material: material
            )
            return GlassEffectView(configuration: configuration)
        case .square:
            let configuration = GlassEffectConfiguration(fillType: fillType, shapeStyle: .rectangle, thickness: thickness, material: material)
            return GlassEffectView(configuration: configuration)
        }
    }
    
    var shadowColor: Color {
        if colorScheme == .dark {
            .purple
                .mix(with: .blue, by: 0.5)
                .mix(with: .black, by: 0.5)
                .mix(with: .black, by: 0.9)
        } else {
            .purple
                .mix(with: .blue, by: 0.5)
                .mix(with: .black, by: 0.25)
                .mix(with: .white, by: 0.85)
        }
    }
    
    var body: some View {
        
        content
            .padding(.horizontal)
            .frame(maxWidth: automaticallyExpand ? .infinity : nil)
            .frame(height: size.point)
            .background {
                background
                    .scaleEffect(isHovering ? 1 : scaleRatio)
                    .shadow(
                        color: shadowColor,
                        radius: shadowSize,
                        x: shadowSize,
                        y: shadowSize
                    )
            }
        
            .overlay {
                contentShape.fill(
                    Color.black.opacity(isHovering ? 0.015 : 0)
                )
            }
        .scaleEffect(isHovering ? scaleRatio : 1)
        .animation(.interactiveSpring, value: isHovering)
        .simultaneousGesture(
            TapGesture()
                .onEnded {
                    onTapped?()
                }
        )
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ _ in
                    if self.isHovering == false {
                        self.isHovering = true
                        Haptic.shared.glassTouchDown()
                    }
                })
                .onEnded({ _ in
                    if self.isHovering == true {
                        self.isHovering = false
//                        Haptic.shared.glassTouchUp()
                    }
                })
        )
        .frame(height: size.point)
    }
    
    var scaleRatio: CGFloat {
        colorScheme == .dark ? 0.98 : 0.99
    }
    
    var content: some View {
        HStack {
            Image(systemName: systemImage)
            if !onlyShowIcon {
                
                Text(title)
                    .fixedSize()
//                    .transition(
//                        .scale(scale: 0.85, anchor: .leading)
//                        .combined(with: .opacity)
//                    )
            }
        }
        .mapleFont(.semibold)
        .foregroundStyle(Color.secondary)
    }
    
    var shadowSize: CGFloat {
        if colorScheme == .light {
            isHovering ? 1 : 3
        } else {
            0
        }
    }
    
    var shadowRadius: CGFloat {
        if colorScheme == .light {
            isHovering ? 1 : 2
        } else {
            0
        }
    }
    
    var contentShape: some Shape {
        switch style {
        case .capsule:
            return AnyShape(Capsule())
        case .roundedRectagle(let cornerRadius, let cornerStyle):
            return AnyShape(RoundedRectangle(cornerRadius: cornerRadius, style: cornerStyle))
        case .square:
            return AnyShape(Rectangle())
        }
    }
}
