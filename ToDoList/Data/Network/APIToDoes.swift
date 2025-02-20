//
//  APIToDoes.swift
//  ToDoList
//
//  Created by Sasha on 20.02.25.
//

struct APITask: Decodable {
    let id: Int?
    let todo: String
    let completed: Bool
    let userId: Int?
}

struct APITasks: Decodable {
    let todos: [APITask]
    let total: Int?
    let skip: Int?
    let limit: Int?
}
