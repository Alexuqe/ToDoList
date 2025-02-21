//
//  DetailViewPresenterProtocol.swift
//  ToDoList
//
//  Created by Sasha on 21.02.25.
//

protocol DetailViewPresenterProtocol: AnyObject {
    var view: DetailViewControllerProtocol? { get set }
    var interactor: DetailViewInteractorProtocol? { get set }
    var router: DetailViewRouterProtocol? { get set }

    func loadTaskDetails(_ task: TasksList)
    func updateTask(task: TasksList, title: String, details: String)
}
