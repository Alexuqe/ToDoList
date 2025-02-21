//
//  DetailViewRouter.swift
//  ToDoList
//
//  Created by Sasha on 21.02.25.
//

import UIKit

final class DetailViewRouter: DetailViewRouterProtocol {

    func createDetailModule(with task: TasksList) -> UIViewController {
        let view = DetailViewController()
        let presenter: DetailViewPresenterProtocol & DetailViewInteractorOutputProtocol = DetailViewPresenter()
        let interactor: DetailViewInteractorProtocol = DetailViewInteractor()
        let router: DetailViewRouterProtocol = DetailViewRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    

}
