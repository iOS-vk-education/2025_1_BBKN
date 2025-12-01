import UIKit

final class DailyRationCardView: UIView {
    
    // MARK: - UI Components
    
    private let cardContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 66/255, green: 78/255, blue: 43/255, alpha: 1) // card background
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = false
        // apply design shadow (closest centralized)
        DesignSystem.Shadow.buttonShadow.apply(to: view.layer)
        return view
    }()
    
    private let foodImageView: UIImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
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
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.clear.cgColor,
            UIColor(red: 66/255, green: 78/255, blue: 43/255, alpha: 0.2).cgColor,
            UIColor(red: 66/255, green: 78/255, blue: 43/255, alpha: 1.0).cgColor
        ]
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
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = DesignColors.background
        label.numberOfLines = 2
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = DesignColors.background
        return view
    }()
    
    private let macrosStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
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
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = DesignColors.background
        label.backgroundColor = UIColor(red: 145/255, green: 137/255, blue: 76/255, alpha: 1)
        label.textAlignment = .center
        label.layer.cornerRadius = 16
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
            cardContainerView.heightAnchor.constraint(equalToConstant: DesignSystem.Sizes.cardHeight),
            
            // Food Image
            foodImageView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
            foodImageView.topAnchor.constraint(equalTo: cardContainerView.topAnchor),
            foodImageView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor),
            foodImageView.widthAnchor.constraint(equalTo: cardContainerView.widthAnchor, multiplier: 0.38),
            
            // Content Container
            contentContainerView.leadingAnchor.constraint(equalTo: foodImageView.trailingAnchor),
            contentContainerView.topAnchor.constraint(equalTo: cardContainerView.topAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
            
            // Delete Button
            deleteButton.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -10),
            deleteButton.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 10),
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Edit Button
            editButton.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -10),
            editButton.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 8),
            editButton.widthAnchor.constraint(equalToConstant: 40),
            editButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Title
            titleLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: deleteButton.leadingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 16),
            
            // Underline
            underlineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            underlineView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            underlineView.widthAnchor.constraint(equalTo: titleLabel.widthAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 1),
            
            // Macros Stack
            macrosStackView.topAnchor.constraint(equalTo: underlineView.bottomAnchor, constant: 8),
            macrosStackView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 12),
            macrosStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentContainerView.trailingAnchor, constant: -10),
            
            // Weight Label
            weightLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -8),
            weightLabel.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -8),
            weightLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func setupGradient() {
        gradientOverlayView.layer.addSublayer(gradientLayer)
    }
    
    private func setupBoundsObserver() {
        if let customImageView = foodImageView as? CustomImageView {
            customImageView.onBoundsChange = { [weak self] _ in
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
        button.backgroundColor = UIColor(red: 90/255, green: 99/255, blue: 67/255, alpha: 1)
        button.tintColor = DesignColors.background
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: systemName)?.withConfiguration(symbolConfig)
        button.setImage(image, for: .normal)
        
        return button
    }
    
    private func createMacroLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = DesignColors.background
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
        
        let horizontalPadding: CGFloat = 12
        let minWidth: CGFloat = 60
        
        let calculatedWidth = weightLabel.frame.width + (horizontalPadding * 2)
        let finalWidth = max(calculatedWidth, minWidth)
        
        weightLabel.widthAnchor.constraint(equalToConstant: finalWidth).isActive = true
    }
    
    // MARK: - Actions
    
    @objc private func handleDeleteTap() {
        onDelete?()
    }
}
