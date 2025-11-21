import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        VStack{
            VStack{
                Text("Поиск блюд")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(Color(red: 66/255, green: 78/255, blue: 43/255))
                HStack {
                    Button(action: {
                        viewModel.showOptions.toggle()
                    }) {
                        ZStack{
                            Circle()
                                .fill(Color(red: 66/255, green: 78/255, blue: 43/255))
                                .frame(width: 45, height: 45)
                            
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(Color(red: 229/255, green: 217/255, blue: 198/255))
                                .font(.system(size: 25, weight: .bold))
                        }
                    }
                    ZStack{
                        TextField("", text: $viewModel.searchText)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color(red: 229/255, green: 217/255, blue: 198/255))
                            .padding(11)
                            .padding(.leading, 10)
                            .background(RoundedRectangle(cornerRadius: 40)
                                            .fill(Color(red: 66/255, green: 78/255, blue: 43/255)))
                            .frame(height: 45)
                        if viewModel.searchText.isEmpty {
                            Text("Название")
                                .foregroundColor(Color(red: 205/255, green: 197/255, blue: 174/255))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .background(Color(red: 229/255, green: 217/255, blue: 198/255))
            .zIndex(1)
            .padding(.bottom, 20)
            List(viewModel.filteredItems) { item in
                SearchViewDishCardView(item: item)
                    .listRowInsets(EdgeInsets(top: 15, leading: 15, bottom: 140, trailing: 15))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
            .listStyle(PlainListStyle())
            .padding(.bottom, -5)
            HStack(spacing: 0){
                tabButton(icon: "system.magnifyingglass", title: "Поиск", index: 0)
                tabButton(icon: "Ration", title: "Рацион", index: 1)
                tabButton(icon: "system.star.fill", title: "Блюдо", index: 2)
            }
            .padding(.top, 10)
            .padding(.bottom, -10)
        }
        .background(Color(red: 229/255, green: 217/255, blue: 198/255))
        .sheet(isPresented: $viewModel.showOptions) {
            OptionsView()
        }
    }
    
    private func tabButton(icon: String, title: String, index: Int) -> some View {
        Button(action: {selectedTab = index}) {
            VStack(spacing: 0){
                if (icon.hasPrefix("system.")){
                    let systemName = String(icon.dropFirst(7))
                    Image(systemName: systemName)
                        .font(.system(size: 40))
                        .frame(height: 50)
                } else {
                    Image(icon)
                        .renderingMode(.template)
                        .frame(height: 50)
                        
                }
                Text(title)
                    .font(.system(size: 14, weight: .bold))
            }
            .foregroundColor(selectedTab == index ? Color(red: 229/255, green: 217/255, blue: 198/255) : Color(red: 66/255, green: 78/255, blue: 43/255))
            .padding(10)
            .padding(.horizontal, 10)
            .background(selectedTab == index ? Color(red: 66/255, green: 78/255, blue: 43/255) : Color(red: 205/255, green: 197/255, blue: 174/255))
            .cornerRadius(15)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
