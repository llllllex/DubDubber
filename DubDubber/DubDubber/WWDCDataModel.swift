//
//  WWDCDataModel.swift
//  DubDubber
//
//  Created by Lex on 4/10/25.
//

import Foundation

struct WWDCDataModel {
    let id: String
    let title: String
    let subtitle: String
    let imageURLString: String
}

extension WWDCDataModel: Identifiable, Hashable, Equatable, Codable {}
