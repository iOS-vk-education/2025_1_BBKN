import UIKit

public struct CircularMacrosChartViewParameters {
    public let calories: Int
    public let caloriesGoal: Int
    public let fats: Int
    public let carbs: Int
    public let proteins: Int
    public let fatsGoal: Int
    public let carbsGoal: Int
    public let proteinsGoal: Int

    public init(
        calories: Int = 2500,
        caloriesGoal: Int = 2500,
        fats: Int = 150,
        carbs: Int = 150,
        proteins: Int = 150,
        fatsGoal: Int = 150,
        carbsGoal: Int = 150,
        proteinsGoal: Int = 150
    ) {
        self.calories = calories
        self.caloriesGoal = caloriesGoal
        self.fats = fats
        self.carbs = carbs
        self.proteins = proteins
        self.fatsGoal = fatsGoal
        self.carbsGoal = carbsGoal
        self.proteinsGoal = proteinsGoal
    }
}

final class CircularMacrosChartView: UIView {
    var calories: Int { didSet { setNeedsDisplay() } }
    var caloriesGoal: Int { didSet { setNeedsDisplay() } }
    var fats: Int { didSet { setNeedsDisplay() } }
    var carbs: Int { didSet { setNeedsDisplay() } }
    var proteins: Int { didSet { setNeedsDisplay() } }

    // Цели для макросов
    var fatsGoal: Int { didSet { setNeedsDisplay() } }
    var carbsGoal: Int { didSet { setNeedsDisplay() } }
    var proteinsGoal: Int { didSet { setNeedsDisplay() } }

    // Колбэк на тап по диаграмме
    var onTap: (() -> Void)?

    // MARK: - Init

    convenience init(parameters: CircularMacrosChartViewParameters) {
        self.init(frame: .zero)
        self.calories = parameters.calories
        self.caloriesGoal = parameters.caloriesGoal
        self.fats = parameters.fats
        self.carbs = parameters.carbs
        self.proteins = parameters.proteins
        self.fatsGoal = parameters.fatsGoal
        self.carbsGoal = parameters.carbsGoal
        self.proteinsGoal = parameters.proteinsGoal
    }

    override init(frame: CGRect) {
        self.calories = 2500
        self.caloriesGoal = 2500
        self.fats = 150
        self.carbs = 150
        self.proteins = 150
        self.fatsGoal = 150
        self.carbsGoal = 150
        self.proteinsGoal = 150
        super.init(frame: frame)
        backgroundColor = .clear
        isOpaque = false
        contentMode = .redraw
        setupGesture()
    }

