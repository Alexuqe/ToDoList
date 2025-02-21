//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Sasha on 20.02.25.
//

import UIKit


final class TaskListRouter: TaskListRouterProtocol {

    var viewController: UITableViewController?

    static func createdModule() -> UITableViewController {
        let view = TaskListViewController()
        let presenter: TaskListPresenterProtocol & TaskListInteractorOutputProtocol = TaskListPresenter()
        let interactor: TaskListInteractorProtocol = TaskListInteractor()
        let router: TaskListRouterProtocol = TaskListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        router.viewController = view

        return view
    }

    func navigateToTaskDetail(with task: TasksList) {
        let detailViewController = DetailViewController()
        detailViewController.tasks = task
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }



}
