//
//  Router.swift
//  DubDubber
//
//  Created by Lex on 4/10/25.
//

import SwiftUI

@Observable
final class Router {
    
    
    //MARK: Tab
    
    /// current showing tab page
    var currentTab: TabModel = .home
    
    /// record previous showed tab for quickly goback from settings tab
    var previousTab: TabModel = .home
    
    /// state stands for if showing tabbar
    var showSettingsTab = false
    
    func switchTo(tab: TabModel) {
        previousTab = currentTab
        currentTab = tab
        if tab != .settings {
            showSettingsTab = false
        }
    }
    
    
    //MARK: Tabbar
    
    ///show or hide tabbar for none first-screen pages
    var showTabbar = false
    
    
    //MARK: Toolbar
    
    /// toolbar style
    var toolbarStyle: ToolbarStyle = .insideTabbar
    
    /// state stands for if contanied toolbar expanded
    var isContainedToolbarExpanded = false
    
    /// return if there're controls on toolbar to show
    var shouldShowToolbar: Bool {
        shouldShowEditButton || shouldShowPlusButton
    }
    
    var shouldShowEditButton: Bool {
        switch currentTab {
        case .notes:
            return true
        default:
            return false
        }
    }
    
    var shouldShowPlusButton: Bool {
        switch currentTab {
        case .notes:
            return true
        default:
            return false
        }
    }
    
    //MARK: Routes
    
    /// route stack for home tab page
    var homeRoutes: [HomeRoute] = []
}

enum ToolbarStyle {
    
    /// toolbar contained inside tabbar
    case insideTabbar
    
//    case separated
//    case floating
}

enum HomeRoute: Hashable {
    case home
    case detail(wwdc: WWDCDataModel)
}
