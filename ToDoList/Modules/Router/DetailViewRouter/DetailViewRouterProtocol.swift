


import UIKit

protocol DetailViewRouterProtocol: AnyObject {

    var viewController: UIViewController? { get set }

    func createDetailModule(with task: TasksList, completion: @escaping () -> Void) -> UIViewController
    func createDetailModule(completion: @escaping () -> Void) -> UIViewController

    func dismiss()
}
