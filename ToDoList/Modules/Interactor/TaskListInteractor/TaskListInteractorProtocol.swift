//
//  TaskListInteractorProtocol.swift
//  ToDoList
//
//  Created by Sasha on 21.02.25.
//


protocol TaskListInteractorProtocol: AnyObject {
    var presenter: (TaskListPresenterProtocol & TaskListInteractorOutputProtocol)? { get set }

    func fetchTask()
    func addTask(title: String, details: String)
    func updateTask(task: TasksList, title: String, details: String)
    func deleteTask(task: TasksList)
    func searchTask(title: String)
    func isCompleted(task: TasksList)
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func didFetchTasks(tasks: [TasksList])
}
