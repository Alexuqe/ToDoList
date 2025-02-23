    //
    //  
    //
    //
    //
    //


import CoreData


protocol StorageManagerProtocol {
    func fetchTasksOnAPI(_ apiTasks: [APITask], completion: @escaping () -> Void)
    func fetchTasks(completion: @escaping (Result<[TasksList], Error>) -> Void)
    func create(_ title: String, with details: String, completion: @escaping (Result<[TasksList], Error>) -> Void)
    func updateTask(task: TasksList, title: String, details: String, completion: @escaping (Result<[TasksList], Error>) -> Void)
    func delete(_ task: TasksList, completion: @escaping (Result<[TasksList], Error>) -> Void)
    func searchTask(title: String, completion: @escaping (Result<[TasksList], Error>) -> Void)
    func isCompletedTask(task: TasksList, completion: @escaping (Result<[TasksList], Error>) -> Void)
}



final class StorageManager: StorageManagerProtocol {

        //MARK: - Properties
    static let shared = StorageManager()

    private let viewContext: NSManagedObjectContext
    private let backgroundViewContext: NSManagedObjectContext

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
        backgroundViewContext = persistentContainer.newBackgroundContext()
    }

        //MARK: - Fetch Store Data

    func fetchTasksOnAPI(_ apiTasks: [APITask], completion: @escaping () -> Void) {
        backgroundViewContext.perform {
            for apiTask in apiTasks {
                let taskLists = TasksList(context: self.backgroundViewContext)
                taskLists.title = apiTask.todo
                taskLists.details = """
                                    Tests text from APITasks
                                    Tests text from APITasks 
                                    Tests text from APITasks 
                                    """
                taskLists.date = Date()
                taskLists.isCompleted = apiTask.completed
            }
            do {
                try self.backgroundViewContext.save()
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Failed to save tasks: \(error)")
            }
        }
    }

    func fetchTasks(completion: @escaping (Result<[TasksList], Error>) -> Void) {
        let fetchRequest = TasksList.fetchRequest()
        backgroundViewContext.perform {
            do {
                let tasks = try self.backgroundViewContext.fetch(fetchRequest)
                DispatchQueue.main.async {
                    completion(.success(tasks))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

        //MARK: - CRUD

    func create(_ title: String, with details: String, completion: @escaping (Result<[TasksList], Error>) -> Void) {
        backgroundViewContext.perform {

            let task = TasksList(context: self.backgroundViewContext)
            task.title = title
            task.details = details
            task.date = Date()
            task.isCompleted = false
            do {
                try self.backgroundViewContext.save()
                self.fetchTasks(completion: completion)
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func updateTask(task: TasksList, title: String, details: String, completion: @escaping (Result<[TasksList], Error>) -> Void) {
        backgroundViewContext.perform {
            task.title = title
            task.details = details

            do {
                try self.backgroundViewContext.save()
                self.fetchTasks(completion: completion)
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func delete(_ task: TasksList, completion: @escaping (Result<[TasksList], Error>) -> Void) {
        backgroundViewContext.perform {
            self.backgroundViewContext.delete(task)

            do {
                try self.backgroundViewContext.save()
                self.fetchTasks(completion: completion)
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func searchTask(title: String, completion: @escaping (Result<[TasksList], Error>) -> Void) {
        let fetchRequest = TasksList.fetchRequest()
        backgroundViewContext.perform {
            fetchRequest.predicate = NSPredicate(
                format: "title CONTAINS[cd] %@ OR details CONTAINS[cd] %@", title, title
            )

            do {
                let tasks = try self.backgroundViewContext.fetch(fetchRequest)
                DispatchQueue.main.async {
                    completion(.success(tasks))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

    }

    func isCompletedTask(task: TasksList, completion: @escaping (Result<[TasksList], Error>) -> Void) {
        backgroundViewContext.perform {
            task.isCompleted.toggle()

            do {
                try self.backgroundViewContext.save()
                self.fetchTasks(completion: completion)
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
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

        if backgroundViewContext.hasChanges {
            do {
                try backgroundViewContext.save()
            } catch {
                let nsError = error as NSError
                print("Failed to save background context: \(nsError), \(nsError.userInfo)")
            }
        }
    }

}
