//
//  ViewController.swift
//  ToDoList
//
//  Created by Sasha on 20.02.25.
//

import UIKit

protocol TaskListViewProtocol: AnyObject {
    func showTasks(tasks: [TasksList])
}

final class TaskListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


}

