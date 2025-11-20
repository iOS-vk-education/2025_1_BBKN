//
//  DishDetailsView.swift
//  foodmaster
//
//  Created by Arthur on 18.11.2025.
//

import SwiftUI

struct DishDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    
    let dish: Dish
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Зелёный фон на весь экран
            Color.theme.primary
                .ignoresSafeArea()
            
            // Карточка на весь экран
            RoundedRectangle(cornerRadius: 40, style: .continuous)
                .fill(Color.theme.cardBackground)
                .ignoresSafeArea(edges: .bottom)
                .overlay(cardContent, alignment: .top)
                .padding(.top, 8)
            
            // Кнопка "назад" в левом верхнем углу картинки
            backButton
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Back Button
    private var backButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "arrow.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color.theme.primary)
                .frame(width: 44, height: 44)
                .background(Color.theme.cardBackground)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
        }
        .padding(.leading, 24)
        .padding(.top, 32)
    }
    
    // MARK: - Card Content
    private var cardContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 12)
                
                // Картинка блюда
                dishImageView
                    .padding(.horizontal, 12)
                
                // Текстовая часть
                infoSectionContent
            }
            .frame(maxWidth: .infinity, alignment: .top)
        }
    }
    
    // MARK: - Dish Image
    private var dishImageView: some View {
        ZStack {
            if let imageUrl = dish.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        placeholderImage
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        placeholderImage
                    @unknown default:
                        placeholderImage
                    }
                }
            } else {
                placeholderImage
            }
        }
        .frame(height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
    
    private var placeholderImage: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .overlay(
                Image(systemName: "photo")
                    .font(.system(size: 50))
                    .foregroundColor(.gray.opacity(0.5))
            )
    }
    
    // MARK: - Info Section Content
    private var infoSectionContent: some View {
        VStack(spacing: 0) {
            // Название
            Text(dish.name)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color.theme.text)
                .padding(.top, 20)
            
            // Подзаголовок
            if let subtitle = dish.subtitle {
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(Color.theme.textSecondary)
                    .padding(.top, 8)
            }
            
            // Заголовок "На 100 г"
            Text("На 100 г")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color.theme.textSecondary)
                .padding(.top, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            // Пищевая ценность
            nutritionalInfoView
                .padding(.top, 8)
                .padding(.bottom, 12)
            
            // Описание
            Text(dish.description)
                .font(.system(size: 15))
                .foregroundColor(Color.theme.text)
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 100)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
    
    // MARK: - Nutritional Info
    private var nutritionalInfoView: some View {
        HStack(spacing: 0) {
            NutritionItem(value: dish.calories, unit: "ккал", showUnit: true, label: nil)
            Spacer()

            NutritionItem(value: dish.fat, unit: "г", showUnit: true, label: "жира")
            Spacer()

            NutritionItem(value: dish.carbs, unit: "г", showUnit: true, label: "углеводов")
            Spacer()

            NutritionItem(value: dish.protein, unit: "г", showUnit: true, label: "белка")
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Nutrition Item Component
struct NutritionItem: View {
    let value: Int
    let unit: String
    let showUnit: Bool
    let label: String?
    
    var body: some View {
        VStack(spacing: 2) {
            // Число с единицей справа (для Б/Ж/У) или только число (для калорий)
            if unit == "ккал" {
                Text("\(value)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.theme.text)
                
                Text(unit)
                    .font(.system(size: 13))
                    .foregroundColor(Color.theme.textSecondary)
            } else {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("\(value)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.theme.text)
                    
                    Text(unit)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.theme.text)
                }
            }
            
            if let label = label {
                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(Color.theme.textSecondary)
            }
        }
    }
}

// MARK: - Model + Mocks
struct Dish: Identifiable, Codable {
    let id: String
    let name: String
    let subtitle: String?
    let description: String
    let imageUrl: String?
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int
    let price: Double
    let category: String?
}

extension Dish {
    static let mock = Dish(
        id: "1",
        name: "Рис отварной",
        subtitle: "Отборный рис помогает потенциалу",
        description: "Отборный рис помогает потенциалу. род однолетних и многолетних травянистых растений семейства Злаки. Рис. Oryza sativa.",
        imageUrl: nil,
        calories: 1000,
        protein: 152,
        carbs: 150,
        fat: 145,
        price: 250,
        category: "Гарниры"
    )
}

#Preview {
    DishDetailsView(dish: .mock)
        .preferredColorScheme(.light)
}
