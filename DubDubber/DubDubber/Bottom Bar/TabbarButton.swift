//
//  TabbarButton.swift
//  DubDubber
//
//  Created by Lex on 4/10/25.
//

import SwiftUI

struct TabbarButton: View {
    
    let tab: TabModel
    
    private let tabs: [TabModel] = TabModel.allCases
    
    @Binding var selectedTab: TabModel
    
    @State private var isHovering: Bool = false
    
    @Environment(Router.self) private var router
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        
        let onlyShowIcon: Binding<Bool> = Binding<Bool>{
            tab != selectedTab
        } set: { newValue in
            
        }
        
        GlassButton(style: .capsule, thickness: .regular, size: .large, title: tab.title, systemImage: tab.systemImageName, automaticallyExpand: true, onlyShowIcon: onlyShowIcon, fillType: .rainbow, onTapped: onTap)
            .frame(width: selectedTab == tab ? nil : Layouts.height)
            .animation(.easeInOut(duration: 0.15), value: selectedTab)
    }
}


//MARK: - Actions

private extension TabbarButton {
    
    func onTap() {
        router.switchTo(tab: tab)
    }
}


//MARK: - Layouts

extension TabbarButton {
    
    public enum Layouts {
        
        static let height: CGFloat = 54
    }
}
