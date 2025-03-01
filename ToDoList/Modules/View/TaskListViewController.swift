

import UIKit

protocol TaskListViewProtocol: AnyObject {
    func showTasks(tasks: [TasksList])
    func showError(_ message: String)
    func showSuccess()
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

    private let segmentedController: UISegmentedControl = {
        let items = ["Все задачи", "Выполненные", "Невыполненные"]
        let view = UISegmentedControl(items: items)
        view.selectedSegmentIndex = 0
        view.selectedSegmentTintColor = .systemGray
        view.backgroundColor = .selectedView

        view.setTitleTextAttributes(
            [.foregroundColor: UIColor.white,
             .font: UIFont.systemFont(ofSize: 14)],
            for: .selected )

        view.setTitleTextAttributes(
            [.foregroundColor: UIColor.white,
             .font: UIFont.systemFont(ofSize: 12)],
            for: .normal)

        return view
    }()

        //MARK: Properties
    var presenter: TaskListPresenterProtocol?

        //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()
    }

        //MARK: - Methods
    func showTasks(tasks: [TasksList]) {
        tableView.reloadData()
        updateToolBarItems()
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func showSuccess() {
        let alert = UIAlertController(title: "Выполнено", message: "Задача выполнена", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

    //MARK: - UITableViewDataSource
extension TaskListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.tasks.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskListsCell.identifer,
            for: indexPath) as? TaskListsCell else { return UITableViewCell() }

        let task = presenter?.tasks[indexPath.row] ?? TasksList()
        cell.setupCell(with: task)
        cell.completionToggleHandler = { [weak self] in
            self?.presenter?.isCompleted(task: task)
        }

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
        let task = presenter?.tasks[indexPath.row] ?? TasksList()
        presenter?.showTasksDetail(for: task)
    }

    override func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {

        let task = presenter?.tasks[indexPath.row] ?? TasksList()

        let configuration = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: { [weak self] in
                var perview: UIViewController?
                self?.presenter?.showDetailPreview(with: task) { controller in
                    perview = controller
                }
                return perview
            }) { _ in

                let editAction = UIAction(
                    title: "Редактировать",
                    image: UIImage(systemName: "square.and.pencil")) { [weak self] _ in
                        guard let self else { return }
                        presenter?.showTasksDetail(for: task)
                    }

                let deleteAction = UIAction(
                    title: "Удалить",
                    image: UIImage(systemName: "trash"),
                    attributes: .destructive) { [weak self] _ in
                        guard let self else { return }
                        let task = presenter?.tasks[indexPath.row]
                        presenter?.deleteTask(task: task ?? TasksList())
                        updateToolBarItems()
                        tableView.reloadData()
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
        setupSegmented()
        setupTableView()
    }

    func setupTableView() {
        tableView.backgroundColor = .darkBackground
        tableView.separatorColor = UIColor.gray
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(TaskListsCell.self, forCellReuseIdentifier: TaskListsCell.identifer)
    }

    func setupSegmented() {
        segmentedController.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
    }

    func updateToolBarItems() {
        guard let items = toolbarItems else { return }

        items.forEach { item in
            if let label = item.customView as? UILabel {
                label.text = "\(presenter?.tasks.count ?? 0) Задач"
            }
        }
    }

        //MARK: - Actions
    @objc private func tapAddButton() {
        presenter?.showAddTaskScreen()
    }

    @objc private func segmentValueChanged(sender: UISegmentedControl) {
        presenter?.didSelectSegment(at: sender.selectedSegmentIndex)
    }
}

    //MARK: - Navigation Controller
extension TaskListViewController {

    func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "Задачи"
        navigationItem.titleView = segmentedController

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
        taskCountLabel.text = "\(presenter?.tasks.count ?? 0) Задач"
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
