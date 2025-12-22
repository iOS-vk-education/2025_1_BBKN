import UIKit

public extension NSAttributedString {
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
