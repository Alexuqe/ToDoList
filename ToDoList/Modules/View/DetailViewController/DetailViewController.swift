//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Sasha on 21.02.25.
//

import UIKit

final class DetailViewController: UIViewController {

    var presenter: DetailViewPresenterProtocol?
    var tasks: TasksList?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = tasks?.title
        view.backgroundColor = .white
    }

}

extension DetailViewController: DetailViewControllerProtocol {
    func showTaskDetail(task: TasksList) {
        self.tasks = task
    }
    
    func updateTask() {
        dismiss(animated: true)
    }
    

}
