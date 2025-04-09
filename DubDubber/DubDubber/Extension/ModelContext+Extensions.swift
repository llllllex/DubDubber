//
//  ModelContext+Extensions.swift
//  Fancer
//
//  Created by Lex on 3/21/25.
//

import Foundation
import SwiftData

extension ModelContext {
    
    func existingModel<T>(for modelID: PersistentIdentifier) throws -> T? where T: PersistentModel {
        if let reg: T = registeredModel(for: modelID) { return reg }
        let fetchDescriptor = FetchDescriptor<T>(
            predicate: #Predicate {
                $0.persistentModelID == modelID
            })
        return try fetch(fetchDescriptor).first
    }
}
