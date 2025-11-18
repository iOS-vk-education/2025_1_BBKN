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
            
            // Большая бежёвая карточка на весь экран
            RoundedRectangle(cornerRadius: 40, style: .continuous)
                .fill(Color.theme.cardBackground)
                .ignoresSafeArea(edges: .bottom)
                .overlay(cardContent, alignment: .top)   // внутрь кладём контент
                .padding(.top, 8)                        // небольшой зазор, чтобы был виден зелёный фон сверху
            
            // Кнопка "назад" поверх картинки и карточки
            backButton
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Back Button
    private var backButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "arrow.left")
                .font(.system(size: 20))
                .foregroundColor(Color.theme.primary)
                .frame(width: 44, height: 44)
                .background(Color.theme.buttonBackground)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .padding(.leading, 16)
        .padding(.top, 12) // ниже камеры/ноутча
    }
    
    // MARK: - Card Content (всё, что внутри бежевой карточки)
    private var cardContent: some View {
        VStack(spacing: 0) {
            // Отступ сверху, чтобы видно было скругление карточки
            Spacer()
                .frame(height: 60)
            
            // Картинка блюда внутри карточки
            dishImageView
                .padding(.horizontal, 16)
            
            // Текстовая часть
            infoSection
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    // MARK: - Dish Image
    private var dishImageView: some View {
        ZStack(alignment: .bottomTrailing) {
            // TODO: заменить на реальный URL с backend'а
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
            
            Button(action: {
                // TODO: сюда подключить добавление в корзину
                print("Add to cart: \(dish.name)")
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.theme.addButton)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
            }
            .padding(16)
        }
        .frame(height: 260)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
    
    private var placeholderImage: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .overlay(
                Image(systemName: "photo")
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
            )
    }
    
    // MARK: - Info Section (нижняя часть карточки)
    private var infoSection: some View {
        VStack(spacing: 0) {
            // Название
            Text(dish.name)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color.theme.text)
                .padding(.top, 24)
            
            // Подзаголовок
            if let subtitle = dish.subtitle {
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(Color.theme.textSecondary)
                    .padding(.top, 4)
            }
            
            // Линия / отступ
            nutritionalInfoView
                .padding(.top, 16)
            
            // Описание
            ScrollView {
                Text(dish.description)
                    .font(.system(size: 16))
                    .foregroundColor(Color.theme.text)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    // MARK: - Nutritional Info
    private var nutritionalInfoView: some View {
        HStack(spacing: 16) {
            NutritionItem(value: dish.calories, unit: "ккал", label: "на 100 г")
            NutritionItem(value: dish.fat,      unit: "г",    label: "жира")
            NutritionItem(value: dish.carbs,    unit: "г",    label: "углеводов")
            NutritionItem(value: dish.protein,  unit: "г",    label: "белка")
        }
    }
}

// MARK: - Nutrition Item Component
struct NutritionItem: View {
    let value: Int
    let unit: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text("\(value)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.theme.text)
                
                Text(unit)
                    .font(.system(size: 14))
                    .foregroundColor(Color.theme.textSecondary)
            }
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(Color.theme.textSecondary)
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
        imageUrl: nil,          // TODO: сюда URL от backend
        calories: 1000,
        protein: 152,
        carbs: 150,
        fat: 145,
        price: 250,
        category: "Гарниры"
    )
}

#Preview {
    NavigationView {
        DishDetailsView(dish: .mock)
    }
}
