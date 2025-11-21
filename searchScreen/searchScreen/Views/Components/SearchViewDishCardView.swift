import SwiftUI

struct SearchViewDishCardView: View {
    let item: SearchViewDish
    
    private var imageGradient: LinearGradient {
        LinearGradient(
            colors: [.clear, Color(red: 66/255, green: 78/255, blue: 43/255)],
            startPoint: .leading,
            endPoint: .trailing)
    }
    
    private var additionButton: some View {
        ZStack{
            Rectangle()
                .frame(width: 75, height: 150)
                .foregroundColor(Color(red: 120/255, green: 153/255, blue: 59/255))
            Image(systemName: "plus")
                .font(.system(size:44, weight: .bold))
                .foregroundColor(Color(red: 229/255, green: 217/255, blue: 198/255))
        }
    }
    
    var body: some View {
        GeometryReader{ geometry in
            HStack(alignment: .top){
                ZStack(alignment: .trailing){
                    Image("Rice")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width * 0.4, height: 150)
                        .clipped()
                    imageGradient
                        .frame(width: 75, height: 150)
                }
                VStack(alignment: .leading){
                    Text(item.title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(red: 229/255, green: 217/255, blue: 198/255))
                        .padding(.top, 8)
                        .padding(.bottom, -4)
                    Rectangle()
                        .frame(width: max(0, geometry.size.width*0.6-90), height: 2)
                        .foregroundColor(Color(red: 229/255, green: 217/255, blue: 198/255))
                        .cornerRadius(1)
                    Text(item.subtitle)
                        .font(.system(size: 17))
                        .foregroundColor(Color(red: 229/255, green: 217/255, blue: 198/255))
                        .padding(.top, -3)
                }
                .frame(width: max(0, geometry.size.width*0.6-90), height: 150, alignment: .topLeading)
                Button(action:{
                    //add food to ration
                    print("addition button pressed")
                }){
                    additionButton
                }
                .buttonStyle(PlainButtonStyle())
            }
            .background(Color(red: 66/255, green: 78/255, blue: 43/255))
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.8), radius: 5, x:0, y:5)
            .padding(.trailing, 12)
        }
    }
    
    struct ItemCard_Previews: PreviewProvider{
        static var previews: some View {
            SearchViewDishCardView(item: SearchViewDish(title: "Еда Еда Еда Еда Еда Еда",
                                    subtitle: "1000 ккал\n152 г жира\n150 г углеводов\n145 г белка",
                                    imageName: "rice"))
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
