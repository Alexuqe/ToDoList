//
//  LaunchScreenRouter.swift
//  ToDoList
//
//  Created by Sasha on 24.02.25.
//

import UIKit

protocol LaunchScreenRouterProtocols: AnyObject {
    static func createModule() -> UIViewController
    func navigateToTaskListView()
}


final class LaunchScreenRouter: LaunchScreenRouterProtocols {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let view = LaunchScreenViewController()
        let presenter = LaunchScreenPresenter()
        let router = LaunchScreenRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        router.viewController = view

        return view
    }
    
    func navigateToTaskListView() {
        guard let window = viewController?.view.window else { return }

        let taskListView = TaskListRouter.createdModule()

        UIView.transition(with: window, duration: 1.5, options: .transitionCrossDissolve) {
            window.rootViewController = UINavigationController(rootViewController: taskListView)
        }
        window.makeKeyAndVisible()
    }
}
