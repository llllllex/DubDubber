//
//  CombinedTabbar.swift
//  DubDubber
//
//  Created by Lex on 4/10/25.
//

import SwiftUI

// 上下收起展开按钮强制高度 32

// tab 按钮高度 52
// tab 按钮周围距离底框边距 8
// tabbar 区域高度 8 + 52 + 8 = 68

// Add 按钮高度 44
// switcher 高度 36，

// 编辑状态 toolbar 44 + 12 + 44
// 非编辑状态 toolbar 0 + 0 + 44

// toolbar 上下边距 8

// toolbar区域高度
// 非编辑状态 8 + 44 + 8 = 60
// 编辑状态 8 + 44 + 8 + 60 = 120

struct CombinedTabbar: View {
    
    let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    @Environment(Router.self) private var router
    
    @Environment(\.colorScheme) private var colorScheme
    
    let tabs: [TabModel] = TabModel.allCases
    
    private let swipeThreshold: CGFloat = 45
    
    private let verticalSwipeThreshold: CGFloat = 20
}

extension CombinedTabbar {
    var body: some View {
        root
    }
}

extension CombinedTabbar {
    
    var backgroundHeight: CGFloat {
        if router.shouldShowToolbar {
            if router.isContainedToolbarExpanded {
                return 32 + toolbarHeight + tabbarHeight
            } else {
                return 32 + tabbarHeight
            }
        } else {
            return tabbarHeight
        }
    }
    
    var tabbarHeight: CGFloat {
        68
    }
    
    var toolbarHeight: CGFloat {
        60
    }
    
    var root: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(Material.bar)
                .frame(
                    height: backgroundHeight,
                    alignment: .bottom
                )
//                .shadow(color: Color.black.opacity(0.15), radius: 8)
                .shadow(color: Color.white.mix(with: Color.black, by: 0.15), radius: 8)
                .animation(
                    .interactiveSpring,
                    value: backgroundHeight
                )
            
            VStack(spacing: 0) {
                
                if router.shouldShowToolbar {
                    Image(systemName: router.isContainedToolbarExpanded ? "chevron.compact.down" : "chevron.compact.up")
                        .symbolEffect(.wiggle, value: router.isContainedToolbarExpanded)
                        .mapleFont(weight: .bold, size: 22)
                        .foregroundStyle(.secondary)
                        .padding(.top)
                        .frame(height: 32)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            router.isContainedToolbarExpanded.toggle()
                        }
//                        .transition(.opacity)
                }
                
                if router.shouldShowToolbar && router.isContainedToolbarExpanded {
                    
                    Toolbar()
                        .padding(8)
                }
                tabbarSubviews
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                // 检查滑动方向和距离
                                if gesture.translation.width > swipeThreshold {
                                    // 右滑超过阈值，触发右滑操作
                                    let old = router.previousTab
                                    router.currentTab = old
                                    router.showSettingsTab = false
                                } else if gesture.translation.width < -swipeThreshold {
                                    // 左滑超过阈值，触发左滑操作
                                    let old: TabModel = router.currentTab
                                    if old != .settings {
                                        router.previousTab = old
                                    }
                                    if router.currentTab != .settings {
                                        router.currentTab = .settings
                                    }
                                    router.showSettingsTab = true
                                }
                            }
                    )
            }
        }
        .padding(.horizontal, 8)
    
        .frame(width: screenWidth)
    
//        .offset(y: tabViewModel.showTabBar ? 0 : 40)
//        .opacity(tabViewModel.showTabBar ? 1 : 0)
//        .scaleEffect(tabViewModel.showTabBar ? 1 : 0.85, anchor: .bottom)
//        .animation(.interactiveSpring, value: tabViewModel.showTabBar)
        
        
//            .overlay {
//                GeometryReader { geometry in
//                    Color.clear
//                        .frame(width: 0, height: 0)
//                        .ignoresSafeArea(.container, edges: .all) // 可以选择忽略安全区域查看完整的边距值
//                        .onAppear {
//                            self.safeAreaInsets = geometry.safeAreaInsets
//                        }
//                        .task {
//                            self.safeAreaInsets = geometry.safeAreaInsets
//                        }
//                }
//            }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    // 检查滑动方向和距离
                    if gesture.translation.height > verticalSwipeThreshold {
                        // 下滑超过阈值，触发收起
                        router.isContainedToolbarExpanded = false
                    } else if gesture.translation.height < -verticalSwipeThreshold {
                        // 上滑超过阈值，触发展开
                        router.isContainedToolbarExpanded = true
                    }
                }
        )
        .background(alignment: .bottom) {
            LinearGradient(colors: [
                Color.clear,
                Color.white
            ], startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.25))
            .ignoresSafeArea()
        }
    }
}

extension CombinedTabbar {
    var tabbarSubviews: some View {
        @Bindable var router: Router = self.router
        
        return content
            .frame(width: screenWidth - 32)
            .padding(8)
            
    }
    
    var content: some View {
        @Bindable var router: Router = self.router
        return HStack(
            spacing: router.showSettingsTab ? -8 : 8
        ) {
            ForEach(tabs.dropLast()) { tab in
                TabbarButton(tab: tab, selectedTab: $router.currentTab)
            }
            if router.showSettingsTab {
                TabbarButton(
                    tab: .settings,
                    selectedTab: $router.currentTab
                )
                .transition(
                    .scale(scale: 0.85, anchor: .trailing)
                    .combined(with: .opacity)
                )
            }
        }
        .animation(.easeInOut(duration: 0.15), value: router.showSettingsTab)
    }
}

