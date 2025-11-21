import Foundation

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let protein: Int
    let fats: Int
    let carbs: Int
    let weight: Int
    let imageUrl: String?
}

extension Product {
    static let mocks: [Product] = [
        Product(name: "Рис отварной", calories: 100, protein: 10, fats: 40, carbs: 50, weight: 100, imageUrl: nil),
        Product(name: "Гречка отварная", calories: 100, protein: 10, fats: 40, carbs: 50, weight: 100, imageUrl: nil)
        ]
}
