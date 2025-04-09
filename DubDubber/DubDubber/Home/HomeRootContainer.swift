//
//  HomeRootContainer.swift
//  DubDubber
//
//  Created by Lex on 4/10/25.
//

import SwiftUI

struct HomeRootContainer: View {
    @Environment(Router.self) private var router
    @Environment(\.colorScheme) private var colorScheme
}

extension HomeRootContainer {
    
    var body: some View {
        @Bindable var router = router
        return NavigationStack(path: $router.homeRoutes) {
            HomePage()
        }
        .onChange(of: router.homeRoutes) { oldValue, newValue in
            print("[Router] \(newValue)\n")
        }
    }
}
