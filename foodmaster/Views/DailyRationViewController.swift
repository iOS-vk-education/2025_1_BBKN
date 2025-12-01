import UIKit

final class DailyRationViewController: UIViewController {
    
    private let viewModel = DailyRationViewModel()
    
    // MARK: - Scroll container
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        sv.showsVerticalScrollIndicator = true
        return sv
    }()
    
    private let contentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: - Header UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Суточный рацион"
        label.font = DesignFonts.title
        label.textColor = DesignColors.primaryText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var diagramChart: CircularMacrosChartView = {
        let chart = CircularMacrosChartView()
        chart.backgroundColor = .clear
        chart.translatesAutoresizingMaskIntoConstraints = false
        // Реакция на тап по диаграмме
        chart.onTap = { [weak self] in
            self?.presentGoalsAlert()
        }
        return chart
    }()

    private lazy var dividerLine: UIView = {
        let line = UIView()
        line.backgroundColor = DesignColors.divider
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    private lazy var consumedLabel: UILabel = {
        let label = UILabel()
        label.text = "Потреблено сегодня:"
        label.font = DesignFonts.sectionTitle
        label.textAlignment = .center
        label.textColor = DesignColors.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = DesignFonts.buttonTitle
        button.tintColor = .white
        button.backgroundColor = DesignColors.primaryButton
        button.layer.cornerRadius = DesignSystem.Sizes.buttonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        DesignSystem.Shadow.buttonShadow.apply(to: button.layer)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // Контейнер для карточек
    private let cardsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = DesignSystem.Spacing.small
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignColors.background
        setupUI()
        bindViewModel()
        updateChartValues()
        reloadCards()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        // Добавляем секции в стек
        let headerContainer = UIView()
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(titleLabel)
        headerContainer.addSubview(diagramChart)
        headerContainer.addSubview(dividerLine)
        headerContainer.addSubview(consumedLabel)
        headerContainer.addSubview(addButton)
        
        let cardsContainer = UIView()
        cardsContainer.translatesAutoresizingMaskIntoConstraints = false
        cardsContainer.addSubview(cardsStackView)
        
        contentStackView.addArrangedSubview(headerContainer)
        contentStackView.addArrangedSubview(cardsContainer)
        
        setupConstraints(headerContainer: headerContainer, cardsContainer: cardsContainer)
    }

    private func setupConstraints(headerContainer: UIView, cardsContainer: UIView) {
        NSLayoutConstraint.activate([
            // ScrollView to edges
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content stack fills scrollView width
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            // Header container width equals scroll width
            headerContainer.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            
            // Cards container width
            cardsContainer.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            cardsContainer.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
        ])
        
        // Header inner constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: DesignSystem.Sizes.titleHeight),

            diagramChart.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            diagramChart.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            diagramChart.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),
            diagramChart.heightAnchor.constraint(equalToConstant: DesignSystem.Sizes.chartHeight),

            dividerLine.topAnchor.constraint(equalTo: diagramChart.bottomAnchor, constant: DesignSystem.Spacing.dividerOffset),
            dividerLine.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            dividerLine.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),
            dividerLine.heightAnchor.constraint(equalToConstant: 1),

            consumedLabel.topAnchor.constraint(equalTo: dividerLine.bottomAnchor, constant: DesignSystem.Spacing.medium),
            consumedLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            consumedLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),
            consumedLabel.heightAnchor.constraint(equalToConstant: DesignSystem.Sizes.consumedLabelHeight),

            addButton.topAnchor.constraint(equalTo: consumedLabel.bottomAnchor, constant: DesignSystem.Spacing.medium),
            addButton.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: DesignSystem.Spacing.large),
            addButton.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -DesignSystem.Spacing.large),
            addButton.heightAnchor.constraint(equalToConstant: DesignSystem.Sizes.buttonHeight),
            
            addButton.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -DesignSystem.Spacing.extraLarge)
        ])
        
        // Cards stack constraints + внешние отступы секции карточек
        NSLayoutConstraint.activate([
            cardsStackView.topAnchor.constraint(equalTo: cardsContainer.topAnchor, constant: DesignSystem.Spacing.small),
            cardsStackView.leadingAnchor.constraint(equalTo: cardsContainer.leadingAnchor),
            cardsStackView.trailingAnchor.constraint(equalTo: cardsContainer.trailingAnchor),
            cardsStackView.bottomAnchor.constraint(equalTo: cardsContainer.bottomAnchor, constant: -DesignSystem.Spacing.small)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.reloadCards()
            self?.updateChartValues()
        }
    }
    
    @objc private func addButtonTapped() {
        viewModel.addNewProduct()
        // Прокрутка к низу после добавления
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let bottomOffset = CGPoint(x: 0, y: max(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollView.adjustedContentInset.bottom))
            self.scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    private func updateChartValues() {
        diagramChart.calories = viewModel.caloriesTotal
        diagramChart.fats = viewModel.fatsTotal
        diagramChart.carbs = viewModel.carbsTotal
        diagramChart.proteins = viewModel.proteinsTotal
        diagramChart.caloriesGoal = viewModel.caloriesGoal
        // при желании можно также подтягивать цели макро из модели
        // diagramChart.proteinsGoal = ...
        // diagramChart.fatsGoal = ...
        // diagramChart.carbsGoal = ...
    }
    
    // MARK: - Cards rendering
    
    private func reloadCards() {
        // Очистить текущие карточки
        cardsStackView.arrangedSubviews.forEach { view in
            cardsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        // Добавить карточки из модели
        for index in 0..<viewModel.productsCount() {
            let product = viewModel.product(at: index)
            
            // Обертка-контейнер для внешних отступов как в таблице
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            
            let card = DailyRationCardView()
            card.translatesAutoresizingMaskIntoConstraints = false
            card.configure(with: product)
            card.onDelete = { [weak self] in
                self?.viewModel.removeProduct(at: index)
            }
            container.addSubview(card)
            
            NSLayoutConstraint.activate([
                card.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: DesignSystem.Spacing.small),
                card.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -DesignSystem.Spacing.small),
                card.topAnchor.constraint(equalTo: container.topAnchor, constant: DesignSystem.Spacing.small),
                card.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -DesignSystem.Spacing.small),
                card.heightAnchor.constraint(equalToConstant: DesignSystem.Sizes.cardHeight)
            ])
            
            cardsStackView.addArrangedSubview(container)
        }
    }

    // MARK: - Goals alert

    private func presentGoalsAlert() {
        let alert = UIAlertController(title: "Цели на день", message: "Введите суточные цели КБЖУ", preferredStyle: .alert)

        // helper для левого лейбла
        func makeLeftLabel(_ text: String) -> UIView {
            let label = UILabel()
            label.text = text
            label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            label.textColor = DesignColors.primaryText
            label.sizeToFit()
            let container = UIView(frame: CGRect(x: 0, y: 0, width: label.bounds.width + 6, height: 30))
            label.frame.origin = CGPoint(x: 0, y: (30 - label.bounds.height) / 2)
            container.addSubview(label)
            return container
        }

        // Ккал
        alert.addTextField { tf in
            tf.keyboardType = .numberPad
            tf.text = "\(self.diagramChart.caloriesGoal)"
            tf.leftView = makeLeftLabel("Ккал:")
            tf.leftViewMode = .always
        }
        // Белки
        alert.addTextField { tf in
            tf.keyboardType = .numberPad
            tf.text = "\(self.diagramChart.proteinsGoal)"
            tf.leftView = makeLeftLabel("Белки:")
            tf.leftViewMode = .always
        }
        // Жиры
        alert.addTextField { tf in
            tf.keyboardType = .numberPad
            tf.text = "\(self.diagramChart.fatsGoal)"
            tf.leftView = makeLeftLabel("Жиры:")
            tf.leftViewMode = .always
        }
        // Углеводы
        alert.addTextField { tf in
            tf.keyboardType = .numberPad
            tf.text = "\(self.diagramChart.carbsGoal)"
            tf.leftView = makeLeftLabel("Углеводы:")
            tf.leftViewMode = .always
        }

        let save = UIAlertAction(title: "Сохранить", style: .default) { [weak self, weak alert] _ in
            guard let self, let fields = alert?.textFields, fields.count == 4 else { return }

            func intOrCurrent(_ text: String?, current: Int) -> Int {
                guard let t = text?.trimmingCharacters(in: .whitespacesAndNewlines),
                      let v = Int(t), v > 0 else {
                    return current
                }
                return v
            }

            let newCaloriesGoal = intOrCurrent(fields[0].text, current: self.diagramChart.caloriesGoal)
            let newProteinsGoal = intOrCurrent(fields[1].text, current: self.diagramChart.proteinsGoal)
            let newFatsGoal = intOrCurrent(fields[2].text, current: self.diagramChart.fatsGoal)
            let newCarbsGoal = intOrCurrent(fields[3].text, current: self.diagramChart.carbsGoal)

            self.diagramChart.caloriesGoal = newCaloriesGoal
            self.diagramChart.proteinsGoal = newProteinsGoal
            self.diagramChart.fatsGoal = newFatsGoal
            self.diagramChart.carbsGoal = newCarbsGoal

            self.diagramChart.setNeedsDisplay()
        }

        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alert.addAction(cancel)
        alert.addAction(save)

        present(alert, animated: true)
    }
}
