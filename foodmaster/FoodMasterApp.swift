import SwiftUI

@main
struct FoodMasterApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                DishDetailsView(dish: .mock)
            }
        }
    }
}
