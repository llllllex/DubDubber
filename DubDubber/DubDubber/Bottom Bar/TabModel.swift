//
//  TabModel.swift
//  DubDubber
//
//  Created by Lex on 4/10/25.
//

import SwiftUI

enum TabModel: String {
    case home
    case collections
    case notes
    case settings
}

extension TabModel: Identifiable {
    var id: String { rawValue }
}

extension TabModel: Hashable, Equatable, CaseIterable {}

extension TabModel {
    
    @MainActor
    @ViewBuilder
    var destination: some View {
        switch self {
        case .home: HomeRootContainer()
        case .collections: Text("collections destination")
        case .notes: Text("notes destination")
        case .settings: Text("settings destination")
        }
    }
    
    var title: String {
        switch self {
        case .home: "Home"
        case .collections: "Collections"
        case .notes: "Notes"
        case .settings: "Settings"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .home: "house"
        case .collections: "sparkles.square.filled.on.square"
        case .notes: "note.text"
        case .settings: "gear"
        }
    }
}
