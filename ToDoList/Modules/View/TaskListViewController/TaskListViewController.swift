    //
    //  ViewController.swift
    //  ToDoList
    //
    //  Created by Sasha on 20.02.25.
    //

import UIKit


final class TaskListViewController: UITableViewController, TaskListViewProtocol {

    var presenter: TaskListPresenterProtocol?
    private var tasks: [TasksList] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    //MARK: - Methods
    func showTasks(tasks: [TasksList]) {
        self.tasks = tasks
        tableView.reloadData()
        updateToolBarItems()
    }

        //MARK: - Setup UI
    private func setupUI() {
        setupNavigationController()
        setupNAvigationToolBar()

        presenter?.viewDidLoad()

        tableView.backgroundColor = .darkBackground
        tableView.separatorColor = UIColor.gray
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(TaskListsCell.self, forCellReuseIdentifier: TaskListsCell.identifer)
    }
}

    //MARK: - UITableViewDataSource
extension TaskListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskListsCell.identifer,
            for: indexPath) as? TaskListsCell else { return UITableViewCell() }

        let task = tasks[indexPath.row]
        cell.presenter = presenter
        cell.setupCell(with: task)

        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.selectedView
        cell.selectedBackgroundView = backgroundView

        return cell
    }
}

    //MARK: - UITableViewDelegate
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = tasks[indexPath.row]
        presenter?.showTasksDetail(for: task)
    }
    
}

    //MARK: - Setup Navigation Controller
private extension TaskListViewController {

    func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "Задачи"

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .darkBackground

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    func setupNAvigationToolBar() {
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.barStyle = .black

        let taskCountLabel = UILabel()
        taskCountLabel.text = "\(tasks.count) Задач"
        taskCountLabel.textColor = .white
        taskCountLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        taskCountLabel.textAlignment = .center
        taskCountLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true

        let addTaskButton = UIButton(type: .system)
        let configSymbol = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        addTaskButton.tintColor = UIColor.goldCheckmark
        addTaskButton.setImage(
            UIImage(systemName: "square.and.pencil", withConfiguration: configSymbol),
            for: .normal)

        addTaskButton.addTarget(self, action: #selector(tapAddButton), for: .touchUpInside)

        let countLabel = UIBarButtonItem(customView: taskCountLabel)
        let addButton = UIBarButtonItem(customView: addTaskButton)
        let flexibleSpace = UIBarButtonItem(systemItem: .flexibleSpace)

        toolbarItems = [flexibleSpace, countLabel, flexibleSpace, addButton]
    }

    @objc private func tapAddButton() {
        presenter?.showAddTaskScreen()
    }

    func updateToolBarItems() {
        guard let items = toolbarItems else { return }

        items.forEach { item in
            if let label = item.customView as? UILabel {
                label.text = "\(tasks.count) Задач"
            }
        }
    }
}
