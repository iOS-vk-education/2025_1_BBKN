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
            DesignColors.macroRed,
            DesignColors.macroGreen,
            DesignColors.macroBlue
        ]
    }

    struct Label {
        static let radiusOffset: CGFloat = 30
        static let scaleSteps = 4

        static func scaleValues(for goal: Int) -> [Int] {
            guard scaleSteps > 1, goal >= 0 else { return [0] }
            let step = CGFloat(goal) / CGFloat(scaleSteps - 1)
            var values: [Int] = []
            for i in 0..<(scaleSteps - 1) {
                let v = Int(round(step * CGFloat(i)))
                values.append(v)
            }
            // последний элемент принудительно равен цели
            values.append(goal)
            return values
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

        // Новый: внутренний отступ текста от границ колонки
        static let horizontalPadding: CGFloat = 8
        // Новый: небольшой сдвиг вертикальной линии внутрь (чтобы текст не лип)
        static let separatorInset: CGFloat = 2
    }
}

