import UIKit

final class DailyRationCardView: UIView {
    
    // MARK: - Constants
    
    private enum Layout {
        static let cardCornerRadius: CGFloat = 12
        static let imageWidthMultiplier: CGFloat = 0.38
        static let cardHeight: CGFloat = DesignSystem.Sizes.cardHeight
        
        static let buttonSize: CGFloat = 40
        static let buttonCornerRadius: CGFloat = 20
        static let buttonImageSize: CGFloat = 20
        static let buttonTopOffset: CGFloat = 10
        static let buttonTrailingOffset: CGFloat = -10
        static let buttonSpacing: CGFloat = 8
        
        static let weightLabelCornerRadius: CGFloat = 16
        static let weightLabelHeight: CGFloat = 32
        static let weightLabelMinWidth: CGFloat = 60
        static let weightLabelHorizontalPadding: CGFloat = 12
        static let weightLabelBottomOffset: CGFloat = -8
        static let weightLabelTrailingOffset: CGFloat = -8
        
        static let contentLeadingOffset: CGFloat = 12
        static let contentTopOffset: CGFloat = 16
        static let contentTrailingOffset: CGFloat = -10
        
        static let underlineHeight: CGFloat = 1
        static let underlineTopOffset: CGFloat = 2
        
        static let macrosStackTopOffset: CGFloat = 8
        static let macrosStackSpacing: CGFloat = 2
        
        static let titleTrailingOffset: CGFloat = -8
    }
    
    private enum Colors {
        static let cardBackground = UIColor(red: 66/255, green: 78/255, blue: 43/255, alpha: 1)
        static let buttonBackground = UIColor(red: 90/255, green: 99/255, blue: 67/255, alpha: 1)
        static let buttonTint = DesignSystem.Colors.background
        static let weightLabelBackground = UIColor(red: 145/255, green: 137/255, blue: 76/255, alpha: 1)
        static let weightLabelText = DesignSystem.Colors.background
        static let titleText = DesignSystem.Colors.background
        static let macroText = DesignSystem.Colors.background
        static let underline = DesignSystem.Colors.background
        
        static let gradientColors: [CGColor] = [
            UIColor.clear.cgColor,
            UIColor(red: 66/255, green: 78/255, blue: 43/255, alpha: 0.2).cgColor,
            UIColor(red: 66/255, green: 78/255, blue: 43/255, alpha: 1.0).cgColor
        ]
    }
    
    private enum Fonts {
        static let title = UIFont.systemFont(ofSize: 20, weight: .bold)
        static let macro = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let weight = UIFont.boldSystemFont(ofSize: 16)
    }
    
    private enum Shadow {
        static let color = UIColor.black
        static let opacity: Float = 0.18
        static let offset = CGSize(width: 0, height: 4)
        static let radius: CGFloat = 4
    }
    
    // MARK: - UI Components
    
