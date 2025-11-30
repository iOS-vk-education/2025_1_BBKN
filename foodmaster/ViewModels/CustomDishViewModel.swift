import SwiftUI
import Combine

@MainActor
class CustomDishViewModel: ObservableObject {
    @Published var products: [Product] = []
    
    func addProduct() {
        // TODO: Реализовать сетевой функционал
        let mock = Product.mocks.randomElement()!
        
        let newProduct = Product(
                name: mock.name,
                calories: mock.calories,
                protein: mock.protein,
                fats: mock.fats,
                carbs: mock.carbs,
                weight: mock.weight,
                imageUrl: mock.imageUrl
            )

        products.append(newProduct)
    }
    
    func removeProduct(_ product: Product) {
            products.removeAll { $0.id == product.id }
        }
    
    var totalCalories: Int {
            products.reduce(0) { $0 + $1.calories }
        }

    var totalFats: Int {
        products.reduce(0) { $0 + $1.fats }
    }

    var totalCarbs: Int {
        products.reduce(0) { $0 + $1.carbs }
    }

    var totalProtein: Int {
        products.reduce(0) { $0 + $1.protein }
    }
}
