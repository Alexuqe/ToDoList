//
//  DetailViewInteractorProtocol.swift
//  ToDoList
//
//  Created by Sasha on 21.02.25.
//

protocol DetailViewInteractorProtocol: AnyObject {

    var presenter: DetailViewInteractorOutputProtocol? { get set }

    func fetchTaskDetails(task: TasksList)
    func saveUpdateTask(task: TasksList, title: String, details: String)
}

protocol DetailViewInteractorOutputProtocol: AnyObject {

    func didFetchTaskDetail(task: TasksList)
    func didSaveTaskDetail()
}
