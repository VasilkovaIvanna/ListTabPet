import Foundation
import Combine

class ListViewModelCombine : ObservableObject {
    
    private struct ListModel {
        var elementsList : [ElementModel] = []
        var isActiveTimer = false
        
    }
        
    @Published private var model = ListModel() {
        didSet {
            delegate?.update()
        }
    }
    
    public var elementsTuples: [(color: ElementColor, number: Int)] {
        self.model.elementsList.map({ return ($0.color, $0.number ) } )}
    public var isActiveTimer: Bool { return self.model.isActiveTimer }
    
    weak var delegate : ListViewProtocol?
    
    private var timer = Timer()
    
    private var index = 0
    
    var observer : AnyCancellable?
    
    var recievedNumbers = [Int]()
    
    init() {
        observer = ApiNumbersCaller.shared.fetchNumbers()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        print("Error")
                    }
                }, receiveValue: { [weak self] values in
                    print(values)
                    self?.recievedNumbers = values
                })
    }
    
    private func appendRandomElement() {
        if index < recievedNumbers.count{
            model.elementsList.append(ElementModel(
                color: ElementColor.allCases.randomElement() ?? .orange,
                number: recievedNumbers[index]))
            index += 1
        }
    }
    
    
    @objc func onTimerCounting() {
        if model.elementsList.count < 5 {
            appendRandomElement()
        }
    }
    
    func manageTimer() {
        if model.isActiveTimer {
            timer.invalidate()
            model.isActiveTimer = false
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerCounting), userInfo: nil, repeats: true)
            model.isActiveTimer = true
        }
    }
}
