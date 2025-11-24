
import UIKit

class DailyRationCardTableViewCell: UITableViewCell {
    static let reuseIdentifier = "DailyRationCardTableViewCell"
    private let rationCardView = DailyRationCardView()
    
    var onDelete: (() -> Void)? {
        didSet {
            rationCardView.onDelete = onDelete
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(rationCardView)
        rationCardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rationCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DesignSystem.Spacing.small),
            rationCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DesignSystem.Spacing.small),
            rationCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DesignSystem.Spacing.small),
            rationCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DesignSystem.Spacing.small),
            rationCardView.heightAnchor.constraint(equalToConstant: DesignSystem.Sizes.cardHeight)
        ])
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
    }

    func configure(with product: Product) {
        rationCardView.configure(with: product)
    }
}
