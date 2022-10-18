import Foundation
import Combine

class UserViewModelCombine: ObservableObject {
    
    var observer : AnyCancellable?
    
    var users = [User]() {
        didSet {
            delegate?.update()
        }
    }
    
    weak var delegate : UserViewProtocol?
    
    init(){
        observer = ApiNumbersCaller.shared.fetchUsers()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] users in
                self?.users = users
                self?.delegate?.update()
            })
    }
    
}
