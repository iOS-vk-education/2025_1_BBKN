import UIKit

struct DesignSystem {
    struct Colors {
        static let background = UIColor(red: 229/255, green: 217/255, blue: 198/255, alpha: 1)
        static let primaryText = UIColor(red: 68/255, green: 78/255, blue: 43/255, alpha: 1)
        static let divider = UIColor(red: 205/255, green: 197/255, blue: 174/255, alpha: 1)
        static let primaryButton = UIColor(red: 98/255, green: 123/255, blue: 52/255, alpha: 1)
        static let chartOrange = UIColor(red: 239/255, green: 127/255, blue: 26/255, alpha: 1)
        static let macroRed = UIColor(red: 205/255, green: 59/255, blue: 59/255, alpha: 1)
        static let macroGreen = UIColor(red: 58/255, green: 173/255, blue: 79/255, alpha: 1)
        static let macroBlue = UIColor(red: 71/255, green: 151/255, blue: 217/255, alpha: 1)
        static let centerRect = UIColor(red: 229/255, green: 217/255, blue: 198/255, alpha: 1)
    }

    struct Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 15
        static let extraLarge: CGFloat = 18
        static let dividerOffset: CGFloat = -25
    }

    struct Sizes {
        static let buttonHeight: CGFloat = 64
        static let buttonCornerRadius: CGFloat = 16
        static let cardHeight: CGFloat = 140
        static let chartHeight: CGFloat = 330
        static let titleHeight: CGFloat = 48
        static let consumedLabelHeight: CGFloat = 30
    }

    struct Fonts {
        static let title = UIFont.systemFont(ofSize: 32, weight: .heavy)
        static let sectionTitle = UIFont.systemFont(ofSize: 24, weight: .heavy)
        static let buttonTitle = UIFont.systemFont(ofSize: 44, weight: .bold)
        static let chartLargeValue = UIFont.systemFont(ofSize: 36, weight: .bold)
        static let chartLabel = UIFont.systemFont(ofSize: 24, weight: .bold)
        static let chartSubtitle = UIFont.systemFont(ofSize: 18, weight: .bold)
        static let macroLabel = UIFont.systemFont(ofSize: 17, weight: .bold)
    }

    struct Shadow {
        let color: UIColor
        let radius: CGFloat
        let opacity: Float
        let offset: CGSize

        static let buttonShadow = Shadow(
            color: UIColor.black.withAlphaComponent(0.1),
            radius: 8,
            opacity: 0.18,
            offset: CGSize(width: 0, height: 3)
        )

        func apply(to layer: CALayer) {
            layer.shadowColor = color.cgColor
            layer.shadowRadius = radius
            layer.shadowOpacity = opacity
            layer.shadowOffset = offset
        }
    }
}

