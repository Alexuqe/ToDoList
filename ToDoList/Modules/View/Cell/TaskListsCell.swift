    //
    //  TaskListsCell.swift
    //  ToDoList
    //
    //  Created by Sasha on 20.02.25.
    //

import UIKit

enum CheckoutButtonState {
    case notCompleted
    case completed

    var configuration: UIButton.Configuration {
        var config = UIButton.Configuration.plain()

        switch self {
            case .notCompleted:
                config.image = nil
                config.baseForegroundColor = .systemGray4
            case .completed:
                let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .light)
                config.imagePadding = 5
                config.image = UIImage(systemName: "checkmark", withConfiguration: symbolConfig)
                config.baseForegroundColor = .goldCheckmark
        }
        return config
    }

    var borderColor: CGColor {
        switch self {
            case .notCompleted:
                UIColor.systemGray4.cgColor
            case .completed:
                UIColor.goldCheckmark.cgColor
        }
    }

    func textUnderline(title: String?, detail: String?) -> (title: NSAttributedString, detail: NSAttributedString) {
        let text = title ?? "Check Parametrs"
        let subtext = detail ?? "Check Parametrs"

        switch self {
            case .notCompleted:
                return (NSAttributedString(string: text),
                        NSAttributedString(string: subtext ,
                                           attributes: [.foregroundColor: UIColor.white]))
            case .completed:
                return (NSAttributedString(string: text,
                                           attributes:[.strikethroughStyle: NSUnderlineStyle.single.rawValue,              .foregroundColor: UIColor.systemGray2]),
                        NSAttributedString(string: subtext,
                                           attributes: [.foregroundColor: UIColor.systemGray2]))
            }
        }
}

final class TaskListsCell: UITableViewCell {

    static let identifer = "TaskListCell"

        //MARK: Private UIOutlets
    private lazy var checkoutButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "checkmark")
        configuration.baseForegroundColor = .goldCheckmark

        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var titleTaskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = .systemGray4
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

        //MARK: - Properties
    var taskList: TasksList?
    var presenter: TaskListPresenterProtocol?

    private var currentState: CheckoutButtonState = .notCompleted

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupUI()
        }

    //MARK: Content Setup
    func setupCell(with task: TasksList) {
        self.taskList = task
        let state: CheckoutButtonState = task.isCompleted ? .completed : .notCompleted

        let attributedTexts = state.textUnderline(title: task.title, detail: task.details)
        titleTaskLabel.attributedText = attributedTexts.title
        detailsLabel.attributedText = attributedTexts.detail
        dateLabel.text = task.date?.formatted(date: .numeric, time: .shortened) ?? "20/10/10"

        updateStateButton(state: state)
    }

//MARK: - Action
    @objc private func checkoutButtonTapped() {
        guard let taskList = taskList else { return }
        presenter?.isCompleted(task: taskList)
    }

    private func updateStateButton(state: CheckoutButtonState) {
        currentState = state
        checkoutButton.configuration = state.configuration
        checkoutButton.layer.borderColor = state.borderColor
    }


}

//MARK: - Setup UI
private extension TaskListsCell {

    func setupUI() {
        backgroundColor = .darkBackground
        addArranges(titleTaskLabel, detailsLabel, dateLabel)
        addSubviews(checkoutButton, labelsStackView)

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            checkoutButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            checkoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            checkoutButton.widthAnchor.constraint(equalToConstant: 30),
            checkoutButton.heightAnchor.constraint(equalTo: checkoutButton.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: checkoutButton.topAnchor, constant: 3.5),
            labelsStackView.leadingAnchor.constraint(equalTo: checkoutButton.trailingAnchor, constant: 15),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            labelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            contentView.addSubview(subview)
        }
    }

    func addArranges(_ subviews: UIView...) {
        subviews.forEach { subview in
            labelsStackView.addArrangedSubview(subview)
        }
    }

}


#Preview {
    TaskListsCell()
}
