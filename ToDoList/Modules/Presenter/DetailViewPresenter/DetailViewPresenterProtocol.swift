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

    func viewDidLoad()
    func saveButtonTapped(title: String, details: String)
    func textFieldDidChange(title: String?, details: String?)
    func configure(with task: TasksList)
    func dismiss()
}
