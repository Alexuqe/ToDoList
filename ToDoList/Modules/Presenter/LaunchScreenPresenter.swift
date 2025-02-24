

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
