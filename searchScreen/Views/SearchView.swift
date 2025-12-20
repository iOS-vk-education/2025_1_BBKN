import SwiftUI

private extension SearchView {
    enum MyColors {
        static let darkGreen = Color(red: 66/255, green: 78/255, blue: 43/255)
        static let lightGreen = Color(red: 120/255, green: 153/255, blue: 59/255)
        static let beige = Color(red: 229/255, green: 217/255, blue: 198/255)
        static let darkBeige = Color(red: 205/255, green: 197/255, blue: 174/255)
        static let shadow = Color.gray.opacity(0.8)
    }
    enum Sizing {
        static let fontSizeLarge = 28.0
        static let optionsIconSize = 25.0
        static let optionsButtonSize = 45.0
        static let tabBarTopPadding = 10.0
        static let tabBarBottomPadding = -10.0
        static let tabButtonCornerRadius = 15.0
        static let tabButtonPadding = 10.0
        static let tabButtonIconSize = 40.0
        static let tabButtonHeight = 50.0
        static let tabButtonTextSize = 14.0
        static let searchFieldHeight = 45.0
        static let searchFieldCornerRadius = 40.0
        static let searchPlaceholderLeftPadding = 20.0
        static let searchFieldPadding = 10.0
        static let searchFieldLeftPadding = 11.0
        static let searchStackBottomPadding = 20.0
        static let itemCardListPaddingBottom = -5.0
        static let edgeInsetsForItemCard = EdgeInsets(top: 15, leading: 15, bottom: 140, trailing: 15)
    }
    enum Texts {
        static let headerMain = "Поиск блюд"
        static let optionsImageName = "line.3.horizontal"
        static let searchPlaceholder = "Название"
        static let searchIconName = "system.magnifyingglass"
        static let rationIconName = "Ration"
        static let myDishIconName = "system.star.fill"
        static let searchIconTitle = "Поиск"
        static let rationIconTitle = "Рацион"
        static let myDishIconTitle = "Блюдо"
    }
}

struct SearchView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        VStack{
            VStack{
                Text(Texts.headerMain)
                    .multilineTextAlignment(.center)
                    .font(.system(size: Sizing.fontSizeLarge, weight: .heavy))
                    .foregroundColor(MyColors.darkGreen)
                HStack {
                    Button(action: {
                        viewModel.showOptions.toggle()
                    }) {
                        ZStack{
                            Circle()
                                .fill(MyColors.darkGreen)
                                .frame(width: Sizing.optionsButtonSize, height: Sizing.optionsButtonSize)
                            Image(systemName: Texts.optionsImageName)
                                .foregroundColor(MyColors.beige)
                                .font(.system(size: Sizing.optionsIconSize, weight: .bold))
                        }
                    }
                    ZStack{
                        TextField("", text: $viewModel.searchText)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(MyColors.beige)
                            .padding(Sizing.searchFieldPadding)
                            .padding(.leading, Sizing.searchFieldLeftPadding)
                            .background(RoundedRectangle(cornerRadius: Sizing.searchFieldCornerRadius)
                                            .fill(MyColors.darkGreen))
                            .frame(height: Sizing.searchFieldHeight)
                        if viewModel.searchText.isEmpty {
                            Text(Texts.searchPlaceholder)
                                .foregroundColor(MyColors.darkBeige)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, Sizing.searchPlaceholderLeftPadding)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .background(MyColors.beige)
            .zIndex(1)
            .padding(.bottom, Sizing.searchStackBottomPadding)
            List(viewModel.filteredItems) { item in
                SearchViewDishCardView(item: item)
                    .listRowInsets(Sizing.edgeInsetsForItemCard)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
            .listStyle(PlainListStyle())
            .padding(.bottom, Sizing.itemCardListPaddingBottom)
            HStack(spacing: 0){
                tabButton(icon: Texts.searchIconName, title: Texts.searchIconTitle, index: 0)
                tabButton(icon: Texts.rationIconName, title: Texts.rationIconTitle, index: 1)
                tabButton(icon: Texts.myDishIconName, title: Texts.myDishIconTitle, index: 2)
            }
            .padding(.top, Sizing.tabBarTopPadding)
            .padding(.bottom, Sizing.tabBarBottomPadding)
        }
        .background(MyColors.beige)
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
                        .font(.system(size: Sizing.tabButtonIconSize))
                        .frame(height: Sizing.tabButtonHeight)
                } else {
                    Image(icon)
                        .renderingMode(.template)
                        .frame(height: Sizing.tabButtonHeight)
                        
                }
                Text(title)
                    .font(.system(size: Sizing.tabButtonTextSize, weight: .bold))
            }
            .foregroundColor(selectedTab == index ? MyColors.beige : MyColors.darkGreen)
            .padding(Sizing.tabButtonPadding)
            .padding(.horizontal, Sizing.tabButtonPadding)
            .background(selectedTab == index ? MyColors.darkGreen : MyColors.darkBeige)
            .cornerRadius(Sizing.tabButtonCornerRadius)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
