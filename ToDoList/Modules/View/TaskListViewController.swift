

import UIKit

protocol TaskListViewProtocol: AnyObject {
    func showTasks(tasks: [TasksList])
}

final class TaskListViewController: UITableViewController, TaskListViewProtocol {

    //MARK: Private UI Components
    private let searchController: UISearchController = {
        let view = UISearchController(searchResultsController: nil)
        view.searchBar.placeholder = "Поиск"
        view.searchBar.searchBarStyle = .default
        view.obscuresBackgroundDuringPresentation = false
        return view
    }()

    //MARK: Properties
    var presenter: TaskListPresenterProtocol?
    var tasks: [TasksList] = []

    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()
    }

        //MARK: - Methods
    func showTasks(tasks: [TasksList]) {
        self.tasks = tasks
        tableView.reloadData()
        updateToolBarItems()
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
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView,
                            contextMenuConfigurationForRowAt indexPath: IndexPath,
                            point: CGPoint) -> UIContextMenuConfiguration? {

        let task = tasks[indexPath.row]

        let configuration = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: { [weak self] in
                return self?.presenter?.router?.showDetailPreview(with: task)
        }) { _ in

            let editAction = UIAction(
                title: "Редактировать",
                image: UIImage(systemName: "square.and.pencil")) { [unowned self] _ in
                presenter?.showTasksDetail(for: task)
            }

            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive) { [unowned self] _ in

                let deleteTask = tasks.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                updateToolBarItems()
                presenter?.deleteTask(task: deleteTask)
            }

            return UIMenu(children: [editAction, deleteAction])
        }

        return configuration
    }

}

    //MARK: - Setup UI
private extension TaskListViewController {

        //MARK: - Setup UI
    func setupUI() {
        setupNavigationController()
        setupNavigationToolBar()
        setupSearchController()

        presenter?.viewDidLoad()

        tableView.backgroundColor = .darkBackground
        tableView.separatorColor = UIColor.gray
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(TaskListsCell.self, forCellReuseIdentifier: TaskListsCell.identifer)
    }

    //MARK: - Navigation Controller
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

    func setupSearchController() {
        navigationItem.searchController = searchController
        let micImage = UIImage(
            systemName: "mic.fill")?
            .withTintColor(.systemGray2,
            renderingMode: .alwaysOriginal)

        let searchBar = searchController.searchBar
        searchBar.tintColor = .white
        searchBar.showsBookmarkButton = true
        searchBar.setImage(micImage, for: .bookmark, state: .normal)

        let searchTextField = searchBar.searchTextField
        searchTextField.backgroundColor = .selectedView
        searchTextField.textColor = .white
        searchTextField.leftView?.tintColor = .systemGray2


        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray2]
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: attributes
        )

        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }

    func setupNavigationToolBar() {
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.barStyle = .black


        let taskCountLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        taskCountLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        taskCountLabel.textAlignment = .center
        taskCountLabel.text = "\(tasks.count) Задач"
        taskCountLabel.textColor = .white

        let addTaskButton = UIButton(type: .system)
        let configSymbol = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)

        addTaskButton.tintColor = UIColor.goldCheckmark
        addTaskButton.setImage(UIImage(systemName: "square.and.pencil",
                                       withConfiguration: configSymbol),
                                       for: .normal)

        addTaskButton.addTarget(self, action: #selector(tapAddButton), for: .touchUpInside)
        addTaskButton.accessibilityIdentifier = "addTaskButton"

        let countLabel = UIBarButtonItem(customView: taskCountLabel)
        let addButton = UIBarButtonItem(customView: addTaskButton)
        let flexibleSpace = UIBarButtonItem(systemItem: .flexibleSpace)

        toolbarItems = [flexibleSpace, countLabel, flexibleSpace, addButton]
    }

    //MARK: Actions
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

//MARK: UISearchController ResultsUpdating
extension TaskListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.isEmpty {
            presenter?.viewDidLoad()
            return
        }
        presenter?.searchTask(title: searchText)
    }

}
