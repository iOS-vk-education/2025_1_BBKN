import SwiftUI

struct OptionsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        NavigationView {
            List {
                Section(header: Text("Сортировка")){
                    Button("По имени") {}
                    Button("По калорийности") {}
                    Button("По массе") {}
                }
                Section(header: Text("Фильтры")){
                    Toggle("Показывать фаст-фуд", isOn: .constant(false))
                    Toggle("Только избранные", isOn: .constant(false))
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Опции")
            .navigationBarItems(trailing: Button("Готово") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
