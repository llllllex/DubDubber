//
//  TabContainer.swift
//  DubDubber
//
//  Created by Lex on 4/10/25.
//

import SwiftUI

struct TabContainer: View {
    
    @Bindable private var router = Router()
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
}

extension TabContainer {
    var body: some View {
        content
            .environment(router)
    }
    
    var content: some View {
        tabbarView
    }
    
    var backgroundColor: Color {
        colorScheme == .dark ? Color.black : Color(white: 0.88)
    }
    
    var gradientBackground: some View {
        LinearGradient(
            gradient: Gradient(
                colors: [
                    Color.blue,
                    Color.purple
                ]
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var tabbarView: some View {
        @Bindable var router = self.router
        return TabView(selection: $router.currentTab) {
            ForEach(TabModel.allCases, id: \.self) { tab in
                tab.destination
                    .toolbarVisibility(.hidden, for: .tabBar)
                    .toolbarBackgroundVisibility(.hidden, for: .tabBar)
            }
        }
        .overlay(alignment: .bottom) {
            CombinedTabbar()
        }
        .onChange(of: router.currentTab) { oldValue, newValue in
            print("[Tab] \(newValue)")
            if newValue != oldValue {
                onTabSelectedChange(from: oldValue, to: newValue)
            }
        }
        .onChange(of: router.homeRoutes) { oldValue, newValue in
            print("[Router] \(newValue)\n")
            onRouteChange(router)
        }
    }
}

extension TabContainer {
    
    func onTabSelectedChange(from oldValue: TabModel, to newValue: TabModel) {
        onRouteChange(router)
    }
    
    func onRouteChange(_ routes: Router) {
        switch router.currentTab {
        case .home:
            if router.homeRoutes.count == 0 {
                router.showTabbar = true
            } else {
                router.showTabbar = false
            }
        default:
            router.showTabbar = true
        }
    }
}
