    //
    //  ViewController.swift
    //  ToDoList
    //
    //  Created by Sasha on 20.02.25.
    //

import UIKit

protocol TaskListViewProtocol: AnyObject {
    func showTasks(tasks: [TasksList])
}

final class TaskListViewController: UITableViewController, TaskListViewProtocol {

    func showTasks(tasks: [TasksList]) {
        print("showTasks called with tasks: \(tasks)")
        self.tasks = tasks
        tableView.reloadData()
    }


    var presenter: TaskListPresenterProtocol?
    private var tasks: [TasksList] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()

        setupUI()
    }

        //MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        setupNavigationController()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }


}

    //MARK: - UITableViewDataSource
extension TaskListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = tasks[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = task.title
        content.secondaryText = task.details
        cell.contentConfiguration = content
        return cell
    }

}

    //MARK: - UITableViewDelegate
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

    //MARK: - Setup Navigation COntroller
private extension TaskListViewController {

    func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "Tasks"

        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .darkBackground

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
