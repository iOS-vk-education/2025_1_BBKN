//
//  Colors+Extension.swift
//  foodmaster
//
//  Created by Arthur on 18.11.2025.
//

import SwiftUI

public extension Color {
    static let customPrimary = Color(hex: "424E2B")
    static let customAccent = Color(hex: "E67411")
    static let customBackground = Color(hex: "E5D9C6")
    static let customSecondary = Color(hex: "627B34")
    
    static let customCardBackground = customBackground
    static let customText = customPrimary
    static let customTextSecondary = customPrimary.opacity(0.6)
    static let customButtonBackground = customBackground
    static let customAddButton = customSecondary
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}

