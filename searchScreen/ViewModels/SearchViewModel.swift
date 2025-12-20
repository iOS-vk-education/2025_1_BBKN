import Foundation
import Combine

private enum StubTexts {
    static let stubTitle = "plus"
    static let stubSubtitle = "addition button pressed"
    static let stubImageName = "Rice"
}

class ContentViewModel: ObservableObject{
    @Published var searchText = ""
    @Published var showOptions = false
    @Published var items: [SearchViewDishModel] = []
    
    private var allItems: [SearchViewDishModel] = []
    
    init() {
        loadItems()
    }
    
    func loadItems() {
        allItems = [
            SearchViewDishModel(title: StubTexts.stubTitle, subtitle: StubTexts.stubSubtitle, imageName: StubTexts.stubImageName),
            SearchViewDishModel(title: StubTexts.stubTitle, subtitle: StubTexts.stubSubtitle, imageName: StubTexts.stubImageName),
            SearchViewDishModel(title: StubTexts.stubTitle, subtitle: StubTexts.stubSubtitle, imageName: StubTexts.stubImageName),
            SearchViewDishModel(title: StubTexts.stubTitle, subtitle: StubTexts.stubSubtitle, imageName: StubTexts.stubImageName),
            SearchViewDishModel(title: StubTexts.stubTitle, subtitle: StubTexts.stubSubtitle, imageName: StubTexts.stubImageName),
            SearchViewDishModel(title: StubTexts.stubTitle, subtitle: StubTexts.stubSubtitle, imageName: StubTexts.stubImageName),
            SearchViewDishModel(title: StubTexts.stubTitle, subtitle: StubTexts.stubSubtitle, imageName: StubTexts.stubImageName),
            SearchViewDishModel(title: StubTexts.stubTitle, subtitle: StubTexts.stubSubtitle, imageName: StubTexts.stubImageName),
            SearchViewDishModel(title: StubTexts.stubTitle, subtitle: StubTexts.stubSubtitle, imageName: StubTexts.stubImageName),
            SearchViewDishModel(title: StubTexts.stubTitle, subtitle: StubTexts.stubSubtitle, imageName: StubTexts.stubImageName),
        ]
        items = allItems
    }
    
    func addItem(_ item: SearchViewDishModel) {
        items.append(item)
    }
    
    func deleteItem(_ item: SearchViewDishModel) {
        items.removeAll{$0.id == item.id}
    }
    
    var filteredItems: [SearchViewDishModel] {
        guard !searchText.isEmpty else {
            return items
        }

        return items.filter{ $0.title.lowercased().contains(searchText.lowercased()) }
    }
}
