import SwiftUI

struct IngredientCardView: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 0){
            Image("image_placeholder")
                .resizable()
                .frame(width: 139, height: 140)
                .scaledToFill()
                .overlay(
                    LinearGradient(gradient: Gradient(colors: [
                        Color.clear,
                        Color(Color(red: 66/255, green: 78/255, blue: 43/255)).opacity(0.2),
                        Color(Color(red: 66/255, green: 78/255, blue: 43/255))
                    ]), startPoint: .leading, endPoint: .trailing)
                )
            ZStack(alignment: .topTrailing){
                HStack{
                    VStack(alignment: .leading, spacing: 0){
                        Text(product.name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 229/255, green: 217/255, blue: 198/255))
                            .frame(height: 54)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color(red: 229/255, green: 217/255, blue: 198/255))
                        VStack(alignment: .leading, spacing: 0){
                            Text("\(product.calories) ккал")
                            Text("\(product.protein) г белка")
                            Text("\(product.fats) г жиров")
                            Text("\(product.carbs) г углеводов")
                        }
                        .foregroundColor(Color(red: 229/255, green: 217/255, blue: 198/255))
                    }
                    .frame(width: 140)
                    
                    Spacer()
                    
                    VStack() {
                        Button {
                            print("Delete button tap") // TODO: Реализовать функционал кнопки удаления
                        } label: {
                            ZStack{
                                Circle()
                                    .fill(Color(red: 90/255, green: 99/255, blue: 67/255))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "trash")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 229/255, green: 217/255, blue: 198/255))
                            }
                        }
                        .padding(4)
                        
                        Spacer()
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(product.weight) гр.")
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 229/255, green: 217/255, blue: 198/255))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 8)
                            .background(Color(red: 145/255, green: 137/255, blue: 76/255))
                    } // TODO: Сделать красивую угловую подпись граммовки, как на макете
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 140, alignment: .leading)
        .background(Color(red: 66/255, green: 78/255, blue: 43/255))
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .shadow(radius: 4)
    }
}

#Preview {
    IngredientCardView(product: Product(name: "Рис отварной", calories: 100, protein: 100, fats: 100, carbs: 100, weight: 100))
}
