import Foundation
@testable import ToDoList

final class MockNetworkManager {
    static let shared = MockNetworkManager()

    // MARK: - Spy Properties
    var fetchCalled = false

    // MARK: - Mock Results
    var fetchResult: Result<APITasks, NetworkError> = .success(APITasks(todos: [], total: 0, skip: 0, limit: 0))

    func fetch<T: Decodable>(_ type: T.Type, url: URL, completion: @escaping(Result<T, NetworkError>) -> Void) {
        fetchCalled = true

        if let result = fetchResult as? Result<T, NetworkError> {
            completion(result)
        }
    }
}
