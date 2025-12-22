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
            Color.customPrimary
                .ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius, style: .continuous)
                .fill(Color.customCardBackground)
                .ignoresSafeArea(edges: .bottom)
                .overlay(cardContent, alignment: .top)
                .padding(.top, Constants.cardTopPadding)
            
            backButton
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Back Button
    private var backButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: Constants.backButtonImageName)
                .font(.system(size: Constants.backButtonFontSize, weight: Constants.backButtonFontWeight))
                .foregroundColor(Color.customPrimary)
                .frame(width: Constants.backButtonSize, height: Constants.backButtonSize)
                .background(Color.customCardBackground)
                .clipShape(Circle())
                .shadow(
                    color: Color.black.opacity(Constants.backButtonShadowOpacity),
                    radius: Constants.backButtonShadowRadius,
                    x: Constants.backButtonShadowX,
                    y: Constants.backButtonShadowY
                )
        }
        .padding(.leading, Constants.backButtonLeadingPadding)
        .padding(.top, Constants.backButtonTopPadding)
    }
    
    // MARK: - Card Content
    private var cardContent: some View {
        ScrollView {
            VStack(spacing: Constants.cardContentSpacing) {
                Spacer()
                    .frame(height: Constants.cardContentTopSpacing)
                
                dishImageView
                    .padding(.horizontal, Constants.dishImageHorizontalPadding)
                
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
        .frame(height: Constants.dishImageHeight)
        .clipShape(RoundedRectangle(cornerRadius: Constants.dishImageCornerRadius, style: .continuous))
    }
    
    private var placeholderImage: some View {
        Rectangle()
            .fill(Color.gray.opacity(Constants.placeholderImageOpacity))
            .overlay(
                Image(systemName: Constants.placeholderImageName)
                    .font(.system(size: Constants.placeholderImageSize))
                    .foregroundColor(.gray.opacity(Constants.placeholderImageIconOpacity))
            )
    }
    
    // MARK: - Info Section Content
    private var infoSectionContent: some View {
        VStack(spacing: Constants.infoSectionSpacing) {
            Text(dish.name)
                .font(.system(size: Constants.dishNameFontSize, weight: Constants.dishNameFontWeight))
                .foregroundColor(Color.customText)
                .padding(.top, Constants.dishNameTopPadding)
            
            if let subtitle = dish.subtitle {
                Text(subtitle)
                    .font(.system(size: Constants.subtitleFontSize))
                    .foregroundColor(Color.customTextSecondary)
                    .padding(.top, Constants.subtitleTopPadding)
            }
            
            Text(Constants.nutritionHeaderText)
                .font(.system(size: Constants.nutritionHeaderFontSize, weight: Constants.nutritionHeaderFontWeight))
                .foregroundColor(Color.customTextSecondary)
                .padding(.top, Constants.nutritionHeaderTopPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Constants.nutritionHeaderHorizontalPadding)
            
            nutritionalInfoView
                .padding(.top, Constants.nutritionalInfoTopPadding)
                .padding(.bottom, Constants.nutritionalInfoBottomPadding)
            
            Text(dish.description)
                .font(.system(size: Constants.descriptionFontSize))
                .foregroundColor(Color.customText)
                .multilineTextAlignment(.leading)
                .lineSpacing(Constants.descriptionLineSpacing)
                .padding(.horizontal, Constants.descriptionHorizontalPadding)
                .padding(.top, Constants.descriptionTopPadding)
                .padding(.bottom, Constants.descriptionBottomPadding)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
    
    // MARK: - Nutritional Info
    private var nutritionalInfoView: some View {
        HStack(spacing: Constants.nutritionalInfoSpacing) {
            NutritionItem(value: dish.calories, unit: .kcal, label: nil)
            Spacer()

            NutritionItem(value: dish.fat, unit: .gram, label: Constants.fatLabel)
            Spacer()

            NutritionItem(value: dish.carbs, unit: .gram, label: Constants.carbsLabel)
            Spacer()

            NutritionItem(value: dish.protein, unit: .gram, label: Constants.proteinLabel)
        }
        .padding(.horizontal, Constants.nutritionalInfoHorizontalPadding)
    }
}

// MARK: - Nutrition Item Component
struct NutritionItem: View {
    let value: Int
    let unit: Unit
    let label: String?
    
    var body: some View {
        VStack(spacing: Constants.nutritionItemSpacing) {
            if unit == .kcal {
                Text("\(value)")
                    .font(.system(size: Constants.nutritionValueFontSize, weight: Constants.nutritionValueFontWeight))
                    .foregroundColor(Color.customText)
                
                Text(unit.description)
                    .font(.system(size: Constants.nutritionKcalUnitFontSize))
                    .foregroundColor(Color.customTextSecondary)
            } else {
                HStack(alignment: .firstTextBaseline, spacing: Constants.nutritionGramUnitSpacing) {
                    Text("\(value)")
                        .font(.system(size: Constants.nutritionValueFontSize, weight: Constants.nutritionValueFontWeight))
                        .foregroundColor(Color.customText)
                    
                    Text(unit.description)
                        .font(.system(size: Constants.nutritionValueFontSize, weight: Constants.nutritionValueFontWeight))
                        .foregroundColor(Color.customText)
                }
            }
            
            if let label = label {
                Text(label)
                    .font(.system(size: Constants.nutritionLabelFontSize))
                    .foregroundColor(Color.customTextSecondary)
            }
        }
    }
}

// MARK: - Constants
private extension DishDetailsView {
    enum Constants {
        static let cardCornerRadius: CGFloat = 40
        static let cardTopPadding: CGFloat = 8
        static let cardContentSpacing: CGFloat = 0
        static let cardContentTopSpacing: CGFloat = 12
        
        static let backButtonImageName: String = "arrow.left"
        static let backButtonFontSize: CGFloat = 20
        static let backButtonFontWeight: Font.Weight = .medium
        static let backButtonSize: CGFloat = 44
        static let backButtonShadowOpacity: CGFloat = 0.08
        static let backButtonShadowRadius: CGFloat = 4
        static let backButtonShadowX: CGFloat = 0
        static let backButtonShadowY: CGFloat = 2
        static let backButtonLeadingPadding: CGFloat = 24
        static let backButtonTopPadding: CGFloat = 32
        
        static let dishImageHorizontalPadding: CGFloat = 12
        static let dishImageHeight: CGFloat = 300
        static let dishImageCornerRadius: CGFloat = 24
        
        static let placeholderImageOpacity: CGFloat = 0.2
        static let placeholderImageName: String = "photo"
        static let placeholderImageSize: CGFloat = 50
        static let placeholderImageIconOpacity: CGFloat = 0.5
        
        static let infoSectionSpacing: CGFloat = 0
        static let dishNameFontSize: CGFloat = 22
        static let dishNameFontWeight: Font.Weight = .bold
        static let dishNameTopPadding: CGFloat = 20
        
        static let subtitleFontSize: CGFloat = 14
        static let subtitleTopPadding: CGFloat = 8
        
        static let nutritionHeaderText: String = "На 100 г"
        static let nutritionHeaderFontSize: CGFloat = 12
        static let nutritionHeaderFontWeight: Font.Weight = .semibold
        static let nutritionHeaderTopPadding: CGFloat = 16
        static let nutritionHeaderHorizontalPadding: CGFloat = 20
        
        static let nutritionalInfoSpacing: CGFloat = 0
        static let nutritionalInfoTopPadding: CGFloat = 8
        static let nutritionalInfoBottomPadding: CGFloat = 12
        static let nutritionalInfoHorizontalPadding: CGFloat = 20
        
        static let fatLabel: String = "жира"
        static let carbsLabel: String = "углеводов"
        static let proteinLabel: String = "белка"
        
        static let descriptionFontSize: CGFloat = 15
        static let descriptionLineSpacing: CGFloat = 4
        static let descriptionHorizontalPadding: CGFloat = 20
        static let descriptionTopPadding: CGFloat = 12
        static let descriptionBottomPadding: CGFloat = 100
    }
}

private extension NutritionItem {
    enum Constants {
        static let nutritionItemSpacing: CGFloat = 2
        static let nutritionValueFontSize: CGFloat = 18
        static let nutritionValueFontWeight: Font.Weight = .bold
        static let nutritionKcalUnitFontSize: CGFloat = 13
        static let nutritionGramUnitSpacing: CGFloat = 2
        static let nutritionLabelFontSize: CGFloat = 11
    }
}

#Preview {
    DishDetailsView(dish: .mock)
        .preferredColorScheme(.light)
}