    required init?(coder: NSCoder) {
        self.calories = 2500
        self.caloriesGoal = 2500
        self.fats = 150
        self.carbs = 150
        self.proteins = 150
        self.fatsGoal = 150
        self.carbsGoal = 150
        self.proteinsGoal = 150
        super.init(coder: coder)
        backgroundColor = .clear
        isOpaque = false
        contentMode = .redraw
        setupGesture()
    }

    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }

    @objc private func handleTap() {
        onTap?()
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - ChartConfiguration.Arc.margin

        drawMainArc(context: ctx, center: center, radius: radius)
        drawMacroArcs(context: ctx, center: center, radius: radius)
        drawScaleLabels(center: center, radius: radius)
        drawCenterCaloriesBox(center: center)
        drawMacroLabels(rect: rect, center: center)
    }
    
    // MARK: - Drawing helpers

    private func drawArc(context: CGContext,
                         center: CGPoint,
                         radius: CGFloat,
                         width: CGFloat,
                         color: UIColor,
                         startAngle: CGFloat,
                         endAngle: CGFloat) {
        context.setLineWidth(width)
        context.setStrokeColor(color.cgColor)
        context.addArc(center: center,
                       radius: radius,
                       startAngle: startAngle,
                       endAngle: endAngle,
                       clockwise: false)
        context.strokePath()
    }

    private func clampedProgress(numerator: Int, denominator: Int) -> CGFloat {
        guard denominator > 0 else { return 0 }
        let value = CGFloat(numerator) / CGFloat(denominator)
        return max(0, min(1, value))
    }
    
    private func drawMainArc(context: CGContext, center: CGPoint, radius: CGFloat) {
        let baseRadius = radius - ChartConfiguration.Arc.mainWidth / 2
        // 1) Базовая дуга (фон)
        drawArc(context: context,
                center: center,
                radius: baseRadius,
                width: ChartConfiguration.Arc.mainWidth,
                color: DesignColors.chartCaloriesBase,
                startAngle: ChartConfiguration.Arc.startAngle,
                endAngle: ChartConfiguration.Arc.endAngle)

        // 2) Прогресс калорий
        let progress = clampedProgress(numerator: calories, denominator: caloriesGoal)
        let sweep = (ChartConfiguration.Arc.endAngle - ChartConfiguration.Arc.startAngle) * progress
        drawArc(context: context,
                center: center,
                radius: baseRadius,
                width: ChartConfiguration.Arc.mainWidth,
                color: DesignColors.chartOrange,
                startAngle: ChartConfiguration.Arc.startAngle,
                endAngle: ChartConfiguration.Arc.startAngle + sweep)
    }
    
    private func drawMacroArcs(context: CGContext, center: CGPoint, radius: CGFloat) {
        // Порядок: [белки, жиры, углеводы]
        let macroValues: [(value: Int, goal: Int, baseColor: UIColor, progressColor: UIColor)] = [
            (proteins, proteinsGoal, DesignColors.proteinsBase, DesignColors.macroRed),
            (fats, fatsGoal, DesignColors.fatsBase, DesignColors.macroGreen),
            (carbs, carbsGoal, DesignColors.carbsBase, DesignColors.macroBlue)
        ]

        for (index, macro) in macroValues.enumerated() {
            let macroRadius = radius - ChartConfiguration.Macro.offsetFromMain[index]
            let r = macroRadius

            // 1) Базовая дуга (фон)
            drawArc(context: context,
                    center: center,
                    radius: r,
                    width: ChartConfiguration.Arc.macroWidth,
                    color: macro.baseColor,
                    startAngle: ChartConfiguration.Arc.startAngle,
                    endAngle: ChartConfiguration.Arc.endAngle)

            // 2) Прогрессовая дуга
            let progress = clampedProgress(numerator: macro.value, denominator: macro.goal)
            let sweep = (ChartConfiguration.Arc.endAngle - ChartConfiguration.Arc.startAngle) * progress
            drawArc(context: context,
                    center: center,
                    radius: r,
                    width: ChartConfiguration.Arc.macroWidth,
                    color: macro.progressColor,
                    startAngle: ChartConfiguration.Arc.startAngle,
                    endAngle: ChartConfiguration.Arc.startAngle + sweep)
        }
    }
    
    private func drawScaleLabels(center: CGPoint, radius: CGFloat) {
        let labelRadius = radius + ChartConfiguration.Label.radiusOffset
        let scaleValues = ChartConfiguration.Label.scaleValues(for: caloriesGoal)
        let labelCount = scaleValues.count
        
        for (index, value) in scaleValues.enumerated() {
            let fraction = CGFloat(index) / CGFloat(labelCount - 1)
            let angle = ChartConfiguration.Arc.startAngle +
                       (ChartConfiguration.Arc.endAngle - ChartConfiguration.Arc.startAngle) * fraction
            
            let labelCenter = CGPoint(
                x: center.x + labelRadius * cos(angle),
                y: center.y + labelRadius * sin(angle)
            )
            
            let attributedString = NSAttributedString.create(
                text: "\(value)",
                font: DesignFonts.chartLabel,
                color: DesignColors.primaryText
            )
            attributedString.drawCentered(at: labelCenter)
        }
    }
    
    private func drawCenterCaloriesBox(center: CGPoint) {
        let rectPath = UIBezierPath(roundedRect: CGRect(
            x: center.x - ChartConfiguration.CenterRect.width / 2,
            y: center.y - ChartConfiguration.CenterRect.height / 2,
            width: ChartConfiguration.CenterRect.width,
            height: ChartConfiguration.CenterRect.height
        ), cornerRadius: ChartConfiguration.CenterRect.cornerRadius)
        
        DesignColors.centerRect.setFill()
        rectPath.lineWidth = ChartConfiguration.CenterRect.borderWidth
        rectPath.stroke()
        rectPath.fill()
        
        let calString = NSAttributedString.create(
            text: "\(calories)",
            font: DesignFonts.chartLargeValue,
            color: DesignColors.primaryText
        )
        let calSize = calString.size()
        calString.draw(at: CGPoint(
            x: center.x - calSize.width / 2,
            y: center.y + ChartConfiguration.CenterRect.caloriesYOffset
        ))
        
        let kcalString = NSAttributedString.create(
            text: "ККал",
            font: DesignFonts.chartSubtitle,
            color: DesignColors.primaryText
        )
        let kcalSize = kcalString.size()
        kcalString.draw(at: CGPoint(
            x: center.x - kcalSize.width / 2,
            y: center.y + ChartConfiguration.CenterRect.unitYOffset
        ))
    }
    
    private func drawMacroLabels(rect: CGRect, center: CGPoint) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        let macroData: [(value: Int, name: String, color: UIColor)] = [
            (carbs, "углеводы", DesignColors.macroBlue),
            (proteins, "белки", DesignColors.macroRed),
            (fats, "жиры", DesignColors.macroGreen)
        ]
        
        let y = rect.maxY - ChartConfiguration.MacroLabels.bottomOffset
        let columnWidth = ChartConfiguration.MacroLabels.totalWidth / CGFloat(macroData.count)
        let startX = center.x - ChartConfiguration.MacroLabels.totalWidth / 2

        let padding = ChartConfiguration.MacroLabels.horizontalPadding
        let availableWidth = max(0, columnWidth - 2 * padding)
        
        for (index, macro) in macroData.enumerated() {
            let columnX = startX + CGFloat(index) * columnWidth
            let contentX = columnX + padding
            
            let valueString = NSAttributedString.create(
                text: "\(macro.value) г",
                font: DesignFonts.macroLabel,
                color: macro.color
            )
            let valueSize = valueString.size()
            valueString.draw(at: CGPoint(
                x: contentX + (availableWidth - valueSize.width) / 2,
                y: y + ChartConfiguration.MacroLabels.valueYOffset
            ))
            
            let nameString = NSAttributedString.create(
                text: macro.name,
                font: DesignFonts.macroLabel,
                color: DesignColors.primaryText
            )
            let nameSize = nameString.size()
            nameString.draw(at: CGPoint(
                x: contentX + (availableWidth - nameSize.width) / 2,
                y: y + ChartConfiguration.MacroLabels.nameYOffset
            ))
            
            if index < macroData.count - 1 {
                drawSeparator(
                    context: ctx,
                    x: columnX + columnWidth + ChartConfiguration.MacroLabels.separatorInset,
                    y1: y + ChartConfiguration.MacroLabels.separatorTopOffset,
                    y2: y + ChartConfiguration.MacroLabels.height
                )
            }
        }
    }
    
    private func drawSeparator(context: CGContext, x: CGFloat, y1: CGFloat, y2: CGFloat) {
        context.setStrokeColor(DesignColors.divider.cgColor)
        context.setLineWidth(1)
        context.move(to: CGPoint(x: x, y: y1))
        context.addLine(to: CGPoint(x: x, y: y2))
        context.strokePath()
    }
}

