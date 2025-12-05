import SwiftUI

@main
struct FoodMasterApp: App {
    var body: some Scene {
        WindowGroup {
            DishDetailsView(dish: .mock)
        }
    }
}
