import UIKit

final class DailyRationViewController: UIViewController {
    
    private let viewModel = DailyRationViewModel()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Суточный рацион"
        label.font = DesignSystem.Fonts.title
        label.textColor = DesignSystem.Colors.primaryText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var diagramChart: CircularMacrosChartView = {
        let chart = CircularMacrosChartView()
        chart.backgroundColor = .clear
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()

    private lazy var dividerLine: UIView = {
        let line = UIView()
        line.backgroundColor = DesignSystem.Colors.divider
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    private lazy var consumedLabel: UILabel = {
        let label = UILabel()
        label.text = "Потреблено сегодня:"
        label.font = DesignSystem.Fonts.sectionTitle
        label.textAlignment = .center
        label.textColor = DesignSystem.Colors.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = DesignSystem.Fonts.buttonTitle
        button.tintColor = .white
        button.backgroundColor = DesignSystem.Colors.primaryButton
        button.layer.cornerRadius = DesignSystem.Sizes.buttonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        DesignSystem.Shadow.buttonShadow.apply(to: button.layer)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var productsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DailyRationCardTableViewCell.self,
                          forCellReuseIdentifier: DailyRationCardTableViewCell.reuseIdentifier)
        tableView.rowHeight = 160
        tableView.estimatedRowHeight = 160
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystem.Colors.background
        setupUI()
        bindViewModel()
        updateChartValues()
    }
    
    private func setupUI() {
        [titleLabel, diagramChart, dividerLine, consumedLabel, addButton, productsTableView].forEach {
            view.addSubview($0)
        }
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: DesignSystem.Sizes.titleHeight),

            diagramChart.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            diagramChart.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            diagramChart.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            diagramChart.heightAnchor.constraint(equalToConstant: DesignSystem.Sizes.chartHeight),

            dividerLine.topAnchor.constraint(equalTo: diagramChart.bottomAnchor, constant: DesignSystem.Spacing.dividerOffset),
            dividerLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dividerLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dividerLine.heightAnchor.constraint(equalToConstant: 1),

            consumedLabel.topAnchor.constraint(equalTo: dividerLine.bottomAnchor, constant: DesignSystem.Spacing.medium),
            consumedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            consumedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            consumedLabel.heightAnchor.constraint(equalToConstant: DesignSystem.Sizes.consumedLabelHeight),

            addButton.topAnchor.constraint(equalTo: consumedLabel.bottomAnchor, constant: DesignSystem.Spacing.medium),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DesignSystem.Spacing.large),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DesignSystem.Spacing.large),
            addButton.heightAnchor.constraint(equalToConstant: DesignSystem.Sizes.buttonHeight),

            productsTableView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: DesignSystem.Spacing.extraLarge),
            productsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.productsTableView.reloadData()
            self?.updateChartValues()
        }
    }
    
    @objc private func addButtonTapped() {
        viewModel.addNewProduct()
        let lastIndex = viewModel.productsCount() - 1
        if lastIndex >= 0 {
            let indexPath = IndexPath(row: lastIndex, section: 0)
            productsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func updateChartValues() {
        diagramChart.calories = viewModel.caloriesTotal
        diagramChart.fats = viewModel.fatsTotal
        diagramChart.carbs = viewModel.carbsTotal
        diagramChart.proteins = viewModel.proteinsTotal
        diagramChart.caloriesGoal = viewModel.caloriesGoal
    }
}

extension DailyRationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.productsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DailyRationCardTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? DailyRationCardTableViewCell else {
            return UITableViewCell()
        }
        
        let product = viewModel.product(at: indexPath.row)
        cell.configure(with: product)
        cell.onDelete = { [weak self] in
            self?.viewModel.removeProduct(at: indexPath.row)
        }
        
        return cell
    }
}
