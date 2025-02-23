

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case noData
    case decodingError
}

final class NetworkManager {

    static let shared = NetworkManager()

    private init() {}

    func fetch<T: Decodable>(_ type: T.Type, url: URL, completion: @escaping(Result<T, NetworkError>) -> Void) {

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No Data")
                return
            }

            do {
                let dataDecoder = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(dataDecoder))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
