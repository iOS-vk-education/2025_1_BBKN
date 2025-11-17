import SwiftUI
import Combine

@MainActor
class CustomDishViewModel: ObservableObject {
    @Published var products: [Product] = []
    
    func addTestIngredient(){
        let test = Product(name: "Рис отварной", calories: 100, protein: 100, fats: 100, carbs: 100, weight: 100)
        
        products.append(test)
    }
}
