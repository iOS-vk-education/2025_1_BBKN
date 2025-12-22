//
//  Dish.swift
//  foodmaster
//
//  Created by Arthur on 18.11.2025.
//

import Foundation

struct Dish: Identifiable, Codable {
    let id: String
    let name: String
    let subtitle: String?
    let description: String
    let imageUrl: String?
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int
    let price: Double
    let category: String?
}

extension Dish {
    static let mock = Dish(
        id: "1",
        name: "Рис отварной",
        subtitle: "Отборный рис помогает потенциалу",
        description: "Отборный рис помогает потенциалу. род однолетних и многолетних травянистых растений семейства Злаки. Рис. Oryza sativa.",
        imageUrl: nil,
        calories: 1000,
        protein: 152,
        carbs: 150,
        fat: 145,
        price: 250,
        category: "Гарниры"
    )
}

