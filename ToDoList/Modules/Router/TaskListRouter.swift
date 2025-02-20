//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Sasha on 20.02.25.
//

import UIKit

protocol TaskListRouterProtocol: AnyObject {
    static func createdModule() -> UITableViewController
    var viewController: UITableViewController? { get set }
}


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
    

}