    private let cardContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.cardBackground
        view.layer.cornerRadius = Layout.cardCornerRadius
        view.layer.masksToBounds = false
        view.layer.shadowColor = Shadow.color.cgColor
        view.layer.shadowOpacity = Shadow.opacity
        view.layer.shadowOffset = Shadow.offset
        view.layer.shadowRadius = Shadow.radius
        return view
    }()
    
    private let foodImageView: UIImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Layout.cardCornerRadius
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return imageView
    }()
    
    // Custom ImageView to track bounds changes
    private class CustomImageView: UIImageView {
        var onBoundsChange: ((CGRect) -> Void)?
        
        override var bounds: CGRect {
            didSet {
                if bounds != oldValue && bounds.size.width > 0 && bounds.size.height > 0 {
                    onBoundsChange?(bounds)
                }
            }
        }
    }
    
    private let gradientOverlayView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = Layout.cardCornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = Colors.gradientColors
        layer.locations = [0.0, 0.72, 1.0]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        return layer
    }()
    
    private let contentContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.title
        label.textColor = Colors.titleText
        label.numberOfLines = 2
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.underline
        return view
    }()
    
    private let macrosStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = Layout.macrosStackSpacing
        return stack
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = createCircleButton(systemName: "trash")
        button.addTarget(self, action: #selector(handleDeleteTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var editButton: UIButton = {
        let button = createCircleButton(systemName: "pencil")
        return button
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.weight
        label.textColor = Colors.weightLabelText
        label.backgroundColor = Colors.weightLabelBackground
        label.textAlignment = .center
        label.layer.cornerRadius = Layout.weightLabelCornerRadius
        label.clipsToBounds = true
        return label
    }()
    
    // MARK: - Properties
    
    var onDelete: (() -> Void)?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Schedule gradient update after layout is complete
        DispatchQueue.main.async { [weak self] in
            self?.updateGradientFrame()
        }
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .clear
        setupHierarchy()
        setupConstraints()
        setupGradient()
        setupBoundsObserver()
    }
    
    private func setupHierarchy() {
        addSubview(cardContainerView)
        cardContainerView.addSubview(foodImageView)
        foodImageView.addSubview(gradientOverlayView)
        
        cardContainerView.addSubview(contentContainerView)
        contentContainerView.addSubview(titleLabel)
        contentContainerView.addSubview(underlineView)
        contentContainerView.addSubview(macrosStackView)
        contentContainerView.addSubview(deleteButton)
        contentContainerView.addSubview(editButton)
        contentContainerView.addSubview(weightLabel)
    }
    
    private func setupConstraints() {
        [cardContainerView, foodImageView, contentContainerView,
         titleLabel, underlineView, macrosStackView, deleteButton, editButton, weightLabel]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        // Gradient overlay uses manual frame, not Auto Layout
        gradientOverlayView.translatesAutoresizingMaskIntoConstraints = true
        
        NSLayoutConstraint.activate([
            // Card Container
            cardContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DesignSystem.Spacing.medium),
            cardContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DesignSystem.Spacing.medium),
            cardContainerView.topAnchor.constraint(equalTo: topAnchor, constant: -DesignSystem.Spacing.small),
            cardContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cardContainerView.heightAnchor.constraint(equalToConstant: Layout.cardHeight),
            
            // Food Image
            foodImageView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
            foodImageView.topAnchor.constraint(equalTo: cardContainerView.topAnchor),
            foodImageView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor),
            foodImageView.widthAnchor.constraint(equalTo: cardContainerView.widthAnchor, multiplier: Layout.imageWidthMultiplier),
            
            // Content Container
            contentContainerView.leadingAnchor.constraint(equalTo: foodImageView.trailingAnchor),
            contentContainerView.topAnchor.constraint(equalTo: cardContainerView.topAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
            
            // Delete Button
            deleteButton.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: Layout.buttonTrailingOffset),
            deleteButton.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: Layout.buttonTopOffset),
            deleteButton.widthAnchor.constraint(equalToConstant: Layout.buttonSize),
            deleteButton.heightAnchor.constraint(equalToConstant: Layout.buttonSize),
            
            // Edit Button
            editButton.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: Layout.buttonTrailingOffset),
            editButton.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: Layout.buttonSpacing),
            editButton.widthAnchor.constraint(equalToConstant: Layout.buttonSize),
            editButton.heightAnchor.constraint(equalToConstant: Layout.buttonSize),
            
            // Title
            titleLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: Layout.contentLeadingOffset),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: deleteButton.leadingAnchor, constant: Layout.titleTrailingOffset),
            titleLabel.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: Layout.contentTopOffset),
            
            // Underline
            underlineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Layout.underlineTopOffset),
            underlineView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            underlineView.widthAnchor.constraint(equalTo: titleLabel.widthAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: Layout.underlineHeight),
            
            // Macros Stack
            macrosStackView.topAnchor.constraint(equalTo: underlineView.bottomAnchor, constant: Layout.macrosStackTopOffset),
            macrosStackView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: Layout.contentLeadingOffset),
            macrosStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentContainerView.trailingAnchor, constant: Layout.contentTrailingOffset),
            
            // Weight Label
            weightLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: Layout.weightLabelTrailingOffset),
            weightLabel.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: Layout.weightLabelBottomOffset),
            weightLabel.heightAnchor.constraint(equalToConstant: Layout.weightLabelHeight)
        ])
    }
    
    private func setupGradient() {
        gradientOverlayView.layer.addSublayer(gradientLayer)
    }
    
    private func setupBoundsObserver() {
        if let customImageView = foodImageView as? CustomImageView {
            customImageView.onBoundsChange = { [weak self] newBounds in
                self?.updateGradientFrame()
            }
        }
    }
    
    private func updateGradientFrame() {
        gradientOverlayView.frame = foodImageView.bounds
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = gradientOverlayView.bounds
        CATransaction.commit()
    }
    
    // MARK: - Factory Methods
    
    private func createCircleButton(systemName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = Colors.buttonBackground
        button.tintColor = Colors.buttonTint
        button.layer.cornerRadius = Layout.buttonCornerRadius
        button.clipsToBounds = true
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: Layout.buttonImageSize, weight: .bold)
        let image = UIImage(systemName: systemName)?.withConfiguration(symbolConfig)
        button.setImage(image, for: .normal)
        
        return button
    }
    
    private func createMacroLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = Fonts.macro
        label.textColor = Colors.macroText
        label.text = text
        return label
    }
    
    // MARK: - Configuration
    
    func configure(with product: Product) {
        titleLabel.text = product.name
        foodImageView.image = UIImage(named: "image_placeholder")
        
        configureMacros(
            calories: product.calories,
            fats: product.fats,
            carbs: product.carbs,
            protein: product.protein
        )
        
        configureWeight(product.weight)
    }
    
    private func configureMacros(calories: Int, fats: Int, carbs: Int, protein: Int) {
        macrosStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let macros = [
            "\(calories) ккал",
            "\(fats) г жира",
            "\(carbs) г углеводов",
            "\(protein) г белка"
        ]
        
        macros.forEach { text in
            macrosStackView.addArrangedSubview(createMacroLabel(text: text))
        }
    }
    
    private func configureWeight(_ weight: Int) {
        weightLabel.text = " \(weight) гр. "
        weightLabel.sizeToFit()
        
        let calculatedWidth = weightLabel.frame.width + (Layout.weightLabelHorizontalPadding * 2)
        let finalWidth = max(calculatedWidth, Layout.weightLabelMinWidth)
        
        weightLabel.widthAnchor.constraint(equalToConstant: finalWidth).isActive = true
    }
    
    // MARK: - Actions
    
    @objc private func handleDeleteTap() {
        onDelete?()
    }
}
