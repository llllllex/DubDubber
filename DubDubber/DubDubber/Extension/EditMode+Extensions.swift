//
//  EditMode+Extensions.swift
//  Fancer
//
//  Created by Lex on 3/29/25.
//

import Foundation
import SwiftUI

extension SwiftUI.EditMode {
    
    mutating func toggle() {
        switch self {
        case .inactive:
            self = .active
        case .active:
            self = .inactive
        default:
            self = .inactive
        }
    }
}
