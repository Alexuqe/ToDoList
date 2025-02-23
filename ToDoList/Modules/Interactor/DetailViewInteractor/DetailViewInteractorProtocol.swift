    //
    //  DetailViewInteractorProtocol.swift
    //  ToDoList
    //
    //  Created by Sasha on 21.02.25.
    //

protocol DetailViewInteractorProtocol: AnyObject {

    var presenter: DetailViewInteractorOutputProtocol? { get set }

    func fetchTasksDetails(task: TasksList)
    func saveUpdateTask(title: String, details: String)
    func createNewTask(title: String, details: String)

}

protocol DetailViewInteractorOutputProtocol: AnyObject {
    func didFetchTaskDetails(task: TasksList)
    func didSaveTaskDetails()
}
