//
//  DetailViewRouter.swift
//  ToDoList
//
//  Created by Sasha on 21.02.25.
//

import UIKit
import UIKit

protocol DetailViewRouterProtocol: AnyObject {

    var viewController: DetailViewController? { get set }

    func createDetailModule(with task: TasksList, completion: @escaping () -> Void) -> UIViewController
    func createDetailModule(completion: @escaping () -> Void) -> UIViewController
    func dismiss()
}

final class DetailViewRouter: DetailViewRouterProtocol {

    //MARK: Properties
    var viewController: DetailViewController?

    //MARK: - Private Properties
    private var completion: (() -> Void)?

    //MARK: - Create Module Methods
    func createDetailModule(with task: TasksList, completion: @escaping () -> Void) -> UIViewController {
        let view = DetailViewController()
        let presenter: DetailViewPresenterProtocol & DetailViewInteractorOutputProtocol = DetailViewPresenter()
        let interactor: DetailViewInteractorProtocol = DetailViewInteractor()
        let router: DetailViewRouterProtocol = DetailViewRouter()

        self.completion = completion

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter


        presenter.configure(with: task)
        viewController = view

        return view
    }

    func createDetailModule(completion: @escaping () -> Void) -> UIViewController {
        let view = DetailViewController()
        let presenter: DetailViewPresenterProtocol & DetailViewInteractorOutputProtocol = DetailViewPresenter()
        let interactor: DetailViewInteractorProtocol = DetailViewInteractor()
        let router: DetailViewRouterProtocol = DetailViewRouter()

        self.completion = completion

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        viewController = view

        return view
    }

    //MARK: - Navigation Methods
    func dismiss() {
        completion?()
        viewController?.navigationController?.popViewController(animated: true)
    }

}
