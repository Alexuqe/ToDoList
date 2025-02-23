//
//  TaskListPresenterProtocol.swift
//  ToDoList
//
//  Created by Sasha on 21.02.25.
//

protocol TaskListPresenterProtocol: AnyObject {
    var view: TaskListViewProtocol? { get set }
    var interactor: TaskListInteractorProtocol? { get set }
    var router: TaskListRouterProtocol? { get set }

    func viewDidLoad()
    func addTask(title: String, details: String)
    func updateTask(task: TasksList, title: String, details: String)
    func deleteTask(task: TasksList)
    func searchTask(title: String)
    func isCompleted(task: TasksList)
    func showTasksDetail(for task: TasksList)
    func showDetailPreview(task: TasksList)
    func showAddTaskScreen()
}
