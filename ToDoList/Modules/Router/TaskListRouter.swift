//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Sasha on 20.02.25.
//

import UIKit

protocol TaskListRouterProtocol: AnyObject {
    static func createdModule() -> UITableViewController
}
