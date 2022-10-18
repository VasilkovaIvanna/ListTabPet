import Foundation

struct User: Codable {
    let name: String
}

protocol UserViewProtocol : AnyObject {
    func update()
}
