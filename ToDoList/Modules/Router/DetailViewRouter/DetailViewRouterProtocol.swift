


import UIKit

protocol DetailViewRouterProtocol: AnyObject {
    func createDetailModule(with task: TasksList) -> UIViewController
}
