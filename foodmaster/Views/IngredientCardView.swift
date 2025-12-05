import SwiftUI

struct IngredientCardView: View {
    let product: Product
    var onDelete: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 0) {
            ingredientImage()
            
            ZStack() {
                HStack() {
                    ingredientInfoStack()
                    
                    Spacer()
                    
                    VStack() {
                        deleteButton()

                        Spacer()
                    }
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        weightText()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: Constants.cardHeight, alignment: .leading)
        .background(Constants.backgroundColor)
        .cornerRadius(Constants.cardCornerRadius)
        .shadow(radius: Constants.shadowRadius)
    }
}

private extension IngredientCardView {
    private enum Constants {
        static let textColor: Color = Color(red: 229/255, green: 217/255, blue: 198/255)
        static let backgroundColor: Color = Color(red: 66/255, green: 78/255, blue: 43/255)
        static let weightBackgroundColor: Color = Color(red: 145/255, green: 137/255, blue: 76/255)
        static let cardCornerRadius: CGFloat = 12
        static let cardHeight: CGFloat = 140
        static let imageWidth: CGFloat = 140
        static let ingredientInfoStackWidth: CGFloat = 140
        static let shadowRadius: CGFloat = 4
        static let titleHeight: CGFloat = 54
    }
    
    private func ingredientImage() -> some View {
        Image("image_placeholder")
            .resizable()
            .frame(maxWidth: Constants.imageWidth, maxHeight: Constants.cardHeight)
            .scaledToFill()
            .overlay(
                LinearGradient(gradient: Gradient(colors: [
                    Color.clear,
                    Color(Constants.backgroundColor).opacity(0.2),
                    Color(Constants.backgroundColor)
                ]), startPoint: .leading, endPoint: .trailing)
            )
    }
    
    private func ingredientInfoStack() -> some View {
        VStack(alignment: .leading, spacing: 0){
            Text(product.name)
                .font(.title3)
                .fontWeight(.bold)
                .frame(height: Constants.titleHeight)
            Rectangle()
                .frame(height: 1)
            VStack(alignment: .leading, spacing: 0) {
                Text("\(product.calories) ккал")
                Text("\(product.protein) г белка")
                Text("\(product.fats) г жиров")
                Text("\(product.carbs) г углеводов")
            }
        }
        .foregroundColor(Constants.textColor)
        .frame(width: Constants.ingredientInfoStackWidth)
    }
    
    private func deleteButton() -> some View {
        Button {
            onDelete?()
        } label: {
            Image(systemName: "trash")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Constants.textColor)
        }
        .tint(Constants.textColor.opacity(0.15))
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.circle)
        .padding(.vertical, 3)
    }
    
    private func weightText() -> some View {
        Text("\(product.weight) гр.")
            .fontWeight(.bold)
            .foregroundColor(Constants.textColor)
            .padding(.horizontal, 14)
            .padding(.vertical, 4)
            .background(
                Rectangle()
                    .foregroundColor(Constants.weightBackgroundColor)
                    .mask(
                        RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                            .path(in: CGRect(x: 0, y: 0, width: 200, height: 40))
                    )
            )
    }
}

#Preview {
    IngredientCardView(product: Product(name: "Рис отварной", calories: 100, protein: 10, fats: 40, carbs: 50, weight: 100, imageUrl: nil))
}
