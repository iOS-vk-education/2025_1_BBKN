import SwiftUI
import Combine

@MainActor
class CustomDishViewModel: ObservableObject {
    @Published var products: [Product] = []
    
    func addProduct() {
        // TODO: Реализовать сетевой функционал
        let randomMock = Product.mocks.randomElement()!
        products.append(randomMock)
    }
}
