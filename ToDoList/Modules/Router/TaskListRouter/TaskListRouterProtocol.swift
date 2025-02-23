//
//  TaskListRouterProtocol.swift
//  ToDoList
//
//  Created by Sasha on 21.02.25.
//

import UIKit

protocol TaskListRouterProtocol: AnyObject {
    var viewController: UITableViewController? { get set }

    static func createdModule() -> UITableViewController
    func navigateToTaskDetail(with task: TasksList, completion: @escaping () -> Void)
    func navigateToAddTask(completion: @escaping () -> Void)
    func showDetailPreview(with task: TasksList) -> UIViewController
}
