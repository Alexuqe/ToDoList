    //
    //  ViewController.swift
    //  ToDoList
    //
    //  Created by Sasha on 20.02.25.
    //

import UIKit


final class TaskListViewController: UITableViewController, TaskListViewProtocol {

    func showTasks(tasks: [TasksList]) {
        self.tasks = tasks
        tableView.reloadData()
    }

    var presenter: TaskListPresenterProtocol?
    private var tasks: [TasksList] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

        //MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .darkBackground
        tableView.backgroundColor = .darkBackground
        setupNavigationController()

        presenter?.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskListsCell.identifer, for: indexPath)
                as? TaskListsCell else { return UITableViewCell()}

        let task = tasks[indexPath.row]
        cell.presenter = presenter
        cell.setupCell(with: task)
        return cell
    }

//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        120
//    }

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
        navigationItem.title = "Tasks"

        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .darkBackground

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
