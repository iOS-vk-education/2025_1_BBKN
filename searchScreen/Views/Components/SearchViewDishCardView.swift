import SwiftUI

private extension SearchViewDishCardView {
    enum MyColors {
        static let darkGreen = Color(red: 66/255, green: 78/255, blue: 43/255)
        static let lightGreen = Color(red: 120/255, green: 153/255, blue: 59/255)
        static let beige = Color(red: 229/255, green: 217/255, blue: 198/255)
        static let shadow = Color.gray.opacity(0.8)
    }
    enum Sizing {
        static let cardHeight = 150.0
        static let additionButtonWidth = 75.0
        static let fontSizeExtraLarge = 44.0
        static let imagePart = 0.4
        static let fontSizeHeader = 20.0
        static let fontSizeText = 17.0
        static let headerTopPadding = 8.0
        static let headerBottomPadding = -4.0
        static let divisorLineHeight = 2.0
        static let divisorLineCornerRadius = 1.0
        static let headerAndTextPart = 0.6
        static let safezone = 90.0
        static let cornerRadiusOfCard = 12.0
        static let cardPadding = 12.0
        static let shadowRadius = 5.0
        static let shadowY = 5.0
        static let subtitlePadding = -3.0
    }
    enum Texts {
        static let plusPicName = "plus"
        static let stubButtonActionText = "addition button pressed"
        static let stubImageName = "Rice"
        static let stubCardTitle = "Еда Еда Еда Еда Еда Еда"
        static let stubCardSubtitle = "1000 ккал\n152 г жира\n150 г углеводов\n145 г белка"
        static let stubImageName2 = "rice"
    }
}

struct SearchViewDishCardView: View {
    let item: SearchViewDishModel
    
    private var imageGradient: LinearGradient {
        LinearGradient(
            colors: [.clear, MyColors.darkGreen],
            startPoint: .leading,
            endPoint: .trailing)
    }
    
    private var additionButton: some View {
        ZStack {
            Rectangle()
                .frame(width: Sizing.additionButtonWidth, height: Sizing.cardHeight)
                .foregroundColor(MyColors.lightGreen)
            Image(systemName: Texts.plusPicName)
                .font(.system(size: Sizing.fontSizeExtraLarge, weight: .bold))
                .foregroundColor(MyColors.beige)
        }
    }
    
    var body: some View {
        GeometryReader{ geometry in
            HStack(alignment: .top) {
                ZStack(alignment: .trailing) {
                    Image(Texts.stubImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width * Sizing.imagePart, height: Sizing.cardHeight)
                        .clipped()
                    imageGradient
                        .frame(width: Sizing.additionButtonWidth, height: Sizing.cardHeight)
                }
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.system(size: Sizing.fontSizeHeader, weight: .bold))
                        .foregroundColor(MyColors.beige)
                        .padding(.top, Sizing.headerTopPadding)
                        .padding(.bottom, Sizing.headerBottomPadding)
                    Rectangle()
                        .frame(width: max(0, geometry.size.width*Sizing.headerAndTextPart-Sizing.safezone), height: Sizing.divisorLineHeight)
                        .foregroundColor(MyColors.beige)
                        .cornerRadius(Sizing.divisorLineCornerRadius)
                    Text(item.subtitle)
                        .font(.system(size: Sizing.fontSizeText))
                        .foregroundColor(MyColors.beige)
                        .padding(.top, Sizing.subtitlePadding)
                }
                .frame(width: max(0, geometry.size.width*Sizing.headerAndTextPart-Sizing.safezone), height: Sizing.cardHeight, alignment: .topLeading)
                Button(action:{
                    print(Texts.stubButtonActionText)
                }){
                    additionButton
                }
                .buttonStyle(PlainButtonStyle())
            }
            .background(MyColors.darkGreen)
            .cornerRadius(Sizing.cornerRadiusOfCard)
            .shadow(color: MyColors.shadow, radius: Sizing.shadowRadius, x:0, y:Sizing.shadowY)
            .padding(.trailing, Sizing.cardPadding)
        }
    }
    
    struct ItemCard_Previews: PreviewProvider {
        static var previews: some View {
            SearchViewDishCardView(item: SearchViewDishModel(title: Texts.stubCardTitle,
                                                             subtitle: Texts.stubCardSubtitle,
                                                             imageName: Texts.stubImageName2))
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
