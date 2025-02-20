//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Sasha on 20.02.25.
//

import Foundation

protocol TaskListPresenterProtocol: AnyObject {
    var view: TaskListViewProtocol? { get set }
    var interactor: TaskListInteractorProtocol? { get set }
    var router: TaskListRouterProtocol? { get set }

    func viewDidLoad()
    func addTask(title: String, details: String)
    func updateTask(task: TasksList, title: String, details: String)
    func deleteTask(task: TasksList)
    func searchTask(title: String)
}

class TaskListPresenter: TaskListPresenterProtocol {

    var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    
    func viewDidLoad() {
        interactor?.fetchTask()
    }
    
    func addTask(title: String, details: String) {
        interactor?.addTask(title: title, details: details)
    }
    
    func updateTask(task: TasksList, title: String, details: String) {
        interactor?.updateTask(task: task, title: title, details: details)
    }
    
    func deleteTask(task: TasksList) {
        interactor?.deleteTask(task: task)
    }
    
    func searchTask(title: String) {
        interactor?.searchTask(title: title)
    }

}

extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func didFetchTasks(tasks: [TasksList]) {
        print("didFetchTasks called with tasks: \(tasks)")
        view?.showTasks(tasks: tasks)
    }
}
