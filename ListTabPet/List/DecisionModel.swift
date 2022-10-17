import Foundation

enum Decision {
    case increment
    case resetCounter
    case delete
    case addBeforeModulo
}

protocol DecisionProvider {
    var provideDecision: Decision? { get }
}

class RandomDecisionProvider: DecisionProvider {
    var provideDecision: Decision? {
        switch Int.random(in: 0..<100) {
        case 0..<50:
            return .increment
        case 50..<80:
            return .resetCounter
        case 80..<90:
            return .delete
        case 90..<100:
            return .addBeforeModulo
        default:
            return nil
        }
    }
}
