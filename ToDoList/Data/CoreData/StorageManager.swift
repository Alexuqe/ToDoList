    //
    //  StorageManager.swift
    //  ToDoList
    //
    //  Created by Sasha on 20.02.25.
    //


import CoreData

final class StorageManager {

    //MARK: - Properties
    static let shared = StorageManager()

    private let viewContext: NSManagedObjectContext

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TasksList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in

            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    //MARK: - Initializer

    private init() {
        viewContext = persistentContainer.viewContext
    }

    //MARK: - Fetch Store Data

    func fetchTasksOnAPI(_ apiTasks: [APITask], completion: @escaping () -> Void) {
        viewContext.perform { [weak self] in
            guard let self else { return }

            for apiTask in apiTasks {
                let taskLists = TasksList(context: self.viewContext)
                taskLists.title = apiTask.todo
                taskLists.details = ""
                taskLists.date = Date()
                taskLists.isCompleted = apiTask.completed
            }
            self.saveContext()
            completion()
        }
    }

    func fetchTasks(completion: @escaping (Result<[TasksList], Error>) -> Void) {
        let fetchRequest = TasksList.fetchRequest()
        
        viewContext.perform {
            do {
                let toDos = try self.viewContext.fetch(fetchRequest)
                print("Fetched \(toDos.count) tasks from Core Data") // отладка
                DispatchQueue.main.async {
                    completion(.success(toDos))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    //MARK: - CRUD

    func create(_ title: String, with details: String, completion: @escaping (TasksList) -> Void) {
        let task = TasksList(context: viewContext)
        task.title = title
        task.details = details
        task.date = Date()
        task.isCompleted = false
        completion(task)
        saveContext()
    }

    func updateTask(task: TasksList, title: String, details: String, completion: @escaping (TasksList) -> Void) {
        task.title = title
        task.details = details
        completion(task)
        saveContext()
    }

    func delete(_ task: TasksList) {
        viewContext.delete(task)
        saveContext()
    }

    func searchTask(title: String, completion: @escaping ([TasksList]) -> Void) {
        let fetchRequest = TasksList.fetchRequest()
        fetchRequest
            .predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR details CONTAINS[cd] %@", title, title)

        do {
            let tasks = try viewContext.fetch(fetchRequest)
            completion(tasks)
        } catch {
            print(error)
            completion([])
        }

    }

    //MARK: - Save Context Core Data
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
