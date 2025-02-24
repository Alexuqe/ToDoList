    //
    //  LaunchScreenPresenter.swift
    //  ToDoList
    //
    //  Created by Sasha on 24.02.25.
    //

protocol LaunchScreenPresenterProtocols: AnyObject {
    func startAnimating()
    func showTaskListView()
}


final class LaunchScreenPresenter: LaunchScreenPresenterProtocols {

    weak var view: LaunchScreenProtocols?
    var router: LaunchScreenRouterProtocols?

    func startAnimating() {
        view?.animateLaunchScreen()
    }

    func showTaskListView() {
        router?.navigateToTaskListView()
    }
}
