import UIKit

struct ChartConfiguration {
    struct Arc {
        static let mainWidth: CGFloat = 38
        static let macroWidth: CGFloat = 4
        static let startAngle: CGFloat = .pi * 0.8
        static let endAngle: CGFloat = .pi * 2.2
        static let margin: CGFloat = 8
    }

    struct Macro {
        static let offsetFromMain: [CGFloat] = [43, 49, 55]
        static let colors: [UIColor] = [
            DesignSystem.Colors.macroRed,
            DesignSystem.Colors.macroGreen,
            DesignSystem.Colors.macroBlue
        ]
    }

    struct Label {
        static let radiusOffset: CGFloat = 30
        static let scaleSteps = 4

        static func scaleValues(for goal: Int) -> [Int] {
            let step = goal / (scaleSteps - 1)
            return (0..<scaleSteps).map { $0 * step }
        }
    }

    struct CenterRect {
        static let width: CGFloat = 127
        static let height: CGFloat = 62
        static let cornerRadius: CGFloat = 20
        static let borderWidth: CGFloat = 4
        static let caloriesYOffset: CGFloat = -30
        static let unitYOffset: CGFloat = 6
    }

    struct MacroLabels {
        static let height: CGFloat = 40
        static let totalWidth: CGFloat = 250
        static let bottomOffset: CGFloat = 89
        static let valueYOffset: CGFloat = 0
        static let nameYOffset: CGFloat = 20
        static let separatorTopOffset: CGFloat = 3
    }
}

