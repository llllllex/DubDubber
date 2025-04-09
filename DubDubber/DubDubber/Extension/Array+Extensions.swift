//
//  Array+Extensions.swift
//  DubDubber
//
//  Created by Lex on 4/10/25.
//

import Foundation

extension Array where Element: Equatable {
    
    /// return the element count from the last one,
    /// if k is bigger than count, return the first one.
    func last(k: Int) -> Element {
        if count >= k {
            return self[count - k]
        } else {
            fatalError()
        }
    }
}
