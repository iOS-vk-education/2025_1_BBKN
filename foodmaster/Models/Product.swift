import Foundation

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let protein: Int
    let fats: Int
    let carbs: Int
    let weight: Int
}
