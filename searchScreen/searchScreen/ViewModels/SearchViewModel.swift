import Foundation
import Combine

class ContentViewModel: ObservableObject{
    @Published var searchText = ""
    @Published var showOptions = false
    @Published var items: [SearchViewDish] = []
    
    private var allItems: [SearchViewDish] = []
    
    init() {
        loadItems()
    }
    
    func loadItems() {
        allItems = [
            SearchViewDish(title: "Заголовок 1", subtitle: "Описание элемента 1", imageName: "фото1"),
            SearchViewDish(title: "Заголовок 2", subtitle: "Описание элемента 2", imageName: "фото2"),
            SearchViewDish(title: "Заголовок 3", subtitle: "Описание элемента 3", imageName: "фото3"),
            SearchViewDish(title: "Заголовок 4", subtitle: "Описание элемента 4", imageName: "фото4"),
            SearchViewDish(title: "Заголовок 5", subtitle: "Описание элемента 5", imageName: "фото5"),
            SearchViewDish(title: "Заголовок 6", subtitle: "Описание элемента 6", imageName: "фото1"),
            SearchViewDish(title: "Заголовок 7", subtitle: "Описание элемента 7", imageName: "фото2"),
            SearchViewDish(title: "Заголовок 8", subtitle: "Описание элемента 8", imageName: "фото3"),
            SearchViewDish(title: "Заголовок 9", subtitle: "Описание элемента 9", imageName: "фото4"),
            SearchViewDish(title: "Заголовок 10", subtitle: "Описание элемента 10", imageName: "фото5"),
        ]
        items = allItems
    }
    
    func addItem(_ item: SearchViewDish) {
        items.append(item)
    }
    
    func deleteItem(_ item: SearchViewDish) {
        items.removeAll{$0.id == item.id}
    }
    
    var filteredItems: [SearchViewDish] {
        if searchText.isEmpty {
            return items
        }
        else {
            return items.filter{$0.title.lowercased().contains(searchText.lowercased())}
        }
    }
}
