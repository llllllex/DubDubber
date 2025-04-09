//
//  RootContainer.swift
//  DubDubber
//
//  Created by Lex on 4/10/25.
//

import SwiftUI

struct RootContainer: View {
    
}

extension RootContainer {
    
    @ViewBuilder
    var body: some View {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad, .mac, .tv, .vision, .carPlay, .unspecified:
            Text("On Progress")
        case .phone:
            TabContainer()
        @unknown default:
            fatalError()
//            Text("On Progress")
        }
    }
}
