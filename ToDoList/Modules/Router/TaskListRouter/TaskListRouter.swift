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

    func navigateToTaskDetail(with task: TasksList, completion: @escaping () -> Void) {
        let detailViewRouter = DetailViewRouter()
        let detailViewController = detailViewRouter.createDetailModule(with: task, completion: completion)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }

    func navigateToAddTask(completion: @escaping () -> Void) {
            let detailViewRouter = DetailViewRouter()
            let detailViewController = detailViewRouter.createDetailModule(
                completion: completion
            )
            viewController?.navigationController?.pushViewController(detailViewController, animated: true)
        }

    func showDetailPreview(with task: TasksList) -> UIViewController {
        let detailView = TaskContextPreview()
        detailView.configure(with: task)
        return detailView
    }



}
