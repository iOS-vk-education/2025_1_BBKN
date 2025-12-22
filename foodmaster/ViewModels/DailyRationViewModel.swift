class DailyRationViewModel {
    var onUpdate: (() -> Void)?
    
    private(set) var products: [Product] = [
        DefaultProduct.create(name: "Рис с гречей")
    ] {
        didSet {
            onUpdate?()
        }
    }
    
    var caloriesTotal: Int {
        products.reduce(0) { $0 + $1.calories }
    }
    var fatsTotal: Int {
        products.reduce(0) { $0 + $1.fats }
    }
    var carbsTotal: Int {
        products.reduce(0) { $0 + $1.carbs }
    }
    var proteinsTotal: Int {
        products.reduce(0) { $0 + $1.protein }
    }
    let caloriesGoal: Int = 2500
    
    func product(at index: Int) -> Product {
        products[index]
    }
    func productsCount() -> Int {
        products.count
    }
    func addNewProduct() {
        let newProduct = DefaultProduct.create(name: "Новое блюдо \(products.count + 1)")
        products.append(newProduct)
    }
    func removeProduct(at index: Int) {
        guard index >= 0 && index < products.count else { return }
        products.remove(at: index)
    }
}
