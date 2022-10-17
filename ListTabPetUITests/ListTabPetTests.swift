import XCTest


class ListTabUnitTests: XCTestCase {
    
    class TestDecisionProvider: DecisionProvider {
        var testDecision: Decision? = nil
        
        var provideDecision: Decision? {
            testDecision
        }
    }
    
    var testDecisionProvider = TestDecisionProvider()
    var sut: ListViewModel!
    
    override func setUpWithError() throws {
        sut = ListViewModel(decisionProvider: testDecisionProvider)
    }
    
    override func tearDownWithError() throws {}
    
    func testAppendRandomElement() throws {
        let countBefore = sut.elementsTuples.count
        sut.onTimerCounting() // Create one element
        let countAfter = sut.elementsTuples.count
        
        XCTAssertEqual(countBefore + 1, countAfter)
    }
    
    func testIncrementRandomElement() throws {
        sut.onTimerCounting() // Create one element
        guard let value = sut.elementsTuples.first?.number else {
            XCTFail()
            return
        }
        testDecisionProvider.testDecision = .increment
        sut.performRandomElementChanges(index: 0)
        guard let newTuple = sut.elementsTuples.first else {
            XCTFail()
            return
        }
        switch newTuple.color {
        case .orange:
            XCTAssertEqual(value + 3, newTuple.number)
        case .blue:
            XCTAssertEqual(value + 1, newTuple.number)
        }
    }
    
    func testResetRandomElementCounter() throws {
        sut.onTimerCounting() // Create one element
        testDecisionProvider.testDecision = .resetCounter
        sut.performRandomElementChanges(index: 0)
        guard let newTuple = sut.elementsTuples.first else {
            XCTFail()
            return
        }
        XCTAssertEqual(0, newTuple.number)
        
    }
    
    func testDeleteRandomElement() throws {
        sut.onTimerCounting() // Create one element
        
        let countBefore = sut.elementsTuples.count
        testDecisionProvider.testDecision = .delete
        sut.performRandomElementChanges(index: 0)
        
        let countAfter = sut.elementsTuples.count
        
        XCTAssertEqual(countBefore - 1, countAfter)
    }
    
    func testAddValueOfAnElementBefore() throws { // To be improved : divide into 4 tests
        sut.onTimerCounting() // Create first element
        sut.onTimerCounting() // Create second element
        guard let firstTuple = sut.elementsTuples.first else {
            XCTFail()
            return
        }
        guard let secondValue = sut.elementsTuples.last?.number else {
            XCTFail()
            return
        }
        
        testDecisionProvider.testDecision = .addBeforeModulo
        sut.performRandomElementChanges(index: 1)
        
        guard let newTuple = sut.elementsTuples.last else {
            XCTFail()
            return
        }
        switch newTuple.color {
        case .orange:
            switch firstTuple.color {
            case .orange:
                XCTAssertEqual(firstTuple.number + secondValue, newTuple.number)
            case .blue:
                XCTAssertEqual(firstTuple.number * 3 + secondValue, newTuple.number)
            }
        case .blue:
            switch firstTuple.color {
            case .orange:
                XCTAssertEqual(firstTuple.number % 3, 0)
                XCTAssertEqual(firstTuple.number / 3 + secondValue, newTuple.number)
            case .blue:
                XCTAssertEqual(firstTuple.number + secondValue, newTuple.number)
            }
        }
    }
}
