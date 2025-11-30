import SwiftUI

struct CustomDishView: View {
    @StateObject private var viewModel = CustomDishViewModel()
    @State var text: String = ""

    var body: some View {
        ZStack() {
            Constants.backgroundColor
                .ignoresSafeArea()
            
            ScrollView() {
                VStack(spacing: Constants.spacingAndPadding) {
                    ZStack() {
                        Text(Constants.titleText)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Constants.accentColor)
                        
                        HStack() {
                            Spacer()
                            
                            acceptButton()
                        }
                    }
                    
                    Image("image_placeholder") // TODO: Реализовать функционал добавления изображения к собственному блюду
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(Constants.textFieldCornerRadius)
                    
                    dishNameTextField()
                    
                    nutrientsSummary()
                    
                    Divider()
                        .frame(height: 3)
                        .background(Constants.separateLineColor)
                        .padding(.horizontal, -Constants.spacingAndPadding)
                    
                    Text(Constants.ingredientTitleText)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Constants.accentColor)
                    
                    addButton()
                    
                    LazyVStack(spacing: Constants.spacingAndPadding) {
                        ForEach(viewModel.products) { product in
                            IngredientCardView(product: product) {
                                viewModel.removeProduct(product)
                            }
                          }
                        }
                }
                .padding(.horizontal, Constants.spacingAndPadding)
            }
        }
    }
}

private extension CustomDishView {
    enum Constants {
        static let backgroundColor: Color = Color(red: 229/255, green: 217/255, blue: 198/255)
        static let accentColor: Color = Color(red: 66/255, green: 78/255, blue: 43/255)
        static let textFieldPlaceholderColor: Color = Color(red: 229/255, green: 217/255, blue: 198/255, opacity: 0.5)
        static let addButtonColor: Color = Color(red: 98/255, green: 123/255, blue: 52/255)
        static let separateLineColor: Color = Color(red: 205/255, green: 197/255, blue: 174/255)
        static let textFieldCornerRadius: CGFloat = 40
        static let spacingAndPadding: CGFloat = 16
        static let addButtonCornerRadius: CGFloat = 12
        static let summaryWidth: CGFloat = 130
        static let textFieldPlaceholder: String = "Введите название своего блюда"
        static let titleText: String = "Своё блюдо"
        static let ingredientTitleText: String = "Ингредиенты:"
    }
    
    private func acceptButton() -> some View {
        Button {
            // TODO: Реализовать функционал добавления блюда в рацион
        } label: {
            Image(systemName: "checkmark")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Constants.backgroundColor)
        }
        .tint(Constants.accentColor)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.circle)
    }
    
    private func addButton() -> some View {
        Button {
            viewModel.addProduct() // TODO: Реализовать добавление ингредиента
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 50))
                .fontWeight(.bold)
                .foregroundColor(Constants.backgroundColor)
                .frame(maxWidth: .infinity)
        }
        .tint(Constants.addButtonColor)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: Constants.addButtonCornerRadius))
    }
    
    private func dishNameTextField() -> some View {
        TextField("", text: $text, prompt: Text(Constants.textFieldPlaceholder).foregroundColor(Constants.textFieldPlaceholderColor))
            .padding()
            .foregroundColor(Constants.backgroundColor)
            .background(Constants.accentColor)
            .cornerRadius(Constants.textFieldCornerRadius)
    }
    
    private func nutrientsSummary() -> some View {
        HStack(alignment: .center, spacing: Constants.spacingAndPadding) {
            VStack(spacing: -6) {
                Text("\(viewModel.totalCalories)")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Constants.accentColor)

                Text("ККал")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Constants.accentColor)
            }
            .frame(minWidth: Constants.summaryWidth)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.addButtonCornerRadius)
                    .stroke(Constants.accentColor, lineWidth: 3)
            )
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("\(viewModel.totalFats) г")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("жиры")
                        .fontWeight(.bold)
                        .foregroundColor(Constants.accentColor)
                }

                HStack {
                    Text("\(viewModel.totalCarbs) г")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("углеводы")
                        .fontWeight(.bold)
                        .foregroundColor(Constants.accentColor)
                }

                HStack {
                    Text("\(viewModel.totalProtein) г")
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    Text("белки")
                        .fontWeight(.bold)
                        .foregroundColor(Constants.accentColor)
                }
            }
        }
    }
}

#Preview {
    CustomDishView()
}


