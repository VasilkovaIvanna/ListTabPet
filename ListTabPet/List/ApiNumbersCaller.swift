import Foundation
import Combine
import SwiftUI

struct User: Codable {
    let name: String
}

protocol UserViewProtocol : AnyObject {
    func update()
}

class ApiNumbersCaller {
    static let shared = ApiNumbersCaller()
    private let url = URL(string: "https://jsonplaceholder.typicode.com/users")
    
    
    // Using Future
    func fetchNumbers() -> Future<[Int], Error> {
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                promise(.success([1,2,3,4,5]))
            }
        }
    }
    
    // Using Just Publisher
    func fetchUsers() -> AnyPublisher<[User], Never> {
        
        guard let url = url else {
            return Just([])
                .eraseToAnyPublisher()
        }
        
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: [User].self, decoder: JSONDecoder())
            .catch({ _ in
                Just([])
            })
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    
}
