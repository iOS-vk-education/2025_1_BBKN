import Foundation

struct DefaultProduct {
    static let calories = 300
    static let protein = 20
    static let fats = 8
    static let carbs = 45
    static let weight = 200

    static func create(name: String) -> Product {
        Product(
            name: name,
            calories: calories,
            protein: protein,
            fats: fats,
            carbs: carbs,
            weight: weight
        )
    }
}

