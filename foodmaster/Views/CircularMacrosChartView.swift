import UIKit

final class CircularMacrosChartView: UIView {
    var calories: Int = 2500 {
        didSet { setNeedsDisplay() }
    }
    var caloriesGoal: Int = 2500 {
        didSet { setNeedsDisplay() }
    }
    var fats: Int = 150 {
        didSet { setNeedsDisplay() }
    }
    var carbs: Int = 150 {
        didSet { setNeedsDisplay() }
    }
    var proteins: Int = 150 {
        didSet { setNeedsDisplay() }
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
    
    private func drawMainArc(context: CGContext, center: CGPoint, radius: CGFloat) {
        context.setLineWidth(ChartConfiguration.Arc.mainWidth)
        context.setStrokeColor(DesignSystem.Colors.chartOrange.cgColor)
        context.addArc(
            center: center,
            radius: radius - ChartConfiguration.Arc.mainWidth / 2,
            startAngle: ChartConfiguration.Arc.startAngle,
            endAngle: ChartConfiguration.Arc.endAngle,
            clockwise: false
        )
        context.strokePath()
    }
    
    private func drawMacroArcs(context: CGContext, center: CGPoint, radius: CGFloat) {
        for (index, color) in ChartConfiguration.Macro.colors.enumerated() {
            let macroRadius = radius - ChartConfiguration.Macro.offsetFromMain[index]
            context.setLineWidth(ChartConfiguration.Arc.macroWidth)
            context.setStrokeColor(color.cgColor)
            context.addArc(
                center: center,
                radius: macroRadius,
                startAngle: ChartConfiguration.Arc.startAngle,
                endAngle: ChartConfiguration.Arc.endAngle,
                clockwise: false
            )
            context.strokePath()
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
                font: DesignSystem.Fonts.chartLabel,
                color: DesignSystem.Colors.primaryText
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
        
        DesignSystem.Colors.centerRect.setFill()
        rectPath.lineWidth = ChartConfiguration.CenterRect.borderWidth
        rectPath.stroke()
        rectPath.fill()
        
        // Калории
        let calString = NSAttributedString.create(
            text: "\(calories)",
            font: DesignSystem.Fonts.chartLargeValue,
            color: DesignSystem.Colors.primaryText
        )
        let calSize = calString.size()
        calString.draw(at: CGPoint(
            x: center.x - calSize.width / 2,
            y: center.y + ChartConfiguration.CenterRect.caloriesYOffset
        ))
        
        // "ККал"
        let kcalString = NSAttributedString.create(
            text: "ККал",
            font: DesignSystem.Fonts.chartSubtitle,
            color: DesignSystem.Colors.primaryText
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
            (carbs, "углеводы", DesignSystem.Colors.macroBlue),
            (proteins, "белки", DesignSystem.Colors.macroRed),
            (fats, "жиры", DesignSystem.Colors.macroGreen)
        ]
        
        let y = rect.maxY - ChartConfiguration.MacroLabels.bottomOffset
        let columnWidth = ChartConfiguration.MacroLabels.totalWidth / CGFloat(macroData.count)
        let startX = center.x - ChartConfiguration.MacroLabels.totalWidth / 2
        
        for (index, macro) in macroData.enumerated() {
            let columnX = startX + CGFloat(index) * columnWidth
            
            // Значение макроса
            let valueString = NSAttributedString.create(
                text: "\(macro.value) г",
                font: DesignSystem.Fonts.macroLabel,
                color: macro.color
            )
            let valueSize = valueString.size()
            valueString.draw(at: CGPoint(
                x: columnX + (columnWidth - valueSize.width) / 2,
                y: y + ChartConfiguration.MacroLabels.valueYOffset
            ))
            
            // Название макроса
            let nameString = NSAttributedString.create(
                text: macro.name,
                font: DesignSystem.Fonts.macroLabel,
                color: DesignSystem.Colors.primaryText
            )
            let nameSize = nameString.size()
            nameString.draw(at: CGPoint(
                x: columnX + (columnWidth - nameSize.width) / 2,
                y: y + ChartConfiguration.MacroLabels.nameYOffset
            ))
            
            // Разделитель
            if index < macroData.count - 1 {
                drawSeparator(
                    context: ctx,
                    x: columnX + columnWidth,
                    y1: y + ChartConfiguration.MacroLabels.separatorTopOffset,
                    y2: y + ChartConfiguration.MacroLabels.height
                )
            }
        }
    }
    
    private func drawSeparator(context: CGContext, x: CGFloat, y1: CGFloat, y2: CGFloat) {
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(1)
        context.move(to: CGPoint(x: x, y: y1))
        context.addLine(to: CGPoint(x: x, y: y2))
        context.strokePath()
    }
}

// MARK: - NSAttributedString Helpers
extension NSAttributedString {
    static func create(text: String, font: UIFont, color: UIColor) -> NSAttributedString {
        NSAttributedString(string: text, attributes: [
            .font: font,
            .foregroundColor: color
        ])
    }
    
    func drawCentered(in rect: CGRect) {
        let size = self.size()
        draw(at: CGPoint(
            x: rect.midX - size.width / 2,
            y: rect.midY - size.height / 2
        ))
    }
    
    func drawCentered(at point: CGPoint) {
        let size = self.size()
        draw(at: CGPoint(
            x: point.x - size.width / 2,
            y: point.y - size.height / 2
        ))
    }
}

