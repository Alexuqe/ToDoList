//
//  TaskListRouterProtocol.swift
//  ToDoList
//
//  Created by Sasha on 21.02.25.
//

import UIKit

protocol TaskListRouterProtocol: AnyObject {
    static func createdModule() -> UITableViewController
    func navigateToTaskDetail(with task: TasksList)
    func navigateToAddTask()
    var viewController: UITableViewController? { get set }
}
