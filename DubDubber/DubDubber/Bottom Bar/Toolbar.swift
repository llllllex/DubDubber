//
//  Toolbar.swift
//  DubDubber
//
//  Created by Lex on 4/10/25.
//

import SwiftUI

struct Toolbar: View {
    
    @Namespace private var categorySwitchNamespace
    
    @Environment(Router.self) private var router
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
}

extension Toolbar {
    var body: some View {
        
        VStack(spacing: 8) {
            
            HStack(spacing: 12) {
                
                Spacer()
                
                if router.shouldShowEditButton {
                    GlassButton(style: .capsule, thickness: .regular, size: .large, title: "Edit", systemImage: "pencil", automaticallyExpand: false, onlyShowIcon: .constant(true), fillType: .rainbow, onTapped: onEditButtonTapped)
                    .overlay {
                        if isEditButtonActived {
                            Capsule()
                                .fill(
                                    Color.red.opacity(0.15)
                                )
                                .offset(x: -3, y: -3)
                                .clipShape(Capsule())
                                .onTapGesture {
                                    onEditButtonTapped()
                                    Haptic.shared.glassTouchDown()
                                }
                        }
                    }
                }
                
                if router.shouldShowPlusButton {
                    GlassButton(style: .capsule, thickness: .regular, size: .large, title: "Add", systemImage: "plus", automaticallyExpand: false, onlyShowIcon: .constant(true), fillType: .rainbow, onTapped: onPlusButtonTapped)
                }
            }
        }
    }
}


//MARK: - Plus Button

private extension Toolbar {
    
    func onPlusButtonTapped() {
        
    }
    
    var isEditButtonActived: Bool {
        switch router.currentTab {
        default:
            return false
        }
    }
    
    func onEditButtonTapped() {
        switch router.currentTab {
        default:
            break
        }
    }
}

private extension Toolbar {
    
}
