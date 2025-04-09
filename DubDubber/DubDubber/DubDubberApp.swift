//
//  DubDubberApp.swift
//  DubDubber
//
//  Created by Lex on 4/10/25.
//

import SwiftUI
import SwiftData

@main
struct DubDubberApp: App {
    
    @Environment(\.undoManager) var undoManager
    @Environment(\.scenePhase) var scenePhase
    
    var sharedModelContainer: ModelContainer
    
    init() {
        
        let schema = Schema(
            [
                Item.self,
            ]
        )
        
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            sharedModelContainer = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}

extension DubDubberApp {
    
    var body: some Scene {
        WindowGroup {
            RootContainer()
        }
        .modelContainer(sharedModelContainer)
    }
}


//MARK: - Allow swipe from left edge to swing back

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}

