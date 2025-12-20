import SwiftUI

private extension OptionsView{
    enum Texts{
        static let sortHeader = "Сортировка"
        static let sortByName = "По имени"
        static let sortByCal = "По калорийности"
        static let sortByMass = "По массе"
        static let filterHeader = "Фильтры"
        static let showFastFood = "Показывать фаст-фуд"
        static let showOnlyFavs = "Только избранные"
        static let optionsHeader = "Опции"
        static let readyHeader = "Готово"
    }
}

struct OptionsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        NavigationView {
            List {
                Section(header: Text(Texts.sortHeader)){
                    Button(Texts.sortByName) {}
                    Button(Texts.sortByCal) {}
                    Button(Texts.sortByMass) {}
                }
                Section(header: Text(Texts.filterHeader)){
                    Toggle(Texts.showFastFood, isOn: .constant(false))
                    Toggle(Texts.showOnlyFavs, isOn: .constant(false))
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle(Texts.optionsHeader)
            .navigationBarItems(trailing: Button(Texts.readyHeader) {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
