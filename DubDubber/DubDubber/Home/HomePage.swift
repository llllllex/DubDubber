//
//  HomePage.swift
//  DubDubber
//
//  Created by Lex on 4/10/25.
//

import SwiftUI

struct HomePage: View {
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    private let card: GlassEffectConfiguration.FillType = .linearGradient([
        Color.mint.mix(with: Color.white, by: 0.35),
        .white
    ])
    
    @Namespace private var switchNamespace
    
    @Environment(\.colorScheme) private var colorScheme
}

extension HomePage {
    
    var body: some View {
        testCards
            .scrollContentBackground(.hidden)
            .navigationTitle(Text("Home"))
    }
}

extension HomePage {
    
    var testCards: some View {
        ScrollView {
            VStack(spacing: 32) {
                
                GlassButton(style: .roundedRectagle(cornerRadius: 32, cornerStyle: .continuous), thickness: .regular, size: .custom(height: 200), title: "WWDC 26", systemImage: "apple.logo", automaticallyExpand: true, onlyShowIcon: .constant(false), fillType: .primary, onTapped: nil)
                    .padding(.horizontal, 20)
                
                GlassButton(style: .roundedRectagle(cornerRadius: 32, cornerStyle: .continuous), thickness: .regular, size: .custom(height: 200), title: "WWDC 25", systemImage: "apple.logo", automaticallyExpand: true, onlyShowIcon: .constant(false), fillType: card, onTapped: nil)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 12) {
                    Text("Previous")
                        .mapleFont(weight: .bold, textStyle: .title)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    ScrollView(.horizontal) {
                        
                        HStack(spacing: 12) {
                            GlassButton(style: .roundedRectagle(cornerRadius: 32, cornerStyle: .continuous), thickness: .regular, size: .custom(height: 112), title: "WWDC 24", systemImage: "apple.logo", automaticallyExpand: true, onlyShowIcon: .constant(false), fillType: .rainbow, onTapped: nil)
                                .frame(width: secondaryItemWidth)
                            
                            GlassButton(style: .roundedRectagle(cornerRadius: 32, cornerStyle: .continuous), thickness: .regular, size: .custom(height: 112), title: "WWDC 23", systemImage: "apple.logo", automaticallyExpand: true, onlyShowIcon: .constant(false), fillType: .rainbow, onTapped: nil)
                                .frame(width: secondaryItemWidth)
                            
                            GlassButton(style: .roundedRectagle(cornerRadius: 32, cornerStyle: .continuous), thickness: .regular, size: .custom(height: 112), title: "WWDC 22", systemImage: "apple.logo", automaticallyExpand: true, onlyShowIcon: .constant(false), fillType: .rainbow, onTapped: nil)
                                .frame(width: secondaryItemWidth)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .padding(.top, 20)
        }
        .scrollIndicators(.hidden)
    }
    
    var secondaryItemWidth: CGFloat {
        floor(((screenWidth - 20.0) - secondaryItemSpacing * 2) / 5.0) * 2.0
    }
    
    var secondaryItemSpacing: CGFloat {
        12.0
    }
}
