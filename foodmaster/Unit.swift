//
//  Unit.swift
//  foodmaster
//
//  Created by Arthur on 18.11.2025.
//

import Foundation

enum Unit {
    case kcal
    case gram
    
    var description: String {
        switch self {
        case .kcal:
            return "ккал"
        case .gram:
            return "г"
        }
    }
}

