import Foundation

enum ElementColor: CaseIterable {
    case blue
    case orange
}

struct ElementModel {
    var color : ElementColor
    var number : Int
}

protocol ListViewProtocol : AnyObject {
    func update()
}

class ListViewModel : ObservableObject {
    
    private struct ListModel {
        var elementsList : [ElementModel] = []
        var isActiveTimer = false
        
    }
    
    private var decisionProvider: DecisionProvider
    
    @Published private var model = ListModel() {
        didSet {
            delegate?.update()
        }
    }
    
    public var elementsTuples: [(color: ElementColor, number: Int)] {
        self.model.elementsList.map({ return ($0.color, $0.number * ($0.color == .orange ? 3 : 1)) } )}
    public var isActiveTimer: Bool { return self.model.isActiveTimer }
    
    weak var delegate : ListViewProtocol?
    
    private var timer = Timer()
    
    init(decisionProvider: DecisionProvider) {
        self.decisionProvider = decisionProvider
    }
    
    private func appendRandomElement() {
        let randomElement = ElementModel(color: ElementColor.allCases.randomElement() ?? .orange, number: Int.random(in: 0..<10))
        model.elementsList.append(randomElement)
    }
    
    private func incrementRandomElement(index: Int) {
        model.elementsList[index].number += 1
    }
    
    private func resetRandomElementCounter(index: Int) {
        model.elementsList[index].number = 0
    }
    
    private func deleteRandomElement(index: Int) {
        model.elementsList.remove(at: index)
    }
    
    func addValueOfAnElementBefore(index: Int) {
        if case 0 ..< model.elementsList.count = index {
            let previousIndex = index - 1
            let previousIndexModulo = previousIndex >= 0 ? previousIndex : previousIndex + model.elementsList.count
            let previousElement = model.elementsList[previousIndexModulo]
            model.elementsList[index].number += previousElement.number
        }
    }
    
    func performRandomElementChanges(index: Int) {
        switch self.decisionProvider.provideDecision {  // randomDecision -> computed property enum
        case .increment:
            incrementRandomElement(index: index)
        case .resetCounter:
            resetRandomElementCounter(index: index)
        case .delete:
            deleteRandomElement(index: index)
        case .addBeforeModulo:
            addValueOfAnElementBefore(index: index)
        case .none:
            break
        }
    }
    
    @objc func onTimerCounting() {
        model.elementsList.count < 5 ? appendRandomElement() : performRandomElementChanges(index: Int.random(in: 0..<model.elementsList.count))
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
