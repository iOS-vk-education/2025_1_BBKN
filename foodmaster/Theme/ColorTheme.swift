//
//  ColorTheme.swift
//  foodmaster
//
//  Created by Arthur on 18.11.2025.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    // MARK: - Main Colors
    let primary = Color(hex: "424E2B")        // Основной зелёный
    let accent = Color(hex: "E67411")         // Оранжевый
    let background = Color(hex: "E5D9C6")     // Бежевый цвет фона
    let secondary = Color(hex: "627B34")      // Дополнительный зелёный
    
    // MARK: - Semantic Colors
    var cardBackground: Color { background }
    var text: Color { primary }
    var textSecondary: Color { primary.opacity(0.6) }
    var buttonBackground: Color { background }
    var addButton: Color { secondary }
}

// MARK: - Color Extension for Hex
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
