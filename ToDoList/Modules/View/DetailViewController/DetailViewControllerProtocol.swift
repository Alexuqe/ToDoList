//
//  DetailViewControllerProtocol.swift
//  ToDoList
//
//  Created by Sasha on 21.02.25.
//

protocol DetailViewControllerProtocol: AnyObject {
    func showTaskDetail(task: TasksList)
    func updateTask()
}
