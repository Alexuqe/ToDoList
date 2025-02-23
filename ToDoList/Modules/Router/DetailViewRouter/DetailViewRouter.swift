//
//  DetailViewRouter.swift
//  ToDoList
//
//  Created by Sasha on 21.02.25.
//

import UIKit

final class DetailViewRouter: DetailViewRouterProtocol {
    
    var viewController: UIViewController?
    private var completion: (() -> Void)?

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

    func dismiss() {
        completion?()
        viewController?.navigationController?.popViewController(animated: true)
    }

}
