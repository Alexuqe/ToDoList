    //
    //  ContextPreview.swift
    //  ToDoList
    //
    //  Created by Sasha on 22.02.25.
    //

import UIKit


protocol TaskContestMenuProtocol: AnyObject {
    func configure(with task: TasksList)
}

final class TaskContextPreview: UIViewController, TaskContestMenuProtocol {

        //MARK: Properties
    var tasks: TasksList?
    private let labelStyle = LabelStyles.shared

        //MARK: Private UI
    private lazy var titleLabel: UILabel = labelStyle.titleLabelstyle()
    private lazy var detailLabel: UILabel = labelStyle.detailLabelStyle()
    private lazy var dateLabel: UILabel = labelStyle.dateLabelStyle()
    private let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

        //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

        //MARK: Setup UI
    func configure(with task: TasksList) {
        titleLabel.text = task.title
        detailLabel.text = task.details
        dateLabel.text = task.date?.formatted(date: .numeric, time: .shortened) ?? "20/10/10"
    }

    private func setupUI() {
        let width = UIScreen.main.bounds.width
        preferredContentSize = CGSize(width: width, height: 130)
        view.backgroundColor = .toolBar
        addArranges(titleLabel, detailLabel, dateLabel)
        view.addSubview(labelsStackView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            labelsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            labelsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            labelsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            detailLabel.heightAnchor.constraint(equalToConstant: 40),
            dateLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

        //MARK: UI Helpers
    private func addArranges(_ subviews: UIView...) {
        subviews.forEach { subview in
            labelsStackView.addArrangedSubview(subview)
        }
    }

}
