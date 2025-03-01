


import CoreData


protocol StorageManagerProtocol {
    func fetchTasksOnAPI(_ apiTasks: [APITask], _ savedNameTask: [String], completion: @escaping () -> Void)
    func fetchTasks(completion: @escaping (Result<[TasksList], Error>) -> Void)
    func create(_ title: String, with details: String, completion: @escaping (Result<TasksList, Error>) -> Void)
    func updateTask(task: TasksList, title: String, details: String, completion: @escaping (Result<Void, Error>) -> Void)
    func delete(_ task: TasksList, completion: @escaping (Result<Void, Error>) -> Void)
    func isCompletedTask(task: TasksList, completion: @escaping (Result<Void, Error>) -> Void)
    func searchTask(title: String, completion: @escaping (Result<[TasksList], Error>) -> Void)
    func segmentedTask(index: Int, completion: @escaping (Result<[TasksList], Error>) -> Void)
}



final class StorageManager: StorageManagerProtocol {

        //MARK: - Properties
    static let shared = StorageManager()

    private let viewContext: NSManagedObjectContext
    private let backgroundViewContext: NSManagedObjectContext

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TasksList")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

        //MARK: - Initializer
    private init() {
        viewContext = persistentContainer.viewContext
        backgroundViewContext = persistentContainer.newBackgroundContext()
        backgroundViewContext.automaticallyMergesChangesFromParent = true
    }

        //MARK: - Fetch Store Data
    func fetchTasksOnAPI(_ apiTasks: [APITask], _ savedNameTask: [String], completion: @escaping () -> Void) {
        backgroundViewContext.perform {
            for (index, apiTask) in apiTasks.enumerated() {
                let taskLists = TasksList(context: self.backgroundViewContext)
                taskLists.title = savedNameTask[index]
                taskLists.details = apiTask.todo
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
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
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

        //MARK: - Operations
    func create(_ title: String, with details: String, completion: @escaping (Result<TasksList, Error>) -> Void) {
        backgroundViewContext.perform {

            let task = TasksList(context: self.backgroundViewContext)
            task.title = title
            task.details = details
            task.date = Date()
            task.isCompleted = false
            do {
                try self.backgroundViewContext.save()
                DispatchQueue.main.async {
                    completion(.success(task))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func updateTask(task: TasksList, title: String, details: String, completion: @escaping (Result<Void, Error>) -> Void) {
        backgroundViewContext.perform {
            task.title = title
            task.details = details

            do {
                try self.backgroundViewContext.save()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func delete(_ task: TasksList, completion: @escaping (Result<Void, Error>) -> Void) {
        backgroundViewContext.perform {
            self.backgroundViewContext.delete(task)

            do {
                try self.backgroundViewContext.save()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
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

    func isCompletedTask(task: TasksList, completion: @escaping (Result<Void, Error>) -> Void) {
        backgroundViewContext.perform {
            task.isCompleted.toggle()

            do {
                try self.backgroundViewContext.save()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func segmentedTask(index: Int, completion: @escaping (Result<[TasksList], Error>) -> Void) {
        let fetchRequest = TasksList.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        backgroundViewContext.perform {
            switch index {
                case 0:
                    fetchRequest.predicate = nil
                case 1:
                    fetchRequest.predicate = NSPredicate(format: "isCompleted == true")
                case 2:
                    fetchRequest.predicate = NSPredicate(format: "isCompleted == false")
                default:
                    fetchRequest.predicate = nil
            }

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
