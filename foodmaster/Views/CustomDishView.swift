import SwiftUI

struct CustomDishView: View {
    @StateObject private var viewModel = CustomDishViewModel()
    @State var text: String = ""
    
    var body: some View {
        ZStack(){
            Color(red: 229/255, green: 217/255, blue: 198/255)
                .ignoresSafeArea()
            
            ScrollView(){
                VStack(spacing: 16){
                    Text("Своё блюдо")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 66/255, green: 78/255, blue: 43/255))
                    Image("image_placeholder") // TODO: Реализовать функционал добавления изображения к собственному блюду
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(40)
                    TextField("", text: $text, prompt: Text("Название").foregroundColor(Color(red: 205/255, green: 197/255, blue: 174/255, opacity: 0.5)))
                        .padding()
                        .background(Color(red: 66/255, green: 78/255, blue: 43/255))
                        .cornerRadius(40)
                        .frame(minHeight: 50)
                    Text("Ингредиенты:")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 66/255, green: 78/255, blue: 43/255))
                    Button {// TODO: Реализовать функционал добавления ингредиента
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 70)
                    }
                    .tint(Color(red: 98/255, green: 123/255, blue: 52/255))
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 12))
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    CustomDishView()
}
