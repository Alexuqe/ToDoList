

import UIKit

protocol TaskContestMenuProtocol: AnyObject {
    func configure(with task: TasksList)
}

final class TaskContextPreview: UIViewController, TaskContestMenuProtocol {

        //MARK: Properties
    var tasks: TasksList?
    private let labelStyle = LabelStyles.shared

        //MARK: - Private UI
    private lazy var titleLabel: UILabel = labelStyle.titleLabelstyle()
    private lazy var detailLabel: UILabel = labelStyle.detailLabelStyle()
    private lazy var dateLabel: UILabel = labelStyle.dateLabelStyle()
    private let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .leading
        stack.distribution = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

        //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calculatePreferredContentSize()
    }

        //MARK: - Content Setup
    func configure(with task: TasksList) {
        titleLabel.text = task.title
        detailLabel.text = task.details
        dateLabel.text = task.date?.formatted(date: .numeric, time: .shortened) ?? "20/10/10"
    }

        //MARK: - Setup UI
    private func setupUI() {
        detailLabel.numberOfLines = 0
        view.backgroundColor = .toolBar

        addArranges(titleLabel, detailLabel, dateLabel)
        view.addSubview(labelsStackView)

        setupConstraints()
        addPriorityContentSize()
    }

    private func addPriorityContentSize() {
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.setContentHuggingPriority(.required, for: .vertical)

        detailLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        detailLabel.setContentHuggingPriority(.defaultLow, for: .vertical)

        dateLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        dateLabel.setContentHuggingPriority(.required, for: .vertical)
    }

    private func calculatePreferredContentSize() {
        let size = labelsStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: size.height + 24)
    }

        //MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            labelsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            labelsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            labelsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ])
    }


        //MARK: UI Helpers
    private func addArranges(_ subviews: UIView...) {
        subviews.forEach { subview in
            labelsStackView.addArrangedSubview(subview)
        }
    }

}
